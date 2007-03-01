Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:59126 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161252AbXCAXc5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Mar 2007 18:32:57 -0500
Subject: Re: even more breakage in wireless-dev.git
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Jiri Benc <jbenc@suse.cz>
In-Reply-To: <1171713822.3655.3.camel@johannes.berg>
References: <1171707838.3487.11.camel@johannes.berg>
	 <1171713822.3655.3.camel@johannes.berg>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-415RTj0jCeYnE/2gjNB9"
Date: Fri, 02 Mar 2007 00:32:30 +0100
Message-Id: <1172791950.5140.0.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-415RTj0jCeYnE/2gjNB9
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

And I still get this...


[ 3328.408677] freeing scheduled tasklet dd126294 in object dd126000!<3> de=
scheduled instead.
[ 3328.408685] Call Trace:
[ 3328.408690] [DB015CB0] [C0008D6C] show_stack+0x3c/0x194 (unreliable)
[ 3328.408711] [DB015CE0] [C002FA8C] __tasklet_free_check+0x98/0xbc
[ 3328.408725] [DB015D10] [C008037C] kfree+0x78/0x114
[ 3328.408735] [DB015D30] [F20EF244] cfg80211_dev_free+0x2c/0x40 [cfg80211]
[ 3328.408773] [DB015D50] [F20EF754] wiphy_dev_release+0x14/0x24 [cfg80211]
[ 3328.408786] [DB015D60] [C01D0264] device_release+0x28/0x88
[ 3328.408802] [DB015D70] [C0172BD8] kobject_cleanup+0x70/0xac
[ 3328.408819] [DB015D90] [C0173C44] kref_put+0x54/0x6c
[ 3328.408828] [DB015DA0] [C0172B58] kobject_put+0x24/0x34
[ 3328.408838] [DB015DB0] [C01D04E4] put_device+0x1c/0x2c
[ 3328.408848] [DB015DC0] [F20EF208] wiphy_free+0x14/0x24 [cfg80211]
[ 3328.408860] [DB015DD0] [F252CF40] ieee80211_free_hw+0x24/0x38 [mac80211]
[ 3328.408914] [DB015DF0] [F27905E0] bcm43xx_wireless_exit+0x24/0x38 [bcm43=
xx_mac80211]
[ 3328.408953] [DB015E10] [F2217604] ssb_device_remove+0x38/0x58 [ssb]
[ 3328.408976] [DB015E20] [C01D34D8] __device_release_driver+0x88/0xc8
[ 3328.408988] [DB015E30] [C01D3C98] driver_detach+0x110/0x140
[ 3328.408997] [DB015E50] [C01D2F6C] bus_remove_driver+0x8c/0xc8
[ 3328.409007] [DB015E70] [C01D3D20] driver_unregister+0x18/0x34
[ 3328.409016] [DB015E90] [F2217F5C] ssb_driver_unregister+0x14/0x24 [ssb]
[ 3328.409031] [DB015EA0] [F27A8340] bcm43xx_exit+0x18/0x3620 [bcm43xx_mac8=
0211]
[ 3328.409049] [DB015EB0] [C004CD24] delete_module+0x11c/0x1c0
[ 3328.409059] [DB015EE0] [C004CE58] sys_delete_module+0x90/0xc8
[ 3328.409068] [DB015F40] [C0010BD8] ret_from_syscall+0x0/0x38
[ 3328.409082] --- Exception: c01 at 0xff6ae18
[ 3328.409096]     LR =3D 0x10001214


--=-415RTj0jCeYnE/2gjNB9
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBF52KO/ETPhpq3jKURAnlOAJ9kAL09afiYX/lFkX7LLcxSDYOdRgCgsaTJ
CVWlHXarXyXP8zMWJ97wjHo=
=CFzr
-----END PGP SIGNATURE-----

--=-415RTj0jCeYnE/2gjNB9--

