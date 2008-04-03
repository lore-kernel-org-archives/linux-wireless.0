Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:39626 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753091AbYDCKkI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Apr 2008 06:40:08 -0400
Subject: Re: [PATCH] b43: Add PIO support for PCMCIA devices
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: John Linville <linville@tuxdriver.com>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
In-Reply-To: <200803292101.16696.mb@bu3sch.de> (sfid-20080329_200236_826304_8681CDF1)
References: <200803292101.16696.mb@bu3sch.de>
	 (sfid-20080329_200236_826304_8681CDF1)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-4Db8T698AYD4bOyDHIVj"
Date: Thu, 03 Apr 2008 12:36:48 +0200
Message-Id: <1207219008.3636.27.camel@johannes.berg> (sfid-20080403_114022_175465_BFC70ADB)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-4Db8T698AYD4bOyDHIVj
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> PIO is needed for 16bit PCMCIA devices, as we really don't want to poke w=
ith
> the braindead DMA mechanisms on PCMCIA sockets. Additionally, not all
> PCMCIA sockets do actually support DMA in 16bit mode (mine doesn't).

Oddly, my CF card still doesn't work. Is there anything else I need in a
current wireless-testing tree?

johannes

--=-4Db8T698AYD4bOyDHIVj
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR/SzP6Vg1VMiehFYAQL3QQ/+I/g/bD2SuZ5CHUeeJqnCif2dj/Tq54xc
Ka8qS/WLUMhMH6bfOJDh6wO+JohWIB86qXrXDk17z5l+S61uD9blz68fYbypsSvB
7ztXk5OGusqXWPfFV+G1M6oNJiOSR0uuOmL6QbOgpRrWLMKK9lJvHDDsFIajAmuR
lJ+jaWj/zUYcpk2jIpUx6KNYG2ZhOVa06C8LNGjPH/EVAmxY0KJq+cjy+1crWIo2
BkeZ6M1ed30JsdV+gUI7zOCiTaZ1gpl3kzPe1r+7JAaSSSe0xgyuwUXLTm8wX44S
BSe8L23pnU803nSXrUHNZFPjNVY7vMyMBQIvMAyshnnyLSqbuVHe/MAfXAayDi1w
u4WcSKDvbr6ZbsjNdX8zMKqKCRhkVwRT5f1aZ11tLlXrlQTBxxG0lP4pxfw3RP8S
hY5UlybAuL3ZayA6BCpem372ONgSwMzcYT/ZFwmD8S+61NCNdgiQeL/2pl5tOVvA
jJFiij9E+0F2JHoj3nJpy3zqSY2xMuQOYGKnic4S7A0IU6wEdHv4ntOmO4Shdb4Y
coOg3hL1+gkaRE4OG0vuDe90GvZxGM2z+/F/OSx2rAGuIw+9JJEwbXNltuG3bZ6A
dcbOT0Uy70s9yXK6m248e3jBjFmlTHaeqAH1Mh6maZj4+GsRt8cWQhuPQmC0zmhN
1rMyYbSJago=
=NsxM
-----END PGP SIGNATURE-----

--=-4Db8T698AYD4bOyDHIVj--

