Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:42500 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758444AbZEDRg3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 May 2009 13:36:29 -0400
Subject: Re: [PATCH] add support for showing power constraint IE
From: Johannes Berg <johannes@sipsolutions.net>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1241456863.2903.29.camel@localhost.localdomain>
References: <1241453167-3720-1-git-send-email-marcel@holtmann.org>
	 <1241453408.8683.53.camel@johannes.local>
	 <1241454909.2903.17.camel@localhost.localdomain>
	 <1241455125.8683.60.camel@johannes.local>
	 <1241455848.2903.18.camel@localhost.localdomain>
	 <1241456088.8683.62.camel@johannes.local>
	 <1241456863.2903.29.camel@localhost.localdomain>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-KqSzXZM8zp1+y+/iNcJZ"
Date: Mon, 04 May 2009 19:35:58 +0200
Message-Id: <1241458558.8683.84.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-KqSzXZM8zp1+y+/iNcJZ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

> 	Vendor specific: OUI 00:90:4c, data: 33 0c 10 1f ff ff 00 00 00 00 00 00=
 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 	Vendor specific: OUI 00:90:4c, data: 34 03 00 05 00 00 00 0f 00 00 00 00=
 00 00 00 00 00 00 00 00 00 00 00
> 	Unknown IE (45): 0c 10 1f ff ff 00 00 00 00 00 00 00 00 00 00 00 00 00 0=
0 04 00 00 00 00 00 00
> 	Unknown IE (61): 03 00 01 00 00 00 0f 00 00 00 00 00 00 00 00 00 00 00 0=
0 00 00 00
> 	WPS:	 * Version: 1.0
> 		 * Manufacturer: D-Link Systems
> 		 * Model: DIR-615
> 		 * Device name: Wireless N Router
> 		 * Config methods: Label
>=20
> I didn't find any specs to decode IE 45 and 61 since all of them mark
> these as reserved. Not sure if these are defined in future specs or if
> they are deprecated IE. And it seems its data is similar to what is in
> the vendor specific elements.

Both are HT.

> The other one that keeps showing up in my area is:
>=20
> 	Unknown IE (47): 06

"Broadcom proprietary" -- seems it would make sense to ignore that.

> And I do have some other vendor specific ones, that I don't really care
> about and we might even never know what they are:
>=20
> 	Vendor specific: OUI 00:03:7f, data: 01 01 00 17 00 00
> 	Vendor specific: OUI 00:03:7f, data: 02 01 01 4d 00 03 a4 00 00
> 	Vendor specific: OUI 00:03:2f, data: 01 00 01

You can check wireshark, sometimes it has something useful. I think
there are pre-wifi HT IEs too in some vendor IE, might be one of these.

https://mentor.ieee.org/802.11/documents?x_dcn=3D31&x_year=3D2009 is useful
too (at least for 2009, for next year somebody will have to find the DCN
again)

> However, as I said before, I am quite happy now since the provided
> information by iw are now the same as I get with iwlist. Actually iw has
> now superior decoding capabilities and is more useful.=20

:)

> There is still
> room for improvement, but I think cutting a new release is not a bad
> idea.

I'll wait a bit, maybe somebody feels inspired by this to provide HT
parsing.

johannes

--=-KqSzXZM8zp1+y+/iNcJZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ/yd7AAoJEKVg1VMiehFYJ5IP/2fT1eek5I1OnEWTCG+HVQYb
pNogO9ziVDtiaCTuhlmjPmX43WGsXkFIOFleX7KRTbye11dnSHn55F2qNEiQmQja
HXoPpEHrrBCeOdvOOeUrbcYS7KMdGIrCEtIVMTyKul3FnbVoj74U9PtLS5z/CWJz
U1dyBJSptrJgMaLM6Xkcy5g48h7ZV8BOSQMnskhevG90cENW3bWKMOpIPfF6Jejd
/CcpN85tRqK/BZK4LaKy+0kIrG/R0Xxcm5hfsg7ySpHk6r6JJBvuo8DdMikHyqgm
ucM8mGiZvGJ0UKHW76F29y65x4S/uX6srRXDPLSodfti/EejAgUFxLxtv6fpvky7
v3kLBWnb13QYS5luaJh4R/d9Q1WQ5wuGoz2lAutx0ZjAZ8GvjP7ypxcQMuICNNtE
jwoR26y62Pp8ZYNZeL2aJ0ftiyjUxdPvLcxpnRo6ngB0JwdVY4mfKi9ArOXAOCia
SPr8vJMGR2Y+vlwrpOTA4tyM4XwJV3aZ5uV0kqA7gsO1cN2YHPngw9d6XAhjazTf
cGbA82tOVwpAK457dcgAcCDR/0FHr+UCbVNRAm4Q7+jQLIpycHbu/f8PHWHSh0XQ
3HEqaO/6YUlX3lbtWZ9XUaz1cWHiy05ALWSSiqzl4oVR/7tC62ODx2yT7JkU9fma
4Sjjq1pOAgdXhtqPjGaM
=dQzn
-----END PGP SIGNATURE-----

--=-KqSzXZM8zp1+y+/iNcJZ--

