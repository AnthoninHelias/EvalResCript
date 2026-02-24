type page =
  | Home
  | Quiz
  | End

@react.component
let make = () => {
  let (page, setPage) = React.useState(() => Home)
  let (playerName, setPlayerName) = React.useState(() => "")
  let (score, setScore) = React.useState(() => 0)

  switch page {
  | Home =>
    <HomePage
      onStart={name => {
        setPlayerName(_ => name)
        setPage(_ => Quiz)
      }}
    />
  | Quiz =>
    <QuizPage
      onComplete={finalScore => {
        setScore(_ => finalScore)
        setPage(_ => End)
      }}
    />
  | End =>
    <EndPage
      playerName
      score
      onReplay={() => {
        setScore(_ => 0)
        setPage(_ => Home)
      }}
    />
  }
}
