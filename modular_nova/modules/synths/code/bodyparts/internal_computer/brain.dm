/obj/item/organ/internal/brain/synth
	var/obj/item/modular_computer/pda/synth/internal_computer
	actions_types = list(/datum/action/item_action/synth/open_internal_computer)

/obj/item/organ/internal/brain/synth/Initialize(mapload)
	. = ..()
	internal_computer = new(src)

/obj/item/organ/internal/brain/synth/Destroy()
	QDEL_NULL(internal_computer)
	return ..()

/obj/item/organ/internal/brain/synth/on_mob_insert(mob/living/carbon/human/brain_owner, special, movement_flags)
	. = ..()
	if(!istype(brain_owner))
		return
	RegisterSignal(brain_owner, COMSIG_MOB_EQUIPPED_ITEM, PROC_REF(on_equip_signal))
	if(internal_computer && brain_owner.wear_id)
		internal_computer.handle_id_slot(brain_owner, brain_owner.wear_id)

/obj/item/organ/internal/brain/synth/on_mob_remove(mob/living/carbon/human/brain_owner, special)
	. = ..()
	if(!istype(brain_owner))
		return
	UnregisterSignal(brain_owner, COMSIG_MOB_EQUIPPED_ITEM)
	if(brain_owner.wear_id)
		UnregisterSignal(brain_owner.wear_id, list(COMSIG_MOVABLE_MOVED, COMSIG_ITEM_UNSTORED))
	if(internal_computer)
		internal_computer.handle_id_slot(brain_owner)

/obj/item/organ/internal/brain/synth/proc/on_equip_signal(datum/source, obj/item/item, slot)
	SIGNAL_HANDLER
	if(isnull(internal_computer))
		return
	if(slot == ITEM_SLOT_ID)
		internal_computer.handle_id_slot(owner, item)
