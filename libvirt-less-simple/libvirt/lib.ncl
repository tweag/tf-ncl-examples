{
  addNameField = fun l x =>
      x |> record.map (fun name r => r & { "__name" | force = "%{name}" }),

  optionalRecord : forall r. Bool -> {_: r} -> {_: r}
      = fun b r => if b then r else {},

  non_empty : forall r. {; Dyn} -> Bool
      = fun r => array.length (record.fields r) != 0,

  tf_sanitize : Str -> Str
      = string.replace_regex "(\\.)" "-",

  recordMap' | forall a b. (Str -> a -> {_: b}) -> {_: a} -> {_: b}
      = fun f r => array.fold
          (fun n acc => acc & (f n r."%{n}"))
          {}
          (record.fields r),

  NamedRecord = { "__name" | Str, .. },
}
