Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:37162 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754724AbYBLLbv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Feb 2008 06:31:51 -0500
Subject: Re: [PATCH v2] mac80211: give burst time in txop rather than
	0.1msec units
From: Johannes Berg <johannes@sipsolutions.net>
To: Christian Lamparter <chunkeey@web.de>
Cc: John Linville <linville@tuxdriver.com>,
	Tomas Winkler <tomasw@gmail.com>,
	Michael Wu <flamingice@sourmilk.net>,
	Michael Buesch <mb@bu3sch.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <200802111952.30964.chunkeey@web.de> (sfid-20080211_185245_836655_540EB93F)
References: <1202658578.11481.4.camel@johannes.berg>
	 <200802111952.30964.chunkeey@web.de> (sfid-20080211_185245_836655_540EB93F)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-po8dkvCPV8/1SyNLlY6z"
Date: Tue, 12 Feb 2008 12:31:40 +0100
Message-Id: <1202815900.8931.1.camel@johannes.berg> (sfid-20080212_113154_663331_F12B0FDA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-po8dkvCPV8/1SyNLlY6z
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > +	/*
> > +	 * FIXME: The default values in the spec (IEEE 802.11
> > +	 *	  7.3.2.19 Table 37) are 47, 94, 0, 0, why use
> > +	 *	  47, 94, 63, 0 here? Also, the default AIFS
> > +	 *	  values (second parameter) are 2, 2, 3, 7...
> > +	 */
> Well, these values are the defaults of the original driver from conexant.
> As far as I know it has something to do with the "proprietary" frameburst
> feature (aka PRISM NITRO)...=20
>=20
> So on-topic: IEEE 802.11 defaults are fine. Drop the "FIXME".=20

Can you please submit a new patch to do this? This patch intends to not
change behaviour in any way except where making values more accurate
because fewer calculations are performed.

johannes

--=-po8dkvCPV8/1SyNLlY6z
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR7GDm6Vg1VMiehFYAQLtXQ/+PACKMZ+vxKWUOSCjSBX+VFS0cQTpPxqN
KSAA0DeywR4jb3hSp2Tkx/pU4iiCOA+eKT3cWgSmj9kSWYd25dZxLPju4M3fKCk1
7+jm3uY4XvSC3Hxp1ofJUBWRk+hNo3yxXO83wHxJUgVrrUVBP9pgF3i2zQq6Dewq
rnsgwhElSz+jfBpqPDzRsYSQD2zyXYACYQW7mMI+oJTB7UltsxkSP7UwfgrN+tTv
aGa4wRg/4jSYb9S+wilijeOk3cdaBScjTeMY17z1G/NfLBbUpk+afG4mWusCRMAZ
WpbK/3oX4kWVX5C/88+9PPMsI1YtCYrFGclmHUzw3X5pgOsTt5EPIS2aBnjjikRu
+y2gEjxV3WCZhAuE0TsCgDWCjq4LppGetle2rjI6ujQtoZfS8twXbUXrki7ZShpJ
Z4G07Z6nOdBtKdZjtFvN5cSTKu7wSZ1L/cDKbH5PulpEH4zWjxZsBc9dVbKo9pMq
2686vM7CTq7jy4D7h6dGW385ns+IBLTzZ5BhaCEPzKM/hVEYbFYNdBpzPQqMNWfC
sBzkikOiq7+rmlpLVqDs0oGLv51Dn5ymTMRhNgWbXf4Q/wXx0pr6+MjtzUCx1/YR
lrvTMnVqS2zI+IeU4auYonPcwobSQjYjvplDqd5AdNmklN5qW0CkcoBcjxS4EnlH
CJKZYTrAeOg=
=c4BR
-----END PGP SIGNATURE-----

--=-po8dkvCPV8/1SyNLlY6z--

