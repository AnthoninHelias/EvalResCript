@react.component
let make = (~playerName: string, ~score: int, ~onReplay: unit => unit) => {
  let message = if score == 4 {
    "Score parfait !"
  } else if score >= 3 {
    "Excellent résultat !"
  } else if score >= 2 {
    "Bon travail !"
  } else {
    "Continuez à vous entraîner !"
  }

  <div className="page end-page">
    <h1> {React.string("Bravo !")} </h1>
    <h2> {React.string(playerName)} </h2>
    <div className="final-score">
      {React.string(Int.toString(score) ++ " / 4")}
    </div>
    <div className="score-label"> {React.string(message)} </div>
    <button className="btn btn-primary" onClick={_ => onReplay()}>
      {React.string("Rejouer")}
    </button>
  </div>
}
