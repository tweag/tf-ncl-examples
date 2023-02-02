{
  merge_array | Array {_: Dyn} -> {_: Dyn}
    = fun rs => array.foldl (fun r x => r & x) {} rs,

  traceVal = fun x => builtin.trace (builtin.serialize `Json x) x,

  Elaborate | Str -> (Str -> Dyn) -> Dyn -> {_: Dyn} -> {_: Dyn}
    = fun field elaborate _l r =>
        record.fields r |> array.foldl (fun r name => r & { "%{name}"."%{field}" = elaborate name }) r,
}
