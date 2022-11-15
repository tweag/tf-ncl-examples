{
  optionalRecord : forall r. Bool -> {_: r} -> {_: r}
      = fun b r => if b then r else {},

  nonEmpty : forall r. {; Dyn} -> Bool
      = fun r => array.length (record.fields r) != 0,

  tfSanitize : Str -> Str
      = string.replace_regex "(\\.)" "-",

  recordMap' | forall a b. (Str -> a -> {_: b}) -> {_: a} -> {_: b}
      = fun f r => array.fold
          (fun n acc => acc & (f n r."%{n}"))
          {}
          (record.fields r),

  NamedRecord = { "name__" | Str, .. },

  addNameField = fun l x =>
      x |> record.map (fun name r => r & {
        "name__" | force = "%{name}",
        "sanitizedName__" | default = tfSanitize name__,
      }),
}
