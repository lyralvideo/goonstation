/datum/plantmutation/
	var/name = null // If this is set, plants will use this instead of regular plant name
	var/crop = null // What crop does it give?
	var/special_dmi = null // same as in base plant thing really
	var/iconmod = null // name of the sprite files in hydro_mutants.dmi
	var/harvest_override = 0 // If 1, you can harvest it irregardless of the plant's base harvestability
	var/harvested_proc_override = 0
	var/special_proc_override = 0
	// If 0, just use the base plant's settings
	// If 1, use the mutation's special_proc instead
	// If anything else, use both the base and the mutant procs
	var/attacked_proc_override = 0
	var/name_prefix = ""	// Prepend to plant name
	var/name_suffix = ""	// Append to plant name
	var/dont_rename_crop = false	// If the crop should not be renamed based on the

	// Ranges various genes have to be in to get the mutation to appear - lower and upper bound
	var/list/GTrange = list(null,null) // null means there is no limit so an upper bound of 25
	var/list/HTrange = list(null,null) // and no lower bound means the mutation will occur when
	var/list/HVrange = list(null,null) // the plant is below 25 in that gene, but can be as low
	var/list/CZrange = list(null,null) // as it wants otherwise with no consideration
	var/list/PTrange = list(null,null)
	var/list/ENrange = list(null,null)
	var/commut = null // is a paticular common mutation required for this? (keeping it to 1 for now)
	var/chance = 8 // How likely out of 100% is this mutation to appear when conditions are met?
	var/list/assoc_reagents = list() // Used for extractions, harvesting, etc

	var/lasterr = 0

	proc/HYPharvested_proc_M(var/obj/machinery/plantpot/POT, var/mob/user)
		lasterr = 0
		if (!POT || !user) return 301
		if (POT.dead || !POT.current) return 302
		if (lasterr)
			logTheThing("debug", null, null, "<b>Plant HYP</b> [src] in pot [POT] failed with error [.]")
			harvested_proc_override = 0
		return lasterr

	proc/HYPspecial_proc_M(var/obj/machinery/plantpot/POT)
		lasterr = 0
		if (!POT) lasterr = 401
		if (POT.dead || !POT.current) lasterr = 402
		if (lasterr)
			logTheThing("debug", null, null, "<b>Plant HYP</b> [src] in pot [POT] failed with error [.]")
			special_proc_override = 0
		return lasterr

	proc/HYPattacked_proc_M(var/obj/machinery/plantpot/POT,var/mob/user)
		lasterr = 0
		if (!POT) lasterr = 501
		if (POT.dead || !POT.current) lasterr = 502
		if (lasterr)
			logTheThing("debug", null, null, "<b>Plant HYP</b> [src] in pot [POT] failed with error [.]")
			attacked_proc_override = 0
		return lasterr

// Tomato Mutations

/datum/plantmutation/tomato/explosive
	name = "Seething Tomato"
	name_prefix = "Seething "
	crop = /obj/item/reagent_containers/food/snacks/plant/tomato/explosive
	iconmod = "exptom"

	HYPharvested_proc_M(var/obj/machinery/plantpot/POT, var/mob/user)
		. = ..()
		if (.)
			return .
		if (prob(5) || (user.client && user.client.hellbanned && prob(50)))
			boutput(user, "<span class='alert'>A tomato explodes as you pick it off the plant!</span>")
			explosion_new(POT, get_turf(user), 10, 1)
			return 399
		return 0

/datum/plantmutation/tomato/killer
	name = "Suspicious Tomato"
	name_prefix = "Suspicious "
	crop = /obj/critter/killertomato
	iconmod = "kiltom"

/datum/plantmutation/tomato/tomacco
	name = "Tomacco"
	name_suffix = " Tomacco"
	crop = /obj/item/reagent_containers/food/snacks/plant/tomato/tomacco
	iconmod = "kiltom"

// Corn Mutations

/datum/plantmutation/corn/clear
	crop = /obj/item/reagent_containers/food/snacks/plant/corn/clear
	iconmod = "Clearcorn"
	assoc_reagents = list("ethanol")

// Grape Mutations

/datum/plantmutation/grapes/green
	name_prefix = "green "
	crop = /obj/item/reagent_containers/food/snacks/plant/grape/green
	iconmod = "Ggrape"

/datum/plantmutation/grapes/fruit
	name = "Grapefruit"
	crop = /obj/item/reagent_containers/food/snacks/plant/grapefruit
	iconmod = "Grapefruit"
	assoc_reagents = list("juice_grapefruit")

// Orange Mutations

/datum/plantmutation/orange/blood
	name = "Blood Orange"
	name_prefix = "Blood "
	assoc_reagents = list("bloodc") // heh

/datum/plantmutation/orange/clockwork
	name = "Clockwork Orange"
	name_prefix = "Clockwork "
	crop = /obj/item/reagent_containers/food/snacks/plant/orange/clockwork
	assoc_reagents = list("iron")
	ENrange = list(30,null)
	chance = 20

// Apple Mutations

/datum/plantmutation/apple/poison
	name = "Delicious Apple"
	name_prefix = "Delicious "
	crop = /obj/item/reagent_containers/food/snacks/plant/apple/poison
	iconmod = "poison"
	assoc_reagents = list("capulettium")
	ENrange = list(40,null)
	chance = 10

// Melon Mutations

/datum/plantmutation/melon/george
	name = "Rainbow Melons"
	name_prefix = "Rainbow "
	crop = /obj/item/reagent_containers/food/snacks/plant/melon/george
	assoc_reagents = list("george_melonium")

/datum/plantmutation/melon/balloon
	name = "Balloon Melons"
	name_prefix = "Balloon "
	crop = /obj/item/reagent_containers/balloon
	iconmod = "balloon"
	assoc_reagents = list("helium")

/datum/plantmutation/melon/hindenballoon
	name = "Balloon... Melons?"
	name_prefix = "Balloon "
	crop = /obj/item/reagent_containers/balloon
	iconmod = "balloon"
	assoc_reagents = list("hydrogen")

/datum/plantmutation/melon/bowling
	name = "Bowling Melons"
	name_prefix = "Bowling "
	crop = /obj/item/reagent_containers/food/snacks/plant/melon/bowling
	ENrange = list(12,null)
	chance = 20
	special_proc_override = 1

	HYPspecial_proc_M(var/obj/machinery/plantpot/POT)
		..()
		if (.) return
		var/datum/plantgenes/DNA = POT.plantgenes

		var/thud_prob = max(0,min(100, DNA.endurance / 2))

		if (prob(thud_prob))
			playsound(POT.loc, "sound/effects/exlow.ogg", 30, 1)
			var/wiggle = 4
			while(wiggle > 0)
				wiggle--
				POT.pixel_x = rand(-2,2)
				POT.pixel_y = rand(-2,2)
				sleep(0.1 SECONDS)
			POT.pixel_x = 0
			POT.pixel_y = 0

// Chili Mutations

/datum/plantmutation/chili/chilly
	name = "chilly"
	name_prefix = "chilly "
	iconmod = "chilly"
	crop = /obj/item/reagent_containers/food/snacks/plant/chili/chilly
	assoc_reagents = list("cryostylane")

/datum/plantmutation/chili/ghost
	name = "fiery chili"
	name_prefix = "fiery "
	iconmod = "ghost"
	crop = /obj/item/reagent_containers/food/snacks/plant/chili/ghost_chili
	PTrange = list(75,null)
	chance = 10
	assoc_reagents = list("ghostchilijuice")

// Eggplant Mutations

/datum/plantmutation/eggplant/literal
	name = "free range eggplant"
	name_prefix = "free range "
	iconmod = "eggs"
	crop = /obj/item/reagent_containers/food/snacks/ingredient/egg

// Wheat Mutations

/datum/plantmutation/wheat/durum
	name = "durum wheat"
	name_prefix = "durum "
	crop = /obj/item/plant/wheat/durum

/datum/plantmutation/wheat/steelwheat
	name = "steel wheat"
	name_prefix = "steel "
	iconmod = "steelwheat"
	assoc_reagents = list("iron")
	crop = /obj/item/plant/wheat/metal

// Synthmeat Mutations

/datum/plantmutation/synthmeat/butt
	name = "Synthbutt"
	iconmod = "butts"
	dont_rename_crop = true
	crop = /obj/item/clothing/head/butt/synth
	special_proc_override = 1

	HYPspecial_proc_M(var/obj/machinery/plantpot/POT)
		..()
		if (.) return
		var/datum/plant/P = POT.current
		var/datum/plantgenes/DNA = POT.plantgenes

		var/fart_prob = max(0,min(100,DNA.potency))

		if (POT.growth > (P.growtime - DNA.growtime) && prob(fart_prob))
			POT.visible_message("<span class='alert'><b>[POT]</b> farts!</span>")
			playsound(POT.loc, "sound/voice/farts/poo2.ogg", 50, 1)
			// coder.Life()
			// whoops undefined proc

/datum/plantmutation/synthmeat/limb
	name = "Synthlimb"
	dont_rename_crop = true
	iconmod = "limbs" // haine has farted up a shitty recolored sprite for these, everyone rejoice
	crop = list(/obj/item/parts/human_parts/arm/left/synth, /obj/item/parts/human_parts/arm/right/synth,
	            /obj/item/parts/human_parts/leg/left/synth, /obj/item/parts/human_parts/leg/right/synth,
	            /obj/item/parts/human_parts/arm/left/synth/bloom, /obj/item/parts/human_parts/arm/right/synth/bloom,
	            /obj/item/parts/human_parts/leg/left/synth/bloom, /obj/item/parts/human_parts/leg/right/synth/bloom)

/datum/plantmutation/synthmeat/organ
	name = "Synthorgan"
	dont_rename_crop = true
	iconmod = "limbs"
	crop = list(/obj/item/organ/heart/synth, /obj/item/organ/brain/synth, /obj/item/organ/eye/synth) // Just slap your new organ in there.

/datum/plantmutation/synthmeat/butt/buttbot
	name = "Synthbuttbot"
	dont_rename_crop = true
	iconmod = "butts"
	crop = /obj/machinery/bot/buttbot

// Soy Mutations

/datum/plantmutation/soy/soylent
	name = "Strange soybean"
	name_prefix = "Strange "
	crop = /obj/item/reagent_containers/food/snacks/plant/soylent
	iconmod = "soylent"

// Contusine Mutations

/datum/plantmutation/contusine/shivering
	name = "Shivering Contusine"
	name_prefix = "Shivering "
	iconmod = "shivercon"
	assoc_reagents = list("salbutamol")
	chance = 20

/datum/plantmutation/contusine/quivering
	name = "Quivering Contusine"
	name_prefix = "Quivering "
	iconmod = "shivercon"
	assoc_reagents = list("curare")
	chance = 10

// Nureous Mutations

/datum/plantmutation/nureous/fuzzy
	name = "Fuzzy Nureous"
	name_prefix = "Fuzzy "
	assoc_reagents = list("hairgrownium")

// Asomna Mutations

/datum/plantmutation/asomna/robust
	name = "Robust Asomna"
	name_prefix = "Robust "
	iconmod = "AsomnaR"
	assoc_reagents = list("methamphetamine")
	chance = 10

// Commol Mutations

/datum/plantmutation/commol/burning
	name = "Burning Commol"
	name_prefix = "Burning "
	iconmod = "CommolB"
	assoc_reagents = list("phlogiston")
	chance = 10

// Venne Mutations

/datum/plantmutation/venne/toxic
	name = "Black Venne"
	name_prefix = "Black "
	iconmod = "venneT"
	crop = /obj/item/plant/herb/venne/toxic
	assoc_reagents = list("atropine")
	chance = 10

/datum/plantmutation/venne/curative
	name = "Sunrise Venne"
	name_prefix = "Sunrise "
	iconmod = "venneC"
	crop = /obj/item/plant/herb/venne/curative
	assoc_reagents = list("oculine","mannitol","mutadone")
	chance = 5

// Houttuynia Cordata Mutations

/datum/plantmutation/hcordata/fish
	name = "Wholetuna Cordata"
	iconmod = "Wcordata"
	crop = /obj/item/fish/random
	special_proc_override = 1

	HYPspecial_proc_M(var/obj/machinery/plantpot/POT)
		..()
		if (.) return
		var/datum/plant/P = POT.current
		var/datum/plantgenes/DNA = POT.plantgenes

		if (POT.growth > (P.harvtime + DNA.harvtime) && prob(10))
			var/list/nerds = list()
			// I know that this seems weird, but consider how many plants clutter botany at any given time. Looping through mobs and checking distance is
			// less of a pain than looping through potentially hundreds of random seeds and crap in view(1) to see if they're mobs.
			for (var/mob/living/L in mobs)
				if (get_dist(L.loc,POT.loc) <= 1)
					nerds += L
				else
					continue
			if (nerds.len >= 1)
				POT.visible_message("<span class='alert'><b>[POT.name]</b> slaps [pick(nerds)] with a fish!</span>")
				playsound(get_turf(POT), pick('sound/impact_sounds/Slimy_Hit_1.ogg', 'sound/impact_sounds/Slimy_Hit_2.ogg'), 50, 1, -1)

// Cannabis Mutations

/datum/plantmutation/cannabis/rainbow
	name = "Rainbow Weed"
	name_prefix = "Rainbow "
	iconmod = "megaweed"
	crop = /obj/item/plant/herb/cannabis/mega
	assoc_reagents = list("LSD")

/datum/plantmutation/cannabis/death
	name = "Deathweed"
	name_prefix = "Black "
	iconmod = "deathweed"
	crop = /obj/item/plant/herb/cannabis/black
	PTrange = list(null,30)
	ENrange = list(10,30)
	chance = 20
	assoc_reagents = list("cyanide")

/datum/plantmutation/cannabis/white
	name = "Lifeweed"
	name_prefix = "White "
	iconmod = "lifeweed"
	crop = /obj/item/plant/herb/cannabis/white
	PTrange = list(30,null)
	ENrange = list(30,50)
	chance = 20
	assoc_reagents = list("omnizine")

/datum/plantmutation/cannabis/ultimate
	name = "Omega Weed"
	name_prefix = "Glowing "
	iconmod = "Oweed"
	crop = /obj/item/plant/herb/cannabis/omega
	PTrange = list(420,null)
	chance = 100
	assoc_reagents = list("LSD","suicider","space_drugs","mercury","lithium",
	"atropine", "ephedrine", "haloperidol","methamphetamine","THC","capsaicin","psilocybin","hairgrownium",
	"ectoplasm","bathsalts","itching","crank","krokodil","catdrugs","histamine")

// Fungus Mutations

/datum/plantmutation/fungus/psilocybin
	name = "Magic Mushroom"
	name_prefix = "Magic "
	iconmod = "magmush"
	crop = /obj/item/reagent_containers/food/snacks/mushroom/psilocybin
	assoc_reagents = list("psilocybin")

/datum/plantmutation/fungus/amanita
	name = "White Fungus"
	name_prefix = "White "
	iconmod = "deathcap"
	crop = /obj/item/reagent_containers/food/snacks/mushroom/amanita
	ENrange = list(null,10)
	PTrange = list(30,null)
	chance = 20
	assoc_reagents = list("amanitin")

/datum/plantmutation/fungus/cloak
	name = "Cloaked Panellus"
	iconmod = "Cloak"
	crop = /obj/item/reagent_containers/food/snacks/mushroom/cloak
	PTrange = list(null,10) //low potency
	CZrange = list(25,null) // high crop size
	chance = 10
	assoc_reagents = list("cloak_juice")


// Lasher Mutations

/datum/plantmutation/lasher/berries
	name = "Blooming Lasher"
	name_prefix = "Blooming "
	dont_rename_crop = true
	iconmod = "lashberry"
	harvest_override = 1
	crop = /obj/item/reagent_containers/food/snacks/plant/lashberry/
	chance = 20

// Radweed Mutations

/datum/plantmutation/radweed/safeweed
	name = "White Radweed"
	name_prefix = "White "
	iconmod = "whiterad"
	special_proc_override = 1

	HYPspecial_proc_M(var/obj/machinery/plantpot/POT)
		..()
		if (.) return
		var/datum/plant/P = POT.current
		var/datum/plantgenes/DNA = POT.plantgenes

		if (POT.growth > (P.harvtime - DNA.harvtime) && prob(10))
			var/obj/overlay/B = new /obj/overlay( POT.loc )
			B.icon = 'icons/obj/hydroponics/hydromisc.dmi'
			B.icon_state = "radpulse"
			B.name = "radioactive pulse"
			B.anchored = 1
			B.set_density(0)
			B.layer = 5 // TODO what layer should this be on?
			SPAWN_DBG(2 SECONDS)
				qdel(B)
				B=null
			var/radrange = 1
			switch (POT.health)
				if (60 to 159)
					radrange = 2
				if (160 to INFINITY)
					radrange = 3
			for (var/obj/machinery/plantpot/C in range(radrange,POT))
				var/datum/plant/growing = C.current
				if (istype(growing,/datum/plant/radweed)) continue
				if (growing) C.HYPmutateplant(radrange * 2)

/datum/plantmutation/radweed/redweed
	name = "Smoldering Radweed"
	name_prefix = "Smoldering "
	iconmod = "redweed"
	assoc_reagents = list("phlogiston")

// Slurrypod Mutations

/datum/plantmutation/slurrypod/omega
	name = "Glowing Slurrypod"
	name_prefix = "Glowing "
	iconmod = "omegaS"
	crop = /obj/item/reagent_containers/food/snacks/plant/slurryfruit/omega
	assoc_reagents = list("omega_mutagen")

// Rock Plant Mutations

/datum/plantmutation/rocks/syreline
	name_prefix = "Syreline "
	dont_rename_crop = true
	crop = /obj/item/raw_material/syreline
	chance = 40

/datum/plantmutation/rocks/bohrum
	name_prefix = "Bohrum "
	dont_rename_crop = true
	crop = /obj/item/raw_material/bohrum
	chance = 20

/datum/plantmutation/rocks/mauxite
	name_prefix = "Mauxite "
	dont_rename_crop = true
	crop = /obj/item/raw_material/mauxite
	chance = 10

/datum/plantmutation/rocks/erebite
	name_prefix = "Erebite "
	dont_rename_crop = true
	crop = /obj/item/raw_material/erebite
	chance = 5

// trees. :effort:

/datum/plantmutation/tree/money
	name = "Money Tree"
	name_prefix = "Money "
	iconmod = "Cash"
	crop = /obj/item/spacecash
	chance = 20

/datum/plantmutation/tree/paper
	name = "Paper Tree"
	name_prefix = "Paper "
	iconmod = "Paper"
	crop = /obj/item/paper
	chance = 20

/datum/plantmutation/tree/dog
	name = "Dogwood Tree"
	iconmod = "Dogwood"
	special_proc_override = 1
	attacked_proc_override = 1

	HYPspecial_proc_M(var/obj/machinery/plantpot/POT)
		..()
		if (.) return
		var/datum/plant/P = POT.current
		var/datum/plantgenes/DNA = POT.plantgenes

		if (POT.growth > (P.growtime + DNA.growtime) && prob(5))
			POT.visible_message("<span class='combat'><b>[POT.name]</b> [pick("howls","bays","whines","barks","croons")]!</span>")
			playsound(get_turf(POT), pick("sound/voice/animal/howl1.ogg","sound/voice/animal/howl2.ogg","sound/voice/animal/howl3.ogg","sound/voice/animal/howl4.ogg","sound/voice/animal/howl5.ogg","sound/voice/animal/howl6.ogg"), 30, 1,-1)

	HYPattacked_proc_M(var/obj/machinery/plantpot/POT,var/mob/user)
		..()
		if (.) return
		var/datum/plant/P = POT.current
		var/datum/plantgenes/DNA = POT.plantgenes

		if (POT.growth < (P.growtime + DNA.growtime)) return 0
		playsound(get_turf(POT), pick("sound/voice/animal/howl1.ogg","sound/voice/animal/howl2.ogg","sound/voice/animal/howl3.ogg","sound/voice/animal/howl4.ogg","sound/voice/animal/howl5.ogg","sound/voice/animal/howl6.ogg"), 30, 1,-1)
		boutput(user, "<span class='alert'>[POT.name] angrily bites you!</span>")
		random_brute_damage(user, 3)
		return prob(50) // fights back, but doesn't always succeed

/datum/plantmutation/tree/rubber
	name = "Rubber Tree"
	dont_rename_crop = true
	name_prefix = "Rubber "
	iconmod = "Rubber"
	crop = /obj/item/material_piece/rubber/latex
	chance = 20

/datum/plantmutation/tree/sassafras
	name = "Sassafras Tree"
	dont_rename_crop = true
	name_prefix = "Sassafras "
	iconmod = "Sassafras"
	assoc_reagents = list("safrole")
	crop = /obj/item/plant/herb/sassafras

//peanuuts

/datum/plantmutation/peanut/sandwich
	name = "Peanutbutter Sandwich"
	name_suffix = "butter Sandwich"
	crop = /obj/item/reagent_containers/food/snacks/sandwich/pb
	iconmod = "Peanut"

//Tobacco mutations

/datum/plantmutation/tobacco/twobacco
	name = "Twobacco"
	iconmod = "Twobacco"
	PTrange = list(30,null)
	crop = /obj/item/plant/herb/tobacco/twobacco
	assoc_reagents = list("nicotine2")
	chance = 50
