Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:40873 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752284AbYGASCS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Jul 2008 14:02:18 -0400
Subject: Re: [PATCH/RFC] b43: remove input device usage for rfkill
From: Johannes Berg <johannes@sipsolutions.net>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Michael Buesch <mb@bu3sch.de>,
	Adel Gadllah <adel.gadllah@gmail.com>,
	linux-wireless@vger.kernel.org, stefano.brivio@polimi.it,
	Larry Finger <larry.finger@lwfinger.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	Ivo van Doorn <ivdoorn@gmail.com>
In-Reply-To: <20080701173345.GA24605@khazad-dum.debian.net>
References: <6cf6b73e0807010255x1f2d8a21m8ed3e712012ea757@mail.gmail.com>
	 <200807011227.15805.mb@bu3sch.de>
	 <20080701143439.GA6962@khazad-dum.debian.net>
	 <1214923097.3462.0.camel@johannes.berg>
	 <20080701165036.GB6962@khazad-dum.debian.net>
	 <1214931676.3462.5.camel@johannes.berg>
	 <20080701173345.GA24605@khazad-dum.debian.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-q+9WBQNg7SQEWQiCMk9I"
Date: Tue, 01 Jul 2008 20:01:31 +0200
Message-Id: <1214935291.3462.7.camel@johannes.berg> (sfid-20080701_200222_029864_3BBA8EB3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-q+9WBQNg7SQEWQiCMk9I
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> THIS is very interesting alright...  and it is *extremely* important, so
> let's triple verify it, shall we?
>=20
> Please hack the driver to try to transmit data with that bit set to high,=
 and
> also with that bit set to low.  The best way to go about it is probably t=
o
> disable the rfkill support (so that it doesn't get in the way), hack the
> check-the-bit function to just printk its state, and see if the radio can
> effectively transmit and communicate no matter what state the input pin i=
s
> at.
>=20
> This is very important.  It will caracterize that input pin as either an
> hardware rfkill line, or as an input device (in which case I would be wro=
ng
> when I asked to remove the input support from b43, but one step at a time=
).

Sorry, no, I think I got confused, it should be a hardware rfkill line.

johannes

--=-q+9WBQNg7SQEWQiCMk9I
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIanD3AAoJEKVg1VMiehFYQxYP/19YoNWLUn0jWDkdP3NUk0PC
IblT6k0mQx3fSeen39TtDyxdSXXOnXGlqJNSsLgPQks1cYYj8bvjODESFNH3QoXh
T6I7Ovv3uUFKKEWkKZ+nXrKdN0nfS0eGYYx7zOOuIom9V9WqigDmuCATwRRNtiBd
9kwwVF2AGRbWkE/1MMyxQCoU3e6XgxEexYPYsHn8XGhpB1SNPlpQGoQ0961IVDQG
0RqEkPE/saxgG1+34ad1G+ret+WJ31k54hDM7Ab9Yd5N2JYeKxdTFG3wmEMHXLto
qpdpZARRrJrAn8yBGU13BirU8os7zWSCc+lWsBRt/fQL2pz574DPur7B0hGFRhxI
Na8nsU0yHHUqT7aplTFP+YU1Ne+B0+wzL8HstXryAQH5LmlcQ2lUsw9Dir//z3Zw
WgBa8Efy+k8oFKjFQYOyk+P1vHcoYPQpr+rApxqcul/oOzb3urxbz9pbrwVzRM96
oHzNcubdlS+KODswIHOZeRMbmhm34yTEAD6bnRgkiMG4WH7RTGtT3Bbdj0SiFQT5
3TojwXxI8nUR1paQZPOmjB3zUYW/lYUDCEa80U4Y5ls5eWRBR2bvJs9WCjYBLtZp
0Yfesx6/jeTyWiqdqdKKBj6bmUlLrKd9edzqGQiZKPINNnTA2QR+/QPezYTnboB9
nPd81S0hNrh7dK1Y0rQ3
=DjhH
-----END PGP SIGNATURE-----

--=-q+9WBQNg7SQEWQiCMk9I--

