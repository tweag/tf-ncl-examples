let Tf = import "./schema.ncl" in
{
  config | Tf.Configuration = {},
  renderable_config = Tf.mkConfig config,
}
