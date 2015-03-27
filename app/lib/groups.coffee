module.exports =
  if !!~location.hostname.indexOf('beta') || +location.port is 2020
    mediterranean: '5515b76b7b9f996fb3000001'
    all: true
  else
    mediterranean: ''
    all: true