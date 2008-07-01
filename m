Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:55362 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754043AbYGAOjX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Jul 2008 10:39:23 -0400
Subject: Re: [PATCH/RFC] b43: remove input device usage for rfkill
From: Johannes Berg <johannes@sipsolutions.net>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Michael Buesch <mb@bu3sch.de>,
	Adel Gadllah <adel.gadllah@gmail.com>,
	linux-wireless@vger.kernel.org, stefano.brivio@polimi.it,
	Larry Finger <larry.finger@lwfinger.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	Ivo van Doorn <ivdoorn@gmail.com>
In-Reply-To: <20080701143439.GA6962@khazad-dum.debian.net> (sfid-20080701_163519_434021_0B584900)
References: <6cf6b73e0807010255x1f2d8a21m8ed3e712012ea757@mail.gmail.com>
	 <200807011227.15805.mb@bu3sch.de>
	 <20080701143439.GA6962@khazad-dum.debian.net>
	 (sfid-20080701_163519_434021_0B584900)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-cIUw7giFS0sxlf60/OAR"
Date: Tue, 01 Jul 2008 16:38:16 +0200
Message-Id: <1214923097.3462.0.camel@johannes.berg> (sfid-20080701_163926_484693_DAE92934)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-cIUw7giFS0sxlf60/OAR
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> 1. It has an input pin that sometimes people connect buttons/switches
> to.
>=20
> Does that input pin act as an input for a FLIP-FLOP (and that flip-flop
> output is the hardware rfkill line), or is it the hardware rfkill line
> itself?

Neither. It's not hw kill, but it's not just edge detect either, it does
have 'kill' and 'not kill' states.

johannes

--=-cIUw7giFS0sxlf60/OAR
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIakFUAAoJEKVg1VMiehFY35UP/0Ib7OqJlxrCmWKUH6Cqb/bT
mZ5p5dUPQ9awR2tCkYrDbinaxLzEzdikFOKhDNTezv1l6FTxHm6a9UYFoG/EqSy6
iO7VdQ75FuB+Y8Y9V8AXFN56xJdpfqPNW8rf90kocFyVoRdA4gDoD+lB5BqvAdMi
IWUHZD7w7Gj+qW1pRvLqFHKNJA0Kqj+HrRnsI8+faQYSSxILQ9pGI/6fEYpcbzrm
Cq4dFAJperTtktSqW3xXg/NjtharbOhF7848Oh8aYUglQN9lzBCm2WDoaWpR/HDp
3D3+MSzJsBcL1ss54w2quUK7zLFQgcGw76Tkmy3VFIQpvBCP8jUCt8DxUcb9wrqp
STvKT+4W7q7s1L9vMKDYV2fshkOeJPaSfZAlqG3Aru7kAJNqQKKV8f8GIoUnVTJq
w9EKMk6cT+k6aJqR6G7Xz1/gpBezoRDjlJFncdjJI7wE/RmOwjvwG5T2OIDjt95A
AakH8uENYZ30ZQRZi3Q26lJ+lyR35MpQDMfjHP5gACgkccEsas8UiGrEBd6E6WqY
eNFq4KvO0b2Sk56WN659oq7COv6o1hwBHoklJTZYcwkshvi7yJ/8odXKE7d8Z70Q
eVTjcokvcU33G4ehAMD0rWNXPWQu3gNbWRXj82CcJZvfEaYZZKIS8JDqEqKjp4kC
7WVNkqbFiPRLIIIOwOTH
=pCaL
-----END PGP SIGNATURE-----

--=-cIUw7giFS0sxlf60/OAR--

