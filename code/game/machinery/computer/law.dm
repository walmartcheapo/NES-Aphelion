//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

/obj/machinery/computer/aiupload
	name = "\improper AI upload console"
	desc = "Used to upload laws to the AI."
	icon_state = "command"
	circuit = "/obj/item/weapon/circuitboard/aiupload"
	var/mob/living/silicon/ai/current = null
	var/opened = 0


	verb/AccessInternals()
		set category = "Object"
		set name = "Access Computer's Internals"
		set src in oview(1)
		if(get_dist(src, usr) > 1 || usr.restrained() || usr.lying || usr.stat || istype(usr, /mob/living/silicon))
			return

		opened = !opened
		if(opened)
			usr << "\blue The access panel is now open."
		else
			usr << "\blue The access panel is now closed."
		return


	attackby(obj/item/weapon/O as obj, mob/user as mob)
		if (user.z > 8)
			user << "\red <b>Unable to establish a connection</b>: \black You're too far away from the station!"
			return
		if(istype(O, /obj/item/weapon/aiModule))
			var/obj/item/weapon/aiModule/M = O
			M.install(src)
			if(current)
				var/log
				if(istype(M,/obj/item/weapon/aiModule/freeform))
					var/obj/item/weapon/aiModule/freeform/F = M
					log = "\blue [M.name] installed into [current] by [user.key] law was [F.newFreeFormLaw]."
				else if(istype(M,/obj/item/weapon/aiModule/freeformcore))
					var/obj/item/weapon/aiModule/freeformcore/F = M
					log = "\blue [M.name] installed into [current] by [user.key] law was [F.newFreeFormLaw]."
				else if(istype(M,/obj/item/weapon/aiModule/syndicate))
					var/obj/item/weapon/aiModule/syndicate/F = M
					log = "\blue [M.name] installed into [current] by [user.key] law was [F.newFreeFormLaw]."
				else
					log ="\blue [M.name] installed into [current] by [user.key]."
				log_game(log)
				message_admins(log)
		else
			..()


	attack_hand(var/mob/user as mob)
		if(src.stat & NOPOWER)
			usr << "The upload computer has no power!"
			return
		if(src.stat & BROKEN)
			usr << "The upload computer is broken!"
			return

		src.current = select_active_ai(user)

		if (!src.current)
			usr << "No active AIs detected."
		else
			usr << "[src.current.name] selected for law changes."
		return
	
	attack_ghost(user as mob)
		return 1


/obj/machinery/computer/borgupload
	name = "cyborg upload console"
	desc = "Used to upload laws to Cyborgs."
	icon_state = "command"
	circuit = "/obj/item/weapon/circuitboard/borgupload"
	var/mob/living/silicon/robot/current = null


	attackby(obj/item/weapon/aiModule/module as obj, mob/user as mob)
		if(istype(module, /obj/item/weapon/aiModule))
			module.install(src)
		else
			return ..()


	attack_hand(var/mob/user as mob)
		if(src.stat & NOPOWER)
			usr << "The upload computer has no power!"
			return
		if(src.stat & BROKEN)
			usr << "The upload computer is broken!"
			return

		src.current = freeborg()

		if (!src.current)
			usr << "No free cyborgs detected."
		else
			usr << "[src.current.name] selected for law changes."
		return

	attack_ghost(user as mob)
		return 1
