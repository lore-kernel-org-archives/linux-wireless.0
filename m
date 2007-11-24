Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:55989 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752024AbXKXIfl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Nov 2007 03:35:41 -0500
Subject: Re: timeout problems with certain APs and b43
From: Johannes Berg <johannes@sipsolutions.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: bcm43xx-dev@lists.berlios.de, "John H." <mistamaila@gmail.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org, Michael Buesch <mb@bu3sch.de>
In-Reply-To: <200711232321.58516.rjw@sisk.pl>
References: <5b9417770711211135p65eab873leef65cd0e71452aa@mail.gmail.com>
	 <200711232258.25965.rjw@sisk.pl> <1195855050.4149.179.camel@johannes.berg>
	 <200711232321.58516.rjw@sisk.pl>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-q8dRgYyVV5+6jEzfIAX+"
Date: Sat, 24 Nov 2007 09:35:31 +0100
Message-Id: <1195893331.4149.190.camel@johannes.berg> (sfid-20071124_083543_373642_0AA2F0F5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-q8dRgYyVV5+6jEzfIAX+
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > > It seems that I can reproduce something similar on demand with an SMC=
 wireless
> > > router by moving my box sufficiently far away from it. :-)
> >=20
> > Well, yeah, that's expected though, you lose signal at some point. Not
> > expected is that it happens without moving anything. Unless the
> > calibration code is wrong which wouldn't really surprise me either.
>=20
> In my case, everything works just fine when the box is 6 meters away from=
 the
> AP (including a thick wall in between), but when I move it another 5-6 me=
ters
> away from the AP, things break down ...
>=20
> I'd expect it to work at longer distances, but well. :-)

Yeah, but keep in mind we reverse engineered all the calibration code.

johannes

--=-q8dRgYyVV5+6jEzfIAX+
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR0fiUaVg1VMiehFYAQKhkg//TEbLoZdHfrrrofLitzM9MuTIPoTygZBA
6eb/7Fn3YtroO2i4tDB6zwuuaBPQkas23D+b5wAtzglscwqNe1DqnTBblfMIit8M
hapL1msLK6cirAGYqnIG+2djCjcNYRtt3OvYsPbVJKf5y/WsIsPPDYY7xVsTs8Jy
HTK+UrLKK0iresPmhXvjKTUPFdm3EcieYjiiBVyY7amhxz/I7NtAj+brXiabwwnm
rgl9M/GMtWYGnYgsHcMVAsNON8P9QFxD5Ok2fv4bHf2pG5cxM3sK2OdbEsFD77Zt
KctigeTV0ONm7P6LtQuZDCgKOfum/1+wJOLtWnGQWZNObA8DKtoaaU56vjv+ueY1
4Y3J/CS2pCotwUYSh1jPBWgzBrXWaJmtrDWgIvUY2K5jsDZYS0ZSB9dEza2UgTf+
+HUFZB4nkCxBsRVuxJZHf2RPMI6cGkiQvxbwjCJEMyylJIAG+uoRt9ifazcg6VxS
AyLGtE/7KOuQ/sVB5SaKvQ/CocuA/4Nki2YSUgkfoEN7biUMAS7RGtodOIkEb6Ql
8clg3olDDp8IUhG0rakUMO17+ZXm2fK+g29Oweu3d9ALyWpTjT+g3MyvsN4pcT1G
vHobF+/3j4lJchLIi13iyy8CGokddOLWLukhMNo4pY5jaOyYsm6pD5Vcmod0DCib
5tiAVR/b9Fg=
=avz1
-----END PGP SIGNATURE-----

--=-q8dRgYyVV5+6jEzfIAX+--

