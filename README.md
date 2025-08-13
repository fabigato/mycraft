# mycraft
a collection of scripts, utilities and documentation for the maintenance of a minecraft server

I use PaperMC as server, and recommend Prismlauncher as client, to install simple audio chat

# Useful plugins
## Server side
- LuckPerms for permissions
    - yaml database format is preferred to make it console readable
    - use the default group to give permissions to all of the voicechat nodes (voicechat.use, etc) to every player, since every player is added to luckperms default group by default
    - ````
      /lp group default permission set voicechat.group true
      /lp group default permission set voicechat.broadcast true

- Simple voice chat. Needs voice over IP port open (forwarded) in the router
- Vanilla tweaks datapacks:
  - graves
## Client side
- Simple voice chat (both server side and client side are necessary)
- MiniHUD. You can use h+c to open the menu where you select what info to show, like time of the day or the horizontal and vertical angle you're looking at


# networking
- forwarding minecraft port to the server
- also forwarding simple voice chat port
- using dynamic dns with infomaniak to assign a fixed domain name

# Useful tools
- MCEdit to copy/export/delete chunks
  - example command:
  - ````
    /path/to/zulu21app/zulu21.32.17-ca-fx-jre21.0.2-macosx_aarch64/zulu-21.jre/Contents/Home/bin/java -jar /path/to/mcaselector-2.5.3.jar
    
# useful commands
- backup world:
  - ```
    rsync -avL --progress -e "ssh -i .ssh/your_authentication_key" minecraft@raspberrypi:/opt/minecraft/server/world ~/localpath/minecraft/world_20250811
- server ssh authenticatie
  - ```
    touch ~/.ssh/authorized_keys
  - dan plak je daarin je publieke key, bijvoorbeeld ssh-rsa AAA...

# Useful minecraft server configs
- enforce-whitelist=true
  - then use /whitelist add <player mojang id>  # not microsoft id!
- motfd="server public description message
- in commands.yml (this is from bukkit, therefore papermc has it too)
  - gospectator
    - gamemode spectator
  - then you can use luckperms to enable a player to use that command specifically:
    - ```
      /lp user <player> permission set bukkit.command.gospectator true
      /lp user <player> permission set minecraft.command.gamemode false  # gamemode is too powerful, they can change the mode even of other players
    