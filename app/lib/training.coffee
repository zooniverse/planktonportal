# Clockwise from the top-left.

module.exports =
  icons: [
    [
      {species: 'cydippid', coords: [140, 160]}
      {species: 'larvacean', coords: [532, 75]}
      {species: 'radiolarianColonies', coords: [910, 140]}
      {species: 'solmaris', coords: [800, 270]}
      {species: 'copepod', coords: [320, 390]}
    ]

    [
      {species: 'arrowWorm', coords: [260, 120]}
      {species: 'rocketThimble', coords: [830, 370]}
      {species: 'larvacean', coords: [360, 500]}
      {species: 'medusaFourTentacles', coords: [220, 380]}
    ]

    [
      {species: 'siphoCornCob', coords: [150, 390]}
      {species: 'lobate', coords: [450, 300]}
      {species: 'lobate', coords: [880, 250]}
    ]
  ]

  guidelines: [
    '''
      M 219 28 L 162 108 M 156 42 L 228 92
      M 502 33 L 558 32 M 527 43 L 524 25
      M 1013 29 L 800 92 M 898 43 L 915 85
      M 961 402 L 894 408 M 922 339 L 942 469
      M 318 429 L 298 473 M 277 419 L 360 451
    '''

    '''
      M 195 127 L 65 84 M 139 94 L 122 117
      M 843 459 L 900 400 M 857 414 L 890 444
      M 413 504 L 442 507 M 428 496 L 425 518
      M 50 347 L 145 409 M 61 452 L 138 314
    '''

    '''
      M 269 110 L 128 270 M 174 161 L 230 206
      M 489 486 L 429 373 M 421 461 L 509 416
      M 979 441 L 702 438 M 786 299 L 814 564
    '''
  ]

  dontMark:
    singleCell: cx: 362, cy: 239, r: 20
    smallCrustacean: cx: 398, cy: 506, r: 15
    marineSnow: cx: 97, cy: 337, r: 35
