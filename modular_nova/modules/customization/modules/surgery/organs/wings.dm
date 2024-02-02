/obj/item/organ/external/wings
	name = "wings"
	desc = "A pair of wings. Those may or may not allow you to fly... or at the very least flap."
	zone = BODY_ZONE_CHEST
	slot = ORGAN_SLOT_WINGS
	mutantpart_key = "wings"
	mutantpart_info = list(MUTANT_INDEX_NAME = "Bat", MUTANT_INDEX_COLOR_LIST = list("#335533"))
	///Whether the wings should grant flight on insertion.
	var/unconditional_flight
	///What species get flights thanks to those wings. Important for moth wings
	var/list/flight_for_species
	///Whether a wing can be opened by the *wing emote. The sprite use a "_open" suffix, before their layer
	var/can_open
	///Whether an openable wing is currently opened
	var/is_open
	///Whether the owner of wings has flight thanks to the wings
	var/granted_flight

/datum/bodypart_overlay/mutant/wings
	color_source = ORGAN_COLOR_OVERRIDE

/datum/bodypart_overlay/mutant/wings/get_global_feature_list()
	return GLOB.sprite_accessories["wings"]

//TODO: Well you know what this flight stuff is a bit complicated and hardcoded, this is enough for now

/datum/bodypart_overlay/mutant/wings/override_color(rgb_value)
	return draw_color

/obj/item/organ/external/wings/moth
	name = "moth wings"
	desc = "A pair of fuzzy moth wings."
	flight_for_species = list(SPECIES_MOTH)
	actions_types = list(/datum/action/cooldown/spell/touch/moth_climb, /datum/action/cooldown/spell/moth_and_dash)
	///Our associated shadow jaunt spell, for all nightmares
	var/datum/action/cooldown/spell/touch/moth_climb/our_climb
	///Our associated terrorize spell, for antagonist nightmares
	var/datum/action/cooldown/spell/moth_and_dash/our_dash

/obj/item/organ/external/wings/moth/on_mob_insert(mob/living/carbon/organ_owner, special, movement_flags)
	. = ..()

	if(ismoth(organ_owner))
		our_climb = new(organ_owner)
		our_climb.Grant(organ_owner)

		our_dash = new(organ_owner)
		our_dash.Grant(organ_owner)

/obj/item/organ/external/wings/moth/on_mob_remove(mob/living/carbon/organ_owner)
	. = ..()
	QDEL_NULL(our_climb)
	QDEL_NULL(our_dash)

/datum/action/cooldown/spell/moth_and_dash
	name = "Flap Wings"
	desc = "Forces your wings against the air, even if there's gravity."
	button_icon = 'icons/mob/human/species/moth/moth_wings.dmi'
	button_icon_state = "m_moth_wings_gothic_BEHIND"
	check_flags = AB_CHECK_CONSCIOUS|AB_CHECK_HANDS_BLOCKED|AB_CHECK_INCAPACITATED
	invocation_type = INVOCATION_NONE
	spell_requirements = NONE
	antimagic_flags = NONE
	var/jumpdistance = 5 //-1 from to see the actual distance, e.g 4 goes over 3 tiles
	var/jumpspeed = 3
	var/recharging_rate = 60 //default 6 seconds between each dash
	var/recharging_time = 0 //time until next dash
	var/datum/weakref/dash_action_ref

/datum/action/cooldown/spell/moth_and_dash/Trigger(trigger_flags, action, target)
	if (!isliving(owner))
		return

	if(recharging_time > world.time)
		to_chat(owner, span_warning("Your wings are extraordinarily tired, give them some rest!"))
		return

	var/atom/dash_target = get_edge_target_turf(owner, owner.dir) //gets the user's direction

	ADD_TRAIT(owner, TRAIT_MOVE_FLOATING, LEAPING_TRAIT)  //Throwing itself doesn't protect mobs against lava (because gulag).
	if (owner.throw_at(dash_target, jumpdistance, jumpspeed, spin = FALSE, diagonals_first = TRUE, callback = TRAIT_CALLBACK_REMOVE(owner, TRAIT_MOVE_FLOATING, LEAPING_TRAIT)))
		playsound(owner, 'sound/voice/moth/moth_flutter.ogg', 50, TRUE, TRUE)
		owner.visible_message(span_warning("[usr] propels themselves forwards with a heavy wingbeat!"))
		recharging_time = world.time + recharging_rate
	else
		to_chat(owner, span_warning("Something prevents you from dashing forward!"))

/datum/emote/living/mothic_dash
	key = "mdash"
	key_third_person = "mdash"
	cooldown = 6 SECONDS

/datum/emote/living/mothic_dash/run_emote(mob/living/user, params, type_override, intentional)
	if (ishuman(user) && intentional)
		var/mob/living/carbon/human/human_user = user
		var/datum/action/cooldown/spell/moth_and_dash/dash_action = locate() in user.actions
		if(dash_action)
			dash_action.Trigger
			dash_action.blocked = FALSE

	return ..()

/datum/action/cooldown/spell/touch/moth_climb
	name = "Lift Wings"
	desc = "Spreads your wings out to facilitate climbing."
	button_icon = 'icons/mob/human/species/moth/moth_wings.dmi'
	button_icon_state = "m_moth_wings_monarch_BEHIND"
	check_flags = AB_CHECK_CONSCIOUS
	invocation_type = INVOCATION_NONE
	spell_requirements = NONE
	antimagic_flags = NONE

	hand_path = /obj/item/climbing_moth_wings
	draw_message = span_notice("You outstretch your wings, ready to climb upwards.")
	drop_message = span_notice("Your wings tuck back behind you.")

/obj/item/climbing_moth_wings
	name = "outstretched wings"
	desc = "Useful for climbing up onto high places, though tiresome."
	icon = 'icons/mob/human/species/moth/moth_wings.dmi'
	icon_state = "m_moth_wings_monarch_BEHIND"
	var/climb_time = 2.5 SECONDS

/obj/item/climbing_moth_wings/examine(mob/user)
	. = ..()
	var/list/look_binds = user.client.prefs.key_bindings["look up"]
	. += span_notice("Firstly, look upwards by holding <b>[english_list(look_binds, nothing_text = "(nothing bound)", and_text = " or ", comma_text = ", or ")]!</b>")
	. += span_notice("Then, click solid ground adjacent to the hole above you.")

/obj/item/climbing_moth_wings/afterattack(turf/open/target, mob/user, proximity_flag, click_parameters)
	. = ..()
	if(target.z == user.z)
		return
	if(!istype(target) || isopenspaceturf(target))
		return

	var/turf/user_turf = get_turf(user)
	var/turf/above = GET_TURF_ABOVE(user_turf)
	if(target_blocked(target, above))
		return
	if(!isopenspaceturf(above) || !above.Adjacent(target)) //are we below a hole, is the target blocked, is the target adjacent to our hole
		user.balloon_alert(user, "blocked!")
		return

	var/away_dir = get_dir(above, target)
	user.visible_message(span_notice("[user] begins pushing themselves upwards with their wings!"), span_notice("Your wings start fluttering violently as you begin going upwards."))
	playsound(target, 'sound/voice/moth/moth_flutter.ogg', 50) //plays twice so people above and below can hear
	playsound(user_turf, 'sound/voice/moth/moth_flutter.ogg', 50)
	var/list/effects = list(new /obj/effect/temp_visual/climbing_hook(target, away_dir), new /obj/effect/temp_visual/climbing_hook(user_turf, away_dir))

	if(do_after(user, climb_time, target))
		user.forceMove(target)

	QDEL_LIST(effects)

/obj/item/climbing_moth_wings/proc/target_blocked(turf/target, turf/above)
	if(target.density || above.density)
		return TRUE

	for(var/atom/movable/atom_content as anything in target.contents)
		if(isliving(atom_content))
			continue
		if(HAS_TRAIT(atom_content, TRAIT_CLIMBABLE))
			continue
		if((atom_content.flags_1 & ON_BORDER_1) && atom_content.dir != get_dir(target, above)) //if the border object is facing the hole then it is blocking us, likely
			continue
		if(atom_content.density)
			return TRUE
	return FALSE

/obj/item/organ/external/wings/flight
	unconditional_flight = TRUE
	can_open = TRUE

/obj/item/organ/external/wings/flight/angel
	name = "angel wings"
	desc = "A pair of magnificent, feathery wings. They look strong enough to lift you up in the air."
	mutantpart_info = list(MUTANT_INDEX_NAME = "Angel", MUTANT_INDEX_COLOR_LIST = list("#FFFFFF"))

/obj/item/organ/external/wings/flight/dragon
	name = "dragon wings"
	desc = "A pair of intimidating, membranous wings. They look strong enough to lift you up in the air."
	mutantpart_info = list(MUTANT_INDEX_NAME = "Dragon", MUTANT_INDEX_COLOR_LIST = list("#880000"))

/obj/item/organ/external/wings/flight/megamoth
	name = "megamoth wings"
	desc = "A pair of horrifyingly large, fuzzy wings. They look strong enough to lift you up in the air."
	mutantpart_info = list(MUTANT_INDEX_NAME = "Megamoth", MUTANT_INDEX_COLOR_LIST = list("#FFFFFF"))


/datum/bodypart_overlay/mutant/wings/functional
	color_source = ORGAN_COLOR_INHERIT


/datum/bodypart_overlay/mutant/wings/functional/original_color
	color_source = ORGAN_COLOR_OVERRIDE


/datum/bodypart_overlay/mutant/wings/functional/original_color/override_color(rgb_value)
	return COLOR_WHITE // We want to keep those wings as their original color, because it looks better.


/datum/bodypart_overlay/mutant/wings/functional/locked/get_global_feature_list()
	if(wings_open)
		return GLOB.sprite_accessories["wings_open"]

	return GLOB.sprite_accessories["wings_functional"]


// We need to overwrite this because all of these wings are locked.
/datum/bodypart_overlay/mutant/wings/functional/locked/get_random_appearance()
	var/list/valid_restyles = list()
	var/list/feature_list = get_global_feature_list()
	for(var/accessory in feature_list)
		var/datum/sprite_accessory/accessory_datum = feature_list[accessory]
		valid_restyles += accessory_datum

	return pick(valid_restyles)


/datum/bodypart_overlay/mutant/wings/functional/locked/original_color
	color_source = ORGAN_COLOR_OVERRIDE


/datum/bodypart_overlay/mutant/wings/functional/locked/original_color/override_color(rgb_value)
	return COLOR_WHITE // We want to keep those wings as their original color, because it looks better.


/obj/item/organ/external/wings/functional
	bodypart_overlay = /datum/bodypart_overlay/mutant/wings/functional/locked

/obj/item/organ/external/wings/functional/angel
	bodypart_overlay = /datum/bodypart_overlay/mutant/wings/functional/original_color

/obj/item/organ/external/wings/functional/dragon
	bodypart_overlay = /datum/bodypart_overlay/mutant/wings/functional

/obj/item/organ/external/wings/functional/moth
	bodypart_overlay = /datum/bodypart_overlay/mutant/wings/functional/locked/original_color

/obj/item/organ/external/wings/functional/robotic
	bodypart_overlay = /datum/bodypart_overlay/mutant/wings/functional

/obj/item/organ/external/wings/functional/slime
	bodypart_overlay = /datum/bodypart_overlay/mutant/wings/functional
