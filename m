Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:51071 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752116AbYGARCB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Jul 2008 13:02:01 -0400
Subject: Re: [PATCH/RFC] b43: remove input device usage for rfkill
From: Johannes Berg <johannes@sipsolutions.net>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Michael Buesch <mb@bu3sch.de>,
	Adel Gadllah <adel.gadllah@gmail.com>,
	linux-wireless@vger.kernel.org, stefano.brivio@polimi.it,
	Larry Finger <larry.finger@lwfinger.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	Ivo van Doorn <ivdoorn@gmail.com>
In-Reply-To: <20080701165036.GB6962@khazad-dum.debian.net>
References: <6cf6b73e0807010255x1f2d8a21m8ed3e712012ea757@mail.gmail.com>
	 <200807011227.15805.mb@bu3sch.de>
	 <20080701143439.GA6962@khazad-dum.debian.net>
	 <1214923097.3462.0.camel@johannes.berg>
	 <20080701165036.GB6962@khazad-dum.debian.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-NDwgUgDlWZFPvmZkAHWk"
Date: Tue, 01 Jul 2008 19:01:16 +0200
Message-Id: <1214931676.3462.5.camel@johannes.berg> (sfid-20080701_190206_599994_15B198F9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-NDwgUgDlWZFPvmZkAHWk
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-07-01 at 13:50 -0300, Henrique de Moraes Holschuh wrote:
> On Tue, 01 Jul 2008, Johannes Berg wrote:
> > > 1. It has an input pin that sometimes people connect buttons/switches
> > > to.
> > >=20
> > > Does that input pin act as an input for a FLIP-FLOP (and that flip-fl=
op
> > > output is the hardware rfkill line), or is it the hardware rfkill lin=
e
> > > itself?
> >=20
> > Neither. It's not hw kill, but it's not just edge detect either, it doe=
s
> > have 'kill' and 'not kill' states.
>=20
> What exactly the input pin does?  what exactly the hardware does when
> the input pin state changes?

The hardware does nothing, it just sets a bit high or low depending on
the input pin.

johannes

--=-NDwgUgDlWZFPvmZkAHWk
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIamLZAAoJEKVg1VMiehFYbhIP/R1QfWfukNOPhAdZP/T5cvCE
KbcrFNI06DSuxjKbRh6Ab/yXUwdDCil3yA8gBc9MBtuuwJac/LD3zBWnX9mIoKGS
VA6cGx1pDkwjiye8QGqUiScBi0CZWg2Yek/1XSHd2fuxwTz060UBMGqMomrmORLU
QQxzdN3im88jp2z5tJwB5/vKK8nv3mbDTcJd/diN94R5IDcE3XYy2HgUP1jzxK3I
gsR5Qg81v6JwVmrDiQ7fsT89x8gy5lGV3nI5qL/1F8K9FnZzjdaF8e/4RnRp3WT2
gErGhL8VwzstWadAVrU1lmFVqZDvfc5TunkNsKqyHc5AhNwPoOoMX7lVizaop6sl
BmJFdAK15Dlgc8+PI6jw8fofy9FkMQmOep3mtN6tkEH5zW1Xo5JVbrwYD1Q6AbJR
S0vbzFNyLeY+0NWjniScs5Qn2IV/+jYA1pu6FcWovHsGw2WxlXB+kdQLDmCTy36S
p4TlyDmUq0jXyxELTLBdUzwBd+s8WSZOjFnBbF5ZV8EhMVLrtFdBa9tzdhXMJdF+
xvB9Aym0bxHHV5t12RS/BRYjX3BvsvzmzNHQtbdyk38UYXUZYkWeFWIJHDf0H0Gl
wOuF+s4vbVZE/6/6BjiZjiWD5RFJSgayh+yaeH4TG7Om3XDLoXIypIOZN6+baWui
lHCpY0nXWls5x3VRR/i+
=Q5Tg
-----END PGP SIGNATURE-----

--=-NDwgUgDlWZFPvmZkAHWk--

