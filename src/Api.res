type answer = {
  title: string,
  correct: bool,
}

@module("./api.js") external fetchQuestion: int => promise<string> = "fetchQuestion"
@module("./api.js") external fetchAnswers: int => promise<array<answer>> = "fetchAnswers"
