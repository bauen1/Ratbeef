return {
  ["server"] = "irc.esper.net",
  ["port"] = "6667"
  ["ssl"] = false
  ["nickname"] = "Ratbeef"
  ["username"] = "Ratbeef"
  ["connect_commands"] = {
    "PRIVMSG NickServ :identify ".."passwordhere"..""
    "PRIVMSG bauen1 :I'm here!"
  }
  ["admins"] = {
    "bauen1"
  },
  ["trusted"] = {
    "MrRatermat",
    "vifino",
    "ds84182",
    "bauen1"
  },
  ["channels"] = {"#V"},
  ["blacklistChannels"] = {"#oc"}, -- Dont spam #oc
  ["blacklistAcc"] = {"ping"}
  ["prefix"] = "Ratbeef:",
  ["output_prefix"] = "Ratbot: "
}
