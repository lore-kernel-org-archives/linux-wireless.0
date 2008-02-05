Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:48025 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754202AbYBEIYG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Feb 2008 03:24:06 -0500
Subject: Re: [patch 1/1] b43: fix build with CONFIG_SSB_PCIHOST=n
From: Johannes Berg <johannes@sipsolutions.net>
To: akpm@linux-foundation.org
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	mb@bu3sch.de
In-Reply-To: <200802050758.m157wNAU010975@imap1.linux-foundation.org> (sfid-20080205_075935_916442_C418B3B8)
References: <200802050758.m157wNAU010975@imap1.linux-foundation.org>
	 (sfid-20080205_075935_916442_C418B3B8)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Y8cb73CuawT+GoQvOKeC"
Date: Tue, 05 Feb 2008 09:23:49 +0100
Message-Id: <1202199829.4395.7.camel@johannes.berg> (sfid-20080205_082408_740007_154F1162)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Y8cb73CuawT+GoQvOKeC
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Mon, 2008-02-04 at 23:58 -0800, akpm@linux-foundation.org wrote:
> From: Andrew Morton <akpm@linux-foundation.org>
>=20
> m68k allmodconfig gives
>=20
> drivers/net/wireless/b43/main.c:251: error: implicit declaration of funct=
ion 'mmiowb'
>=20
> because CONFIG_B43=3Dm, CONFIG_SSB_PCIHOST=3Dn.
>=20
> Might be Kconfig bustage, but this works...

It's not Kcconfig bustage and I agree with this patch more than the one
posted on netdev recently fixing it specifically in b44 (rather than
like this patch that fixes them both at once).

johannes

--=-Y8cb73CuawT+GoQvOKeC
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR6gdFKVg1VMiehFYAQIcTw/+ODa935MaGTlGXpWmuqr2cSXG3osp0ord
c3VqkeyekhzKw8Ww8Kjz3Vdon1dHR2GJ6B+39dx/Dj5GqlaV08iGgEwfRekDOTwd
I8aUIygRE3/67rZnDEqE/TmLI/H2PQ/qoyL3L2IVdoafQkJVUImzVAanvQH0RM0B
zjrw6tJkala4KHE8sFl/OCrnBorP/Ng/M9ti79e4xAAJKixJKm6tAmDTZSyZqlOO
LnvuBtPADm6lPnqcHq25PgOKwqiRx9ceL4UIIpdMl38QOqtO1mloKFBTtOhcfnbf
w8yYVVRnydfc1odOfRzNU80mRjhtkD9wFHTA2K/dRCURnquA6bxGuoyKseI+MIhN
mIVU+NvnOguvF7zanbK8EATwCsYsEtg5y4l9wuFCLR+1DKpmzZQPAs8iHCnaMzVh
VLmhrUItit+bFV92HS2v+hu2Qvmu7rFN/oSaKsuNOkdYwKC3V0kqWXSdMbY7naHZ
5hLjiDbhlxiAj0SDTSesds6tnN8in3fxYFCJHRqfVdFl7TzUaKZ9xSH7d7H5B+GN
sC2eZniEVkUrTvbXi+s+rqqegOyflkTb3VGd8QSwNyhtrzH7cZ7mt/RW3veh2P/y
Egs8YycR6DRluX6gHIv+/DanrxGGAXdBLCw/YcQTYs/FCN1QmsJBkiVl5kctCdIE
IdG0CjB7b5M=
=NrQc
-----END PGP SIGNATURE-----

--=-Y8cb73CuawT+GoQvOKeC--

