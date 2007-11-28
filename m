Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:39994 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755116AbXK1Tr3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2007 14:47:29 -0500
Subject: Re: mac80211 / iwl3945 + dynamic wep (again)
From: Johannes Berg <johannes@sipsolutions.net>
To: dragoran <drago01@gmail.com>
Cc: Jouni Malinen <j@w1.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Dan Williams <dcbw@redhat.com>,
	ipw3945-devel <ipw3945-devel@lists.sourceforge.net>,
	Zhu Yi <yi.zhu@intel.com>
In-Reply-To: <f6ca9fed0711281145y26fa2dc1w5d57e9dc0e45c16b@mail.gmail.com> (sfid-20071128_194557_851836_BC05120D)
References: <47494851.4070504@gmail.com>
	 <1195987773.4149.214.camel@johannes.berg> <474955E1.30603@gmail.com>
	 <f6ca9fed0711260650j749de7a3x3edc084ae820d2eb@mail.gmail.com>
	 <20071127033408.GB5698@jm.kir.nu> <474D75D9.7070908@gmail.com>
	 <1196268612.6058.157.camel@johannes.berg>
	 <f6ca9fed0711281145y26fa2dc1w5d57e9dc0e45c16b@mail.gmail.com>
	 (sfid-20071128_194557_851836_BC05120D)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-16drSAtqayBj+vzfFtgA"
Date: Wed, 28 Nov 2007 20:47:16 +0100
Message-Id: <1196279236.6058.165.camel@johannes.berg> (sfid-20071128_194732_603313_A5D5AFC6)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-16drSAtqayBj+vzfFtgA
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable



> > Just grap iw (from git.sipsolutions.net) and create a new monitor
> > interface: ./iw dev wmaster0 interface add moni0 type monitor
> > and then run tcpdump/wireshark on that.
>=20
> iw does not build here :
> cc -I/lib/modules/`uname -r`/build//include -Wall
> -I/lib/modules/`uname -r`/build/include -g   -c -o iw.o iw.c
> iw.c:11:31: error: netlink/genl/genl.h: No such file or directory
> iw.c:12:33: error: netlink/genl/family.h: No such file or directory
> iw.c:13:33: error: netlink/genl/ctrl.h: No such file or directory

Yeah, you need libnl-pre8.

johannes

--=-16drSAtqayBj+vzfFtgA
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR03Fw6Vg1VMiehFYAQJF5g//R21uuB2N7QRvLn3lFzjb1/935b/WnMlU
HfHOL4dwPaXeVY1Y0U8cBG387S+TTlOFk/wMEGk83LHCWLR23qWmPUJ3wmiWfZZ/
VY9Mo9pHuMIh4xkU9QHFTcFcAaXAecyLK1B2lCiMUwVRUfWGBLyulmvaqX6Nqxhm
zvXVUa/5NneoUXc8Xp14MD/3d44P4+V9bsj1+CFrglFvCel42p2gzCOMjpcNfVLp
ksQyBnqWeKRSt/i2k777Qz978YBcPklCWA3sSEmUi4Lg7mhnPIvBRLNCkELu3DOl
JBcNjZOWJmowCPaA8OGquWoGhhxQo8buMWVD0aiZl/SBVJgill52sxoXU9aqPz2k
SFySAGLJJYnaHrksvVuCRtSoEEUw2ZS8t/IRHfQpY8iGV4WsP3bFIFf6nVinMG/+
1VfIbKP1tIwCGdUXOT+sfkuegFQJoeq47ADdY7B6PnxiIltptRHV2K33Td5QrVaz
/othk4UcVlXN6Q2mhbAOwATXdCXluwMaYk3xBTxOrbCePiRF8LpOrBLlN//TJ7j2
Cfn3oVXw8uE1iPqGPIUw+bs1BDzrlfGxs2voefeaZUjvwXorFwWDv7R/1DgsyBq7
mWhwNu9nU3ILp5/0Wb1ZfLPRqM5ouE3obsFjb3/3u5Ri9N5r2qa11l51I7IBUY16
5RKguzA97m4=
=1Hv1
-----END PGP SIGNATURE-----

--=-16drSAtqayBj+vzfFtgA--

