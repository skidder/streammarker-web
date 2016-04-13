# load submodules, here just for example
Eye.load('./eye/*.rb')

# Eye self-configuration section
Eye.config do
  logger '/tmp/eye.log'
end
