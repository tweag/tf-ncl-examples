{
  uniq | Array Dyn -> Array Dyn =
      let go : { visited : {_: {}}, out : Array Dyn } -> Dyn -> { visited : {_: {}}, out : Array Dyn } =
        fun acc nxt =>
          let as_str = builtin.serialize `Json nxt in
          if record.has_field as_str acc.visited then
            acc
          else
            { visited = record.insert as_str {} acc.visited, out = acc.out @ [nxt] }
      in fun arr =>
        (array.foldl go { visited = ({} | {_: {}}), out = [] } (arr | Array Dyn)).out
} : _
