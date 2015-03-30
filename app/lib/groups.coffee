module.exports =
  if !!~location.pathname.indexOf('beta') || +location.port is 2020
    mediterranean: '5515b76b7b9f996fb3000001'
    original: '5515b4d07b9f996a1b000001'
    all: true
  else
    mediterranean: ''
    original: ''
    all: true