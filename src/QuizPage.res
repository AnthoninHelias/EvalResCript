type questionData = {
  id: int,
  title: string,
  answers: array<Api.answer>,
}

type quizState =
  | Loading
  | Playing({
      questions: array<questionData>,
      currentIndex: int,
      score: int,
      selectedIndex: option<int>,
    })
  | LoadError(string)

let shuffle: array<'a> => array<'a> = %raw(`
  function shuffle(arr) {
    const copy = arr.slice();
    for (let i = copy.length - 1; i > 0; i--) {
      const j = Math.floor(Math.random() * (i + 1));
      const tmp = copy[i];
      copy[i] = copy[j];
      copy[j] = tmp;
    }
    return copy;
  }
`)

@val external _setTimeout: (unit => unit, int) => int = "setTimeout"

@react.component
let make = (~onComplete: int => unit) => {
  let (state, setState) = React.useState(() => Loading)

  React.useEffect0(() => {
    let loadOne = async id => {
      let title = await Api.fetchQuestion(id)
      let answers = await Api.fetchAnswers(id)
      {id, title, answers: shuffle(answers)}
    }

    let loadAll = async () => {
      try {
        let q1 = await loadOne(1)
        let q2 = await loadOne(2)
        let q3 = await loadOne(3)
        let q4 = await loadOne(4)
        let questions = shuffle([q1, q2, q3, q4])
        setState(_ =>
          Playing({
            questions,
            currentIndex: 0,
            score: 0,
            selectedIndex: None,
          })
        )
      } catch {
      | _ => setState(_ => LoadError("Erreur lors du chargement des questions."))
      }
    }

    loadAll()->ignore
    None
  })

  let handleAnswer = (isCorrect: bool, answerIndex: int) => {
    switch state {
    | Playing({questions, currentIndex, score, selectedIndex: None}) =>
      let newScore = isCorrect ? score + 1 : score
      setState(_ =>
        Playing({
          questions,
          currentIndex,
          score: newScore,
          selectedIndex: Some(answerIndex),
        })
      )
      let _ = _setTimeout(
        () => {
          let nextIndex = currentIndex + 1
          if nextIndex >= Array.length(questions) {
            onComplete(newScore)
          } else {
            setState(_ =>
              Playing({
                questions,
                currentIndex: nextIndex,
                score: newScore,
                selectedIndex: None,
              })
            )
          }
        },
        1000,
      )
    | _ => ()
    }
  }

  switch state {
  | Loading =>
    <div className="page">
      <div className="loading"> {React.string("Chargement des questions...")} </div>
    </div>
  | LoadError(msg) =>
    <div className="page">
      <div className="error"> {React.string(msg)} </div>
    </div>
  | Playing({questions, currentIndex, score, selectedIndex}) =>
    let total = Array.length(questions)
    <div className="page quiz-page">
      <div className="score-badge">
        {React.string("Score : " ++ Int.toString(score))}
      </div>
      <div className="question-number">
        {React.string(
          "Question " ++ Int.toString(currentIndex + 1) ++ " / " ++ Int.toString(total),
        )}
      </div>
      <h2 className="question-title"> {React.string(Belt.Array.getUnsafe(questions, currentIndex).title)} </h2>
      <div className="answers-grid">
        {Belt.Array.getUnsafe(questions, currentIndex).answers
        ->Belt.Array.mapWithIndex((i, answer) => {
          let buttonClass = switch selectedIndex {
          | None => "btn answer-btn"
          | Some(selectedI) =>
            if answer.correct {
              "btn answer-btn correct"
            } else if i == selectedI {
              "btn answer-btn incorrect"
            } else {
              "btn answer-btn"
            }
          }
          <button
            key={Int.toString(i)}
            className=buttonClass
            onClick={_ => handleAnswer(answer.correct, i)}
            disabled={Option.isSome(selectedIndex)}>
            {React.string(answer.title)}
          </button>
        })
        ->React.array}
      </div>
    </div>
  }
}
