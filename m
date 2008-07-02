Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:47795 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760472AbYGBHWZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jul 2008 03:22:25 -0400
Subject: Re: [PATCH/RFC] b43: remove input device usage for rfkill
From: Johannes Berg <johannes@sipsolutions.net>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Michael Buesch <mb@bu3sch.de>,
	Adel Gadllah <adel.gadllah@gmail.com>,
	linux-wireless@vger.kernel.org, stefano.brivio@polimi.it,
	Larry Finger <larry.finger@lwfinger.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	Ivo van Doorn <ivdoorn@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
In-Reply-To: <20080701235747.GG4292@khazad-dum.debian.net>
References: <20080701225207.GB4292@khazad-dum.debian.net>
	 <1214952993.3462.14.camel@johannes.berg>
	 <20080701235747.GG4292@khazad-dum.debian.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-OQzkYq0+0j+p1tbr+20n"
Date: Wed, 02 Jul 2008 09:21:10 +0200
Message-Id: <1214983270.3462.18.camel@johannes.berg> (sfid-20080702_092228_787103_E5D67975)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-OQzkYq0+0j+p1tbr+20n
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> So, please accept my appologies on the tone of the last email.  Please
> reconsider reading that email in full, and please try to ignore the rantn=
ess
> smell in it.  I did try to explain the technical reasons why some changes
> would be needed in b43.

Ok. I actually did read it but decided not to reply to most things. I
don't think it's that everybody needs to be educated on the input layer
(I've written real input drivers before) but rather that nobody really
knows how userspace/kernel interaction wrt. rfkill should work.

> > To address one point though: userspace does want a notification when th=
e
> > hw-rfkill is activated so it (e.g. network manager) can ask people to
> > un-rfkill their device.
>=20
> I tried to add such notifications directly to the rfkill class.  rfkill n=
ow
> issues uevents and calls a notification chain for any state changes.  It =
has
> been modified to differentiate hw-rfkill from sw-rfkill, and export that
> information to userspace for network-manager and other applications to us=
e.

Sounds good.

johannes

--=-OQzkYq0+0j+p1tbr+20n
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIayxiAAoJEKVg1VMiehFYJ/YQAL2meZds8kRNXKwp3Z+tTb6l
2iIR4eHd7obl9jm0rmfIJJ1Z64rrz5bYLLo+B9dploPoI/T52q2GJY0yXdlhK4Te
abxt3KlNPMUMebaXDzebuY1b0M5dy1hY5w4QJzbfz5EdCLkhPe2SswDbBvBn10Vd
3ftSGfDS3yn7UUdp2TSybkbyiUqoPF/wJC11ty+H5rbcTxOg3kQZOPH4OWHHSLo6
6ddVYumt00e36GXvdmcQurPCyiFioiUvQq4LxG1DjR1HDY1DST6grC8Q6epsMjr+
igbOBSJfy/q1AQm1YqGExg2KHFKB+5gijtx8UWr7FIHE8OzbdBsiL9w/5GEF/s1T
UpTm1gnP5TZyZoMrhPzjxXAvtndiGyHUKpK5c9tvjGYk0Kg5iXCwp0r7Ahmgqxm6
vEXSN5pIq5fL2zZ+g6FaWVW8+vtqyzcp/Nt+CuqXU7rJ/9BlF5kfFjJeK2yhLV+H
ykQ/+QCAGLZ/TVx6QQigKDOlg9qSQ3ufNQAExu/Ogz2Rtn10qJHSX4cO/RKDT4j7
JINfZuIv986lTZQFmusC2WN6RgM0PL6qPI5aCtTplZGxBHHLMqcb59U2rGi9PqB+
MZafS4bMetW1A6HDYjfcCULq8i7d4eKxagrrQ7dsd7eAK4ftG9SlCZJedFwg4SjN
XxjVjt/EHJrI9B/vphjT
=KbkW
-----END PGP SIGNATURE-----

--=-OQzkYq0+0j+p1tbr+20n--

