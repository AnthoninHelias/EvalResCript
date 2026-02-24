@react.component
let make = (~onStart: string => unit) => {
  let (name, setName) = React.useState(() => "")

  let handleSubmit = e => {
    ReactEvent.Form.preventDefault(e)
    if String.length(name) > 0 {
      onStart(name)
    }
  }

  <div className="page home-page">
    <h1> {React.string("QCM")} </h1>
    <h2> {React.string("Bienvenue au Quiz !")} </h2>
    <form onSubmit=handleSubmit>
      <div className="input-group">
        <label htmlFor="player-name"> {React.string("Votre nom :")} </label>
        <input
          id="player-name"
          type_="text"
          placeholder="Entrez votre nom"
          value=name
          onChange={e => setName(_ => ReactEvent.Form.target(e)["value"])}
          className="name-input"
        />
      </div>
      <button
        type_="submit"
        disabled={String.length(name) == 0}
        className="btn btn-primary">
        {React.string("Commencer")}
      </button>
    </form>
  </div>
}
