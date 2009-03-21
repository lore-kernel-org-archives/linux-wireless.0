Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:57854 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754127AbZCUMym (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Mar 2009 08:54:42 -0400
Subject: Re: [RFC][PATCH 4/5] ar9170: USB frontend driver
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: Christian Lamparter <chunkeey@web.de>,
	linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
In-Reply-To: <200903211349.02761.mb@bu3sch.de>
References: <200903170410.20261.chunkeey@web.de>
	 <200903211220.29991.mb@bu3sch.de>
	 <1237635266.5100.174.camel@johannes.local>
	 <200903211349.02761.mb@bu3sch.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-AncwexqNL9ZTrD/he8bj"
Date: Sat, 21 Mar 2009 13:54:39 +0100
Message-Id: <1237640079.5100.185.camel@johannes.local> (sfid-20090321_135444_361251_3BA2DED4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-AncwexqNL9ZTrD/he8bj
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-03-21 at 13:49 +0100, Michael Buesch wrote:

> > > Well I think it would currently generate lots of errors, because we h=
ave
> > > code like this in the kernel:
> > >=20
> > > if (x)
> > > 	mutex_lock();
> > > ...
> > > if (x)
> > > 	mutex_unlock();
> >=20
> > That's sloppy code anyway. Not to be encouraged.
>=20
> That's not true. Sometimes it is the cleanest way to do things.
> Look at drivers/ssb/main.c. To make this mutex-sparse compliant, we'd
> need to introduce quite a few sub-functions.
>=20
> It simply is a limitation of sparse. Nothing else.

No, I still think it's sloppy code; some future work will in most cases
invariably move the conditions further apart, at which point it becomes
more and more unlikely that the invariant that the "x" doesn't change
inbetween is maintained.

johannes

--=-AncwexqNL9ZTrD/he8bj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJxOOMAAoJEKVg1VMiehFY42IP/2oDh0acpmFVhe7mx1C/fCsE
GW8kbsk0SEnhj26k56gp6KxOPRdBQJKPYq6UYaa/wDS+P84C0MPtFKUyT92Q1QqO
eNQ50XB1i/js7MzHScZgiVxf8u7EgLBDLe3Wf9V6ELwxEUZ/zGQuKzCX6+5Foov6
qR77tMmIU/WHo19gXjjn5/C8Aqf9sza+arnDPFtSSOY66KIoQbrlXq6eBRbGMjxX
B5ZxmmCQDX62J3Yp5uMYomlMcUvZ4Z88rnv1H6cVNG6y78nxIwtaomM7Vr7fuaJF
q1P870gxiRDrVPcGVzXMQoWrNdbyEsgfIHAHazMrtHTsjUYhWst1CL7DQwfcYwv+
7tiLWL76/bv7uqf7iR/dCEEoGNQQpwJnFxGWhHrP6X1mNmMg6Cf6vWiYlvdoUMgO
g9XWFLE52JCLp7DYcfbUUVTs8beV1EYe3zoaJ/amuHSFiQW4LrF5/9+Gb9B0GWRh
WFlqwxGY5oARK7GbvdyIytOpZA88I/7icgivsXvPwMV6m/4pw/U5lZxtkzIhLr69
Kco9T/XMUZfOTpm0LmnnZNXoDQYfT3kTVvaXtMN/s0stNFLbguWTnSz9VmUnwTuT
3pzQ8fIeJh0SMYzP7UnRwF3ZEjE4c+HvGL2jez/h8ONFRL94APJnxSBR6SJuxHN3
1+9oApnslVbjF/rjXxBO
=eZ1W
-----END PGP SIGNATURE-----

--=-AncwexqNL9ZTrD/he8bj--

