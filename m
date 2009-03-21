Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:46822 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752821AbZCULeb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Mar 2009 07:34:31 -0400
Subject: Re: [RFC][PATCH 4/5] ar9170: USB frontend driver
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: Christian Lamparter <chunkeey@web.de>,
	linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
In-Reply-To: <200903211220.29991.mb@bu3sch.de>
References: <200903170410.20261.chunkeey@web.de>
	 <200903202058.34420.mb@bu3sch.de>
	 <1237633835.5100.173.camel@johannes.local>
	 <200903211220.29991.mb@bu3sch.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-fzbENMGkOfJrEU++yJYc"
Date: Sat, 21 Mar 2009 12:34:26 +0100
Message-Id: <1237635266.5100.174.camel@johannes.local> (sfid-20090321_123434_945911_394C6B2E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-fzbENMGkOfJrEU++yJYc
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-03-21 at 12:20 +0100, Michael Buesch wrote:

> > > > +#if 0
> > > > +#include <linux/mutex.h>
> > > > +#define mutex_lock(m) do { mutex_lock(m); __acquire(m); } while (0=
)
> > > > +#define mutex_unlock(m) do { mutex_unlock(m); __release(m); } whil=
e (0)
> > > > +#endif
> > > > +
> > > > +#endif /* __USB_H */
> > >=20
> > > Whoops, debugging code? :)
> >=20
> > sparse, for some reason mutex operations aren't annotated... Probably
> > because Ingo wrote the code...
>=20
> Well I think it would currently generate lots of errors, because we have
> code like this in the kernel:
>=20
> if (x)
> 	mutex_lock();
> ...
> if (x)
> 	mutex_unlock();

That's sloppy code anyway. Not to be encouraged.

johannes

--=-fzbENMGkOfJrEU++yJYc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJxNC0AAoJEKVg1VMiehFYQLUP+gLTpbDtkASUmbj9Sro59Aio
sH/dzhHnfQKaEpp8iObI5YOvCrs0Pp0vh+rIqbGkWXrBmcE3J4hw66zJzmRKhKLt
fMegFwHVn2h8UO+j5Bn+G5TmnXamBYUoroh7a4zsJb64bEZivPPLBUiEgdqGNugB
0zNL8a7LoTOLhstyeP/EKZhlBGpa2dtJOUTo2nNjO/rejQno2RutDuZXEseWvFZ8
yKIiX4j8wDocfZSqfk+TMXRWJGaBf/LfLC7Y33QeTIqx5LfhKJJsHbhw9h7f9IMn
qYCjbCLopQtYI27z2ffUg63kNPd1UzB9EHRcwREVfKjvj6KcxjRZLO9Ol/uuNK7F
r1wa0mo40dkp5zRUpUfH8Cy4gjSATE4SHRXJyLTmrpJQ1FQ/mn7HkyLhXGCtOAGu
cczitkWG7V3fZUVZvMY8lp4iAWy2qJ0qwSlA7o7UcrytJCkUbs3CaAuHhlNrpSs7
P67nRTzPq3AHrkx6bXGNC9kR4BPpyTnxXSBGYr+r1acxMzmRlCiXC+aJKpjbAuMX
pLRkmPo78Y0blf9qYdi0BhmV+gCgbBfdMmo+Mouj3J+M+oY8xrY6//ApxZhelzsJ
5kKxk+rOS/HSoQSxYntufvTF5nKM0I2KO8p3omWJ3i2R79i4Eh2L5lkgtYTsSPd3
luOdYmnID7v2M1i1ke3c
=Pumi
-----END PGP SIGNATURE-----

--=-fzbENMGkOfJrEU++yJYc--

