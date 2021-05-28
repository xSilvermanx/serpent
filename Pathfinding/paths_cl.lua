--[[ListNodes = {
  ["PALETO-1"] = {
    id="PALETO-1",
    x=-373.11,
    y=6002.38,
    z=31.38,
    paths = {
      {id = "PALETO-2", S = 30, SMult = 3.0, NoPed = true}, -- NoVeh, AbsNoVeh, NoPed, SMult (2 .. 3), IsActualPath
      {id = "PALETO-28", S = 30, SMult = 3.0}, -- name, speed in mph (20, 30, 40, 60)
      {id = "PALETO-29", S = 30, SMult = 3.0, NoVeh = true}, -- delete this later
      {id = "PALETO-30", S = 30, SMult = 3.0, NoVeh = true},
    },
    intersection = true,
  },
  ["PALETO-2"] = {
    id="PALETO-2",
    x=-322.41,
    y=6054.02,
    z=31.17,
    paths = {
      {id = "PALETO-1", S = 30, SMult = 3.0, NoPed = true},
      {id = "PALETO-3", S = 30, SMult = 3.0},
      {id = "PALETO-31", S = 20, SMult = 3.0, IsActualPath = true},
    },
    intersection = false,
  },
  ["PALETO-3"] = {
    id="PALETO-3",
    x=-225.39,
    y=6150.9,
    z=31.2,
    paths = {
      {id = "PALETO-2", S = 30, SMult = 3.0},
      {id = "PALETO-4", S = 30, SMult = 3.0},
      {id = "PALETO-34", S = 30, SMult = 3.0},
    },
    intersection = true,
  },
  ["PALETO-4"] = {
    id="PALETO-4",
    x=-181.72,
    y=6195.21,
    z=31.2,
    paths = {
      {id = "PALETO-3", S = 30, SMult = 3.0},
      {id = "PALETO-5", S = 30, SMult = 3.0},
      {id = "PALETO-33", S = 20, SMult = 3.0, IsActualPath = true},
    },
    intersection = false,
  },
  ["PALETO-5"] = {
    id="PALETO-5",
    x=-95.48,
    y=6280.64,
    z=31.32,
    paths = {
      {id = "PALETO-4", S = 30, SMult = 3.0},
      {id = "PALETO-6", S = 30, SMult = 3.0},
      {id = "PALETO-19", S = 30, SMult = 3.0},
    },
    intersection = true,
  },
  ["PALETO-6"] = {
    id="PALETO-6",
    x=-59.24,
    y=6317.39,
    z=31.3,
    paths = {
      {id = "PALETO-5", S = 30, SMult = 3.0},
      {id = "PALETO-7", S = 30, SMult = 3.0},
      {id = "PALETO-38", S = 20, SMult = 3.0},
    },
    intersection = false,
  },
  ["PALETO-7"] = {
    id="PALETO-7",
    x=30.55,
    y=6408.09,
    z=31.29,
    paths = {
      {id = "PALETO-6", S = 30, SMult = 3.0},
      {id = "PALETO-8", S = 30, SMult = 3.0},
      {id = "PALETO-46", S = 20, SMult = 3.0, IsActualPath = true},
    },
    intersection = false,
  },
  ["PALETO-8"] = {
    id="PALETO-8",
    x=62.43,
    y=6440.27,
    z=31.3,
    paths = {
      {id = "PALETO-7", S = 30, SMult = 3.0},
      {id = "PALETO-9", S = 30, SMult = 3.0, NoPed = true},
      {id = "PALETO-45", S = 20, SMult = 3.0, IsActualPath = true},
    },
    intersection = true,
  },
  ["PALETO-9"] = {
    id="PALETO-9",
    x=154.96,
    y=6527.84,
    z=31.7,
    paths = {
      {id = "PALETO-8", S = 30, SMult = 3.0, NoPed = true},
      {id = "PALETO-11", S = 30, SMult = 3.0, NoPed = true},
      {id = "PALETO-12", S = 30, SMult = 3.0, NoPed = true},
      {id = "PALETO-54", S = 20, SMult = 3.0, NoVeh = true},
    },
    intersection = true,
  },
  ["PALETO-10"] = {
    id="PALETO-10",
    x=417.67,
    y=6569.8,
    z=27.31,
    paths = {
      {id = "PALETO-11", S = 30, SMult = 3.0, NoPed = true},
    },
    intersection = false,
  },
  ["PALETO-11"] = {
    id="PALETO-11",
    x=204.02,
    y=6554.87,
    z=31.92,
    paths = {
      {id = "PALETO-10", S = 30, SMult = 3.0, NoPed = true},
      {id = "PALETO-9", S = 30, SMult = 3.0, NoPed = true},
      {id = "PALETO-48", S = 20, SMult = 3.0, NoPed = true, IsActualPath = true},
    },
    intersection = false,
  },
  ["PALETO-12"] = {
    id="PALETO-12",
    x=115.59,
    y=6567.27,
    z=31.65,
    paths = {
      {id = "PALETO-9", S = 30, SMult = 3.0, NoPed = true},
      {id = "PALETO-13", S = 30, SMult = 3.0, NoPed = true},
      {id = "PALETO-55", S = 20, SMult = 3.0, NoPed = true},
    },
    intersection = false,
  },
  ["PALETO-13"] = {
    id="PALETO-13",
    x=74.08,
    y=6609.55,
    z=31.57,
    paths = {
      {id = "PALETO-12", S = 30, SMult = 3.0, NoPed = true},
      {id = "PALETO-14", S = 30, SMult = 3.0},
      {id = "PALETO-72", S = 30, SMult = 3.0},
      {id = "PALETO-52", S = 20, SMult = 3.0, IsActualPath = true},
    },
    intersection = true,
  },
  ["PALETO-14"] = {
    id="PALETO-14",
    x=10.45,
    y=6545.62,
    z=31.44,
    paths = {
      {id = "PALETO-13", S = 30, SMult = 3.0},
      {id = "PALETO-15", S = 30, SMult = 3.0},
      {id = "PALETO-56", S = 20, SMult = 3.0, IsActualPath = true},
    },
    intersection = false,
  },
  ["PALETO-15"] = {
    id="PALETO-15",
    x=-25.25,
    y=6509.94,
    z=31.44,
    paths = {
      {id = "PALETO-14", S = 30, SMult = 3.0},
      {id = "PALETO-16", S = 30, SMult = 3.0},
      {id = "PALETO-57", S = 20, SMult = 3.0, IsActualPath = true},
    },
    intersection = false,
  },
  ["PALETO-16"] = {
    id="PALETO-16",
    x=-66.62,
    y=6467.88,
    z=31.44,
    paths = {
      {id = "PALETO-15", S = 30, SMult = 3.0},
      {id = "PALETO-17", S = 30, SMult = 3.0},
      {id = "PALETO-47", S = 20, SMult = 3.0, IsActualPath = true},
    },
    intersection = false,
  },
  ["PALETO-17"] = {
    id="PALETO-17",
    x=-97.27,
    y=6434.53,
    z=31.46,
    paths = {
      {id = "PALETO-16", S = 30, SMult = 3.0},
      {id = "PALETO-18", S = 30, SMult = 3.0},
      {id = "PALETO-58", S = 20, SMult = 3.0, IsActualPath = true},
    },
    intersection = false,
  },
  ["PALETO-18"] = {
    id="PALETO-18",
    x=-111.99,
    y=6419.25,
    z=31.45,
    paths = {
      {id = "PALETO-17", S = 30, SMult = 3.0},
      {id = "PALETO-19", S = 30, SMult = 3.0},
      {id = "PALETO-59", S = 30, SMult = 3.0},
    },
    intersection = true,
  },
  ["PALETO-19"] = {
    id="PALETO-19",
    x=-174.38,
    y=6359.95,
    z=31.52,
    paths = {
      {id = "PALETO-18", S = 30, SMult = 3.0},
      {id = "PALETO-20", S = 30, SMult = 3.0},
      {id = "PALETO-5", S = 30, SMult = 3.0},
    },
    intersection = true,
  },
  ["PALETO-20"] = {
    id="PALETO-20",
    x=-219.43,
    y=6314.87,
    z=31.5,
    paths = {
      {id = "PALETO-19", S = 30, SMult = 3.0},
      {id = "PALETO-21", S = 30, SMult = 3.0},
      {id = "PALETO-60", S = 20, SMult = 3.0},
    },
    intersection = false,
  },
  ["PALETO-21"] = {
    id="PALETO-21",
    x=-246.18,
    y=6288.44,
    z=31.51,
    paths = {
      {id = "PALETO-20", S = 30, SMult = 3.0},
      {id = "PALETO-22", S = 30, SMult = 3.0},
      {id = "PALETO-61", S = 30, SMult = 3.0, NoVeh = true},
    },
    intersection = false,
  },
  ["PALETO-22"] = {
    id="PALETO-22",
    x=-304.33,
    y=6231.54,
    z=31.45,
    paths = {
      {id = "PALETO-21", S = 30, SMult = 3.0},
      {id = "PALETO-23", S = 30, SMult = 3.0},
      {id = "PALETO-35", S = 30, SMult = 3.0},
      {id = "PALETO-66", S = 30, SMult = 3.0},
    },
    intersection = true,
  },
  ["PALETO-23"] = {
    id="PALETO-23",
    x=-375.71,
    y=6158.47,
    z=31.39,
    paths = {
      {id = "PALETO-22", S = 30, SMult = 3.0},
      {id = "PALETO-24", S = 30, SMult = 3.0},
      {id = "PALETO-64", S = 30, SMult = 3.0},
    },
    intersection = true,
  },
  ["PALETO-24"] = {
    id="PALETO-24",
    x=-392.8,
    y=6142.57,
    z=31.61,
    paths = {
      {id = "PALETO-23", S = 30, SMult = 3.0},
      {id = "PALETO-25", S = 30, SMult = 3.0},
      {id = "PALETO-62", S = 20, SMult = 3.0, IsActualPath = true},
    },
    intersection = false,
  },
  ["PALETO-25"] = {
    id="PALETO-25",
    x=-427.93,
    y=6104.05,
    z=31.86,
    paths = {
      {id = "PALETO-24", S = 30, SMult = 3.0},
      {id = "PALETO-26", S = 30, SMult = 3.0},
    },
    intersection = false,
  },
  ["PALETO-26"] = {
    id="PALETO-26",
    x=-437.29,
    y=6075.09,
    z=31.27,
    paths = {
      {id = "PALETO-25", S = 30, SMult = 3.0},
      {id = "PALETO-27", S = 30, SMult = 3.0},
    },
    intersection = false,
  },
  ["PALETO-27"] = {
    id="PALETO-27",
    x=-423.36,
    y=6047.3,
    z=31.41,
    paths = {
      {id = "PALETO-26", S = 30, SMult = 3.0},
      {id = "PALETO-28", S = 30, SMult = 3.0},
      {id = "PALETO-63", S = 20, SMult = 3.0, IsActualPath = true},
    },
    intersection = false,
  },
  ["PALETO-28"] = {
    id="PALETO-28",
    x=-412.88,
    y=6036.19,
    z=31.28,
    paths = {
      {id = "PALETO-27", S = 30, SMult = 3.0},
      {id = "PALETO-29", S = 30, SMult = 3.0},
      {id = "PALETO-30", S = 30, SMult = 3.0},
      {id = "PALETO-32", S = 20, SMult = 3.0, IsActualPath = true},
    },
    intersection = false,
  },
  ["PALETO-29"] = {
    id="PALETO-29",
    x=-413.02,
    y=5966.87,
    z=31.75,
    paths = {
      {id = "PALETO-1", S = 30, SMult = 3.0}, --delete this later
      {id = "PALETO-28", S = 30, SMult = 3.0, NoVeh = true},
    },
    intersection = false,
  },
  ["PALETO-30"] = {
    id="PALETO-30",
    x=-387.9,
    y=6010.79,
    z=31.45,
    paths = {
      {id = "PALETO-1", S = 30, SMult = 3.0, NoVeh = true},
      {id = "PALETO-2", S = 30, SMult = 3.0},
      {id = "PALETO-30", S = 30, SMult = 3.0, NoVeh = true},
    },
    intersection = false,
  },
  ["PALETO-31"] = {
    id="PALETO-31",
    x=-349.55,
    y=6081.79,
    z=31.38,
    paths = {
      {id = "PALETO-2", S = 20, SMult = 3.0, IsActualPath = true},
      {id = "PALETO-32", S = 20, SMult = 3.0, IsActualPath = true},
    },
    intersection = false,
  },
  ["PALETO-32"] = {
    id="PALETO-32",
    x=-380.52,
    y=6068.55,
    z=31.5,
    paths = {
      {id = "PALETO-31", S = 20, SMult = 3.0, IsActualPath = true},
      {id = "PALETO-28", S = 20, SMult = 3.0, IsActualPath = true},
    },
    intersection = false,
  },
  ["PALETO-33"] = {
    id="PALETO-33",
    x=-203.82,
    y=6219.41,
    z=31.49,
    paths = {
      {id = "PALETO-4", S = 20, SMult = 3.0, IsActualPath = true},
      {id = "PALETO-36", S = 20, SMult = 3.0, IsActualPath = true},
    },
    intersection = false,
  },
  ["PALETO-34"] = {
    id="PALETO-34",
    x=-248.13,
    y=6173.88,
    z=31.46,
    paths = {
      {id = "PALETO-36", S = 20, SMult = 3.0, IsActualPath = true},
      {id = "PALETO-35", S = 30, SMult = 3.0},
      {id = "PALETO-3", S = 30, SMult = 3.0},
    },
    intersection = false,
  },
  ["PALETO-35"] = {
    id="PALETO-35",
    x=-274.4,
    y=6201.88,
    z=31.49,
    paths = {
      {id = "PALETO-34", S = 30, SMult = 3.0},
      {id = "PALETO-37", S = 20, SMult = 3.0, IsActualPath = true},
      {id = "PALETO-22", S = 30, SMult = 3.0},
    },
    intersection = false,
  },
  ["PALETO-36"] = {
    id="PALETO-36",
    x=-234.34,
    y=6187.55,
    z=31.49,
    paths = {
      {id = "PALETO-33", S = 20, SMult = 3.0, IsActualPath = true},
      {id = "PALETO-34", S = 20, SMult = 3.0, IsActualPath = true},
      {id = "PALETO-37", S = 20, SMult = 3.0, IsActualPath = true},
    },
    intersection = false,
  },
  ["PALETO-37"] = {
    id="PALETO-37",
    x=-261.19,
    y=6215.26,
    z=31.49,
    paths = {
      {id = "PALETO-35", S = 20, SMult = 3.0, IsActualPath = true},
      {id = "PALETO-36", S = 20, SMult = 3.0, IsActualPath = true},
    },
    intersection = false,
  },
  ["PALETO-38"] = {
    id="PALETO-38",
    x=-15.55,
    y=6261.45,
    z=31.24,
    paths = {
      {id = "PALETO-6", S = 20, SMult = 3.0},
      {id = "PALETO-39", S = 20, SMult = 3.0, IsActualPath = true},
    },
    intersection = false,
  },
  ["PALETO-39"] = {
    id="PALETO-39",
    x=82.88,
    y=6313.04,
    z=31.25,
    paths = {
      {id = "PALETO-38", S = 20, SMult = 3.0, IsActualPath = true},
      {id = "PALETO-40", S = 20, SMult = 3.0, IsActualPath = true},
    },
    intersection = false,
  },
  ["PALETO-40"] = {
    id="PALETO-40",
    x=60.38,
    y=6357.84,
    z=31.26,
    paths = {
      {id = "PALETO-44", S = 20, SMult = 3.0, IsActualPath = true},
      {id = "PALETO-41", S = 20, SMult = 3.0, IsActualPath = true},
      {id = "PALETO-39", S = 20, SMult = 3.0, IsActualPath = true},
    },
    intersection = false,
  },
  ["PALETO-41"] = {
    id="PALETO-41",
    x=11.06,
    y=6328.15,
    z=31.24,
    paths = {
      {id = "PALETO-40", S = 20, SMult = 3.0, IsActualPath = true},
      {id = "PALETO-42", S = 20, SMult = 3.0, IsActualPath = true},
    },
    intersection = false,
  },
  ["PALETO-42"] = {
    id="PALETO-42",
    x=10.31,
    y=6343.76,
    z=31.26,
    paths = {
      {id = "PALETO-41", S = 20, SMult = 3.0, IsActualPath = true},
      {id = "PALETO-43", S = 20, SMult = 3.0, IsActualPath = true},
    },
    intersection = false,
  },
  ["PALETO-43"] = {
    id="PALETO-43",
    x=68.72,
    y=6394.85,
    z=31.25,
    paths = {
      {id = "PALETO-42", S = 20, SMult = 3.0, IsActualPath = true},
      {id = "PALETO-44", S = 20, SMult = 3.0, IsActualPath = true},
    },
    intersection = false,
  },
  ["PALETO-44"] = {
    id="PALETO-44",
    x=84.45,
    y=6378.98,
    z=31.23,
    paths = {
      {id = "PALETO-43", S = 20, SMult = 3.0, IsActualPath = true},
      {id = "PALETO-45", S = 20, SMult = 3.0, IsActualPath = true},
      {id = "PALETO-40", S = 20, SMult = 3.0, IsActualPath = true},
    },
    intersection = false,
  },
  ["PALETO-45"] = {
    id="PALETO-45",
    x=109.98,
    y=6393.26,
    z=31.29,
    paths = {
      {id = "PALETO-44", S = 20, SMult = 3.0, IsActualPath = true},
      {id = "PALETO-8", S = 20, SMult = 3.0, IsActualPath = true},
    },
    intersection = false,
  },
  ["PALETO-46"] = {
    id="PALETO-46",
    x=-14.99,
    y=6456.27,
    z=31.38,
    paths = {
      {id = "PALETO-7", S = 20, SMult = 3.0, IsActualPath = true},
      {id = "PALETO-47", S = 20, SMult = 3.0, IsActualPath = true},
    },
    intersection = false,
  },
  ["PALETO-47"] = {
    id="PALETO-47",
    x=-37.6,
    y=6435.85,
    z=31.47,
    paths = {
      {id = "PALETO-46", S = 20, SMult = 3.0, IsActualPath = true},
      {id = "PALETO-16", S = 20, SMult = 3.0, IsActualPath = true},
    },
    intersection = false,
  },
  ["PALETO-48"] = {
    id="PALETO-48",
    x=192.41,
    y=6586.27,
    z=31.83,
    paths = {
      {id = "PALETO-11", S = 20, SMult = 3.0, NoVeh = true, NoPed = true, IsActualPath = true},
      {id = "PALETO-54", S = 20, SMult = 3.0, IsActualPath = true},
      {id = "PALETO-49", S = 20, SMult = 3.0, IsActualPath = true},
    },
    intersection = false,
  },
  ["PALETO-49"] = {
    id="PALETO-49",
    x=192.11,
    y=6618.49,
    z=31.74,
    paths = {
      {id = "PALETO-48", S = 20, SMult = 3.0, NoVeh = true, IsActualPath = true},
      {id = "PALETO-50", S = 20, SMult = 3.0, IsActualPath = true},
    },
    intersection = false,
  },
  ["PALETO-50"] = {
    id="PALETO-50",
    x=162.1,
    y=6613.71,
    z=31.91,
    paths = {
      {id = "PALETO-49", S = 20, SMult = 3.0, NoVeh = true, IsActualPath = true},
      {id = "PALETO-51", S = 20, SMult = 3.0, IsActualPath = true},
    },
    intersection = false,
  },
  ["PALETO-51"] = {
    id="PALETO-51",
    x=147.29,
    y=6635.01,
    z=31.64,
    paths = {
      {id = "PALETO-50", S = 20, SMult = 3.0, NoVeh = true, IsActualPath = true},
      {id = "PALETO-52", S = 20, SMult = 3.0, IsActualPath = true},
      {id = "PALETO-53", S = 20, SMult = 3.0, IsActualPath = true},
    },
    intersection = false,
  },
  ["PALETO-52"] = {
    id="PALETO-52",
    x=127.81,
    y=6662.2,
    z=31.69,
    paths = {
      {id = "PALETO-51", S = 20, SMult = 3.0, IsActualPath = true},
      {id = "PALETO-13", S = 20, SMult = 3.0, IsActualPath = true},
    },
    intersection = false,
  },
  ["PALETO-53"] = {
    id="PALETO-53",
    x=127.23,
    y=6612.89,
    z=31.85,
    paths = {
      {id = "PALETO-51", S = 20, SMult = 3.0, NoVeh = true, IsActualPath = true},
      {id = "PALETO-54", S = 20, SMult = 3.0, IsActualPath = true},
    },
    intersection = false,
  },
  ["PALETO-54"] = {
    id="PALETO-54",
    x=169.57,
    y=6561.24,
    z=31.79,
    paths = {
      {id = "PALETO-9", S = 20, SMult = 3.0, NoPed = true},
      {id = "PALETO-48", S = 20, SMult = 3.0, IsActualPath = true},
      {id = "PALETO-53", S = 20, SMult = 3.0, NoVeh = true, IsActualPath = true},
    },
    intersection = false,
  },
  ["PALETO-55"] = {
    id="PALETO-55",
    x=82.71,
    y=6561.72,
    z=31.44,
    paths = {
      {id = "PALETO-12", S = 20, SMult = 3.0, NoPed = true, IsActualPath = true},
      {id = "PALETO-56", S = 20, SMult = 3.0, IsActualPath = true},
    },
    intersection = false,
  },
  ["PALETO-56"] = {
    id="PALETO-56",
    x=48.88,
    y=6528.98,
    z=31.46,
    paths = {
      {id = "PALETO-55", S = 20, SMult = 3.0, IsActualPath = true},
      {id = "PALETO-14", S = 20, SMult = 3.0, IsActualPath = true},
    },
    intersection = false,
  },
  ["PALETO-57"] = {
    id="PALETO-57",
    x=-53.34,
    y=6545.07,
    z=31.49,
    paths = {
      {id = "PALETO-15", S = 20, SMult = 3.0, IsActualPath = true},
    },
    intersection = false,
  },
  ["PALETO-58"] = {
    id="PALETO-58",
    x=-130.86,
    y=6467.49,
    z=31.42,
    paths = {
      {id = "PALETO-59", S = 20, SMult = 3.0, IsActualPath = true},
      {id = "PALETO-17", S = 20, SMult = 3.0, IsActualPath = true},
    },
    intersection = false,
  },
  ["PALETO-59"] = {
    id="PALETO-59",
    x=-144.67,
    y=6453.19,
    z=31.53,
    paths = {
      {id = "PALETO-58", S = 20, SMult = 3.0, IsActualPath = true},
      {id = "PALETO-18", S = 30, SMult = 3.0},
      {id = "PALETO-69", S = 30, SMult = 3.0},
    },
    intersection = false,
  },
  ["PALETO-60"] = {
    id="PALETO-60",
    x=-253.87,
    y=6348.25,
    z=32.43,
    paths = {
      {id = "PALETO-20", S = 20, SMult = 3.0, NoVeh = true},
      {id = "PALETO-61", S = 20, SMult = 3.0},
    },
    intersection = false,
  },
  ["PALETO-61"] = {
    id="PALETO-61",
    x=-279.76,
    y=6321.38,
    z=32.35,
    paths = {
      {id = "PALETO-21", S = 20, SMult = 3.0},
      {id = "PALETO-60", S = 20, SMult = 3.0, NoVeh = true},
    },
    intersection = false,
  },
  ["PALETO-62"] = {
    id="PALETO-62",
    x=-376.61,
    y=6131.17,
    z=31.42,
    paths = {
      {id = "PALETO-24", S = 20, SMult = 3.0, IsActualPath = true},
    },
    intersection = false,
  },
  ["PALETO-63"] = {
    id="PALETO-63",
    x=-445.34,
    y=6034.3,
    z=31.34,
    paths = {
      {id = "PALETO-27", S = 20, SMult = 3.0, IsActualPath = true},
    },
    intersection = false,
  },
  ["PALETO-64"] = {
    id="PALETO-64",
    x=-414.17,
    y=6202.33,
    z=31.63,
    paths = {
      {id = "PALETO-23", S = 30, SMult = 3.0},
      {id = "PALETO-65", S = 30, SMult = 3.0},
    },
    intersection = false,
  },
  ["PALETO-65"] = {
    id="PALETO-65",
    x=-402.99,
    y=6278.53,
    z=29.89,
    paths = {
      {id = "PALETO-64", S = 30, SMult = 3.0},
      {id = "PALETO-66", S = 30, SMult = 3.0},
    },
    intersection = false,
  },
  ["PALETO-66"] = {
    id="PALETO-66",
    x=-369.74,
    y=6303.84,
    z=29.77,
    paths = {
      {id = "PALETO-65", S = 30, SMult = 3.0},
      {id = "PALETO-67", S = 30, SMult = 3.0},
      {id = "PALETO-22", S = 30, SMult = 3.0},
    },
    intersection = true,
  },
  ["PALETO-67"] = {
    id="PALETO-67",
    x=-284.86,
    y=6376.81,
    z=30.63,
    paths = {
      {id = "PALETO-66", S = 30, SMult = 3.0},
      {id = "PALETO-68", S = 30, SMult = 3.0},
    },
    intersection = false,
  },
  ["PALETO-68"] = {
    id="PALETO-68",
    x=-217.43,
    y=6417.32,
    z=31.55,
    paths = {
      {id = "PALETO-67", S = 30, SMult = 3.0},
      {id = "PALETO-69", S = 30, SMult = 3.0},
    },
    intersection = false,
  },
  ["PALETO-69"] = {
    id="PALETO-69",
    x=-173.24,
    y=6481.26,
    z=30.14,
    paths = {
      {id = "PALETO-59", S = 30, SMult = 3.0},
      {id = "PALETO-68", S = 30, SMult = 3.0},
      {id = "PALETO-70", S = 30, SMult = 3.0},
    },
    intersection = true,
  },
  ["PALETO-70"] = {
    id="PALETO-70",
    x=-88.21,
    y=6575.24,
    z=29.6,
    paths = {
      {id = "PALETO-69", S = 30, SMult = 3.0},
      {id = "PALETO-71", S = 30, SMult = 3.0},
    },
    intersection = false,
  },
  ["PALETO-71"] = {
    id="PALETO-71",
    x=5.33,
    y=6640.56,
    z=31.49,
    paths = {
      {id = "PALETO-70", S = 30, SMult = 3.0},
      {id = "PALETO-72", S = 30, SMult = 3.0},
    },
    intersection = false,
  },
  ["PALETO-72"] = {
    id="PALETO-72",
    x=33.63,
    y=6645.72,
    z=31.61,
    paths = {
      {id = "PALETO-70", S = 30, SMult = 3.0},
      {id = "PALETO-13", S = 30, SMult = 3.0},
    },
    intersection = false,
  },
}


for name, node in pairs(ListNodes) do
  if #node.paths ~= 0 then
    for _, link in ipairs(node.paths) do
      local blip = AddBlipForCoord(node.x, node.y, node.z)

      SetBlipSprite(blip, 399)
      SetBlipColour(blip, 1)
      SetBlipScale(blip, 0.5)
      SetBlipAsShortRange(blip, true)
      local dx = ListNodes[link.id].x
      local dy = ListNodes[link.id].y
      local rx = dx-node.x
      local ry = dy-node.y
      local angle = 0.0

      if ry > 0 then
        angle = math.atan(-rx / ry) *180 / math.pi
      elseif ry < 0 then
        angle = math.atan(-rx / ry) *180 / math.pi + 180.0
      else
        if rx > 0 then
          angle = 270
        else
          angle = 90
        end
      end

      angle = math.ceil(angle)

      SetBlipRotation(blip, angle)

      BeginTextCommandSetBlipName("STRING")
      AddTextComponentString(node.id)
      EndTextCommandSetBlipName(blip)

    end
  else
    local blip = AddBlipForCoord(node.x, node.y, node.z)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(node.id)
    EndTextCommandSetBlipName(blip)

    SetBlipColour(blip, 1)
    SetBlipSprite(blip, 148)
    SetBlipScale(blip, 0.5)
    SetBlipAsShortRange(blip, true)
  end
end]]
