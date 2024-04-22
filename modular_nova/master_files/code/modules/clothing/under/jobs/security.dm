/obj/item/clothing/under/rank/security
	worn_icon_digi = 'modular_nova/master_files/icons/mob/clothing/under/security_digi.dmi'

/obj/item/clothing/under/rank/security/nova
	icon = 'modular_nova/master_files/icons/obj/clothing/under/security.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/under/security.dmi'

/obj/item/clothing/under/rank/security/head_of_security/nova
	icon = 'modular_nova/master_files/icons/obj/clothing/under/security.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/under/security.dmi'

//DEBATE MOVING *ALL* SECURITY STUFF HERE? Even overrides, at least as a like, sub-file?

/*
*	SECURITY OFFICER
*/

/obj/item/clothing/under/rank/security/nova/utility
	name = "security utility uniform"
	desc = "A utility uniform worn by Lopland-certified Security officers."
	icon_state = "util_sec"
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION | CLOTHING_MONKEY_VARIATION
	can_adjust = FALSE

/obj/item/clothing/under/rank/security/nova/utility/redsec
	desc = "A utility uniform worn by trained Security officers."
	icon_state = "util_sec_old"
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION
	can_adjust = FALSE

/obj/item/clothing/under/rank/security/nova/utility/redsec/syndicate
	armor_type = /datum/armor/clothing_under/redsec_syndicate
	has_sensor = NO_SENSORS

/obj/item/clothing/under/rank/security/peacekeeper/trousers
	name = "security trousers"
	desc = "Some Peacekeeper-blue combat trousers. Probably should pair it with a vest for safety."
	icon = 'modular_nova/master_files/icons/obj/clothing/under/security.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/under/security.dmi'
	icon_state = "workpants_blue"
	body_parts_covered = GROIN|LEGS
	can_adjust = FALSE
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION
	female_sprite_flags = FEMALE_UNIFORM_NO_BREASTS
	uses_advanced_reskins = TRUE
	unique_reskin = list(
		"Blue Variant" = list(
			RESKIN_ICON_STATE = "workpants_blue",
			RESKIN_WORN_ICON_STATE = "workpants_blue"
		),
		"White Variant" = list(
			RESKIN_ICON_STATE = "workpants_white",
			RESKIN_WORN_ICON_STATE = "workpants_white"
		),
	)

/obj/item/clothing/under/rank/security/peacekeeper/trousers/shorts
	name = "security shorts"
	desc = "Some Peacekeeper-blue combat shorts. Definitely should pair it with a vest for safety."
	icon_state = "workshorts_blue"
	uses_advanced_reskins = TRUE
	unique_reskin = list(
		"Blue Variant, Short" = list(
			RESKIN_ICON_STATE = "workshorts_blue",
			RESKIN_WORN_ICON_STATE = "workshorts_blue"
		),
		"Blue Variant, Short Short" = list(
			RESKIN_ICON_STATE = "workshorts_blue_short",
			RESKIN_WORN_ICON_STATE = "workshorts_blue_short"
		),
		"White Variant, Short" = list(
			RESKIN_ICON_STATE = "workshorts_white",
			RESKIN_WORN_ICON_STATE = "workshorts_white"
		),
		"White Variant, Short Short" = list(
			RESKIN_ICON_STATE = "workshorts_white_short",
			RESKIN_WORN_ICON_STATE = "workshorts_white_short"
		),
	)

/obj/item/clothing/under/rank/security/peacekeeper/trousers/skirt
	name = "peacekeeper skirt"
	desc = "A Peacekeeper-blue skirt, normally used by those aiming to look more 'low-key' than the typical look. Defintiely should pair it with a vest for safety."
	icon_state = "workskirt_blue"
	uses_advanced_reskins = TRUE
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY|FEMALE_UNIFORM_NO_BREASTS
	unique_reskin = list(
		"Blue Variant, Short" = list(
			RESKIN_ICON_STATE = "workskirt_blue",
			RESKIN_WORN_ICON_STATE = "workskirt_blue"
		),
		"Blue Variant, Short Short" = list(
			RESKIN_ICON_STATE = "workskirt_blue_short",
			RESKIN_WORN_ICON_STATE = "workskirt_blue_short"
		),
	)


/obj/item/clothing/under/rank/security/peacekeeper/skirtleneck
	name = "peacekeeper skirtleneck"
	desc = "Tired of having cold arms? Satisfied with having cold legs instead? This Peacekeeper-blue skirt has been augmented with the latest in turtleneck sweater technology; this also serves to make it more armored than standalone skirts."
	icon_state = "security_skirtleneck_blue"
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY|FEMALE_UNIFORM_NO_BREASTS

/*
*	HEAD OF SECURITY
*/

/datum/armor/clothing_under/redsec_syndicate
	melee = 10
	fire = 50
	acid = 40

/obj/item/clothing/under/rank/security/head_of_security/nova/imperial //Rank pins of the Grand General
	desc = "A tar black naval suit and a rank badge denoting the Officer of The Internal Security Division. Be careful your underlings don't bump their head on a door."
	name = "head of security's naval jumpsuit"
	icon_state = "imphos"

/*
*	PRISONER
*/

/obj/item/clothing/under/rank/prisoner
	greyscale_config_worn_monkey = /datum/greyscale_config/jumpsuit/prison/worn/monkey
