Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:55795 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752602AbXJ0M5m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Oct 2007 08:57:42 -0400
Subject: Re: [PATCH] mac80211: reorder association debug output
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: stable@kernel.org, linux-wireless@vger.kernel.org
In-Reply-To: <20071027125025.GC16222@tuxdriver.com>
References: <11934326793639-git-send-email-linville@tuxdriver.com>
	 <11934326801557-git-send-email-linville@tuxdriver.com>
	 <11934326803769-git-send-email-linville@tuxdriver.com>
	 <11934326803330-git-send-email-linville@tuxdriver.com>
	 <11934326811535-git-send-email-linville@tuxdriver.com>
	 <11934326813508-git-send-email-linville@tuxdriver.com>
	 <1193432681145-git-send-email-linville@tuxdriver.com>
	 <1193433039.15686.12.camel@johannes.berg>
	 <20071026212303.GF23415@tuxdriver.com>
	 <1193435078.15686.14.camel@johannes.berg>
	 <20071027125025.GC16222@tuxdriver.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-X7ZNnGNmxS7STcMIFP6O"
Date: Sat, 27 Oct 2007 14:58:55 +0200
Message-Id: <1193489935.15686.17.camel@johannes.berg> (sfid-20071027_135745_242097_77C55DC9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-X7ZNnGNmxS7STcMIFP6O
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable



> > No drivers in 2.6.23 anyway and Intel ships their own mac80211. Why
> > should we care at all?
>=20
> rtl8187 is in 2.6.23.

Oops, I stand corrected. Still I don't think that the message patch is
worth doing in stable, although the regression potential is pretty much
nil.

johannes

--=-X7ZNnGNmxS7STcMIFP6O
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARyM2DaVg1VMiehFYAQJHrg//fRByVsmaUdCximZN5yHe6jQXe5R0BGm6
v89qOx3UOHi+Cf7+YqixYZn4+V3UF4OmHzksBUGXdQ76fNBN6SDfNwkNkAq42upG
VuE52BClmgbY+38DRfEl5hE6Nqy6yG1qfTQeRyaDtYpJ/QjPbxJ6xSmkzBidhL5F
ajn7F96C5XHp6Ygi9juRRBCpawIKn2CH88odNAUwbDJWVhm/Me5LlEccuytRBs6P
6nNpCd7nhQFiRUFO3rYzHtaPTncMX8vWpxTyo6xWCYxZ5CPB8leaJ9NfmW80WLEV
Z3QWUvsb0mAJRIpX8ePdrBZZaLQu+gN2pD0ZUxeCMmgmAwriFj2ECVkLufG6lBhJ
Izzacno+ofwgZ5Qk/uUFMTZi6+a1hT/e8Wmb67XPqlhji6/Cnoi9SzRCoOXSY3oI
vcD/JDcAY7mYImBVgN1qP6XtEopS+8UMek8hJ/JU2srTqSEjoxn5EI9PH5rWTnz5
Vg+iVbbE38/314dSePXMq9+3sE/lAfHY9I043McojdCn940gz5/zZC6Q3dlE2JX/
p7ngDW2lHI51RImIaxEXAv2W3vb7VjIEyl/HLcxwnByV28+0+ssle+q6dTXcGMGi
yAC2RNuWY/hOs+akfCixL89zOT/VWZ4pSdI7e/uMaABxoqz+5Ar29b0+B+NgE67+
NfduHgDlVBs=
=8zfV
-----END PGP SIGNATURE-----

--=-X7ZNnGNmxS7STcMIFP6O--

