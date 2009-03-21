Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:57679 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753476AbZCULKj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Mar 2009 07:10:39 -0400
Subject: Re: [RFC][PATCH 4/5] ar9170: USB frontend driver
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: Christian Lamparter <chunkeey@web.de>,
	linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
In-Reply-To: <200903202058.34420.mb@bu3sch.de> (sfid-20090320_205950_810612_C1C0E9F1)
References: <200903170410.20261.chunkeey@web.de>
	 <200903202036.43107.chunkeey@web.de>  <200903202058.34420.mb@bu3sch.de>
	 (sfid-20090320_205950_810612_C1C0E9F1)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-Qv+C+6a9GnS7rR+N+iAG"
Date: Sat, 21 Mar 2009 12:10:35 +0100
Message-Id: <1237633835.5100.173.camel@johannes.local> (sfid-20090321_121046_732613_4F60B8AB)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Qv+C+6a9GnS7rR+N+iAG
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-03-20 at 20:58 +0100, Michael Buesch wrote:
> On Friday 20 March 2009 20:36:42 Christian Lamparter wrote:
> > USB frontend driver code for Atheros AR9170.
>=20
> It seems lots of patches didn't make it through the list. :(
>=20
> > +#if 0
> > +#include <linux/mutex.h>
> > +#define mutex_lock(m) do { mutex_lock(m); __acquire(m); } while (0)
> > +#define mutex_unlock(m) do { mutex_unlock(m); __release(m); } while (0=
)
> > +#endif
> > +
> > +#endif /* __USB_H */
>=20
> Whoops, debugging code? :)

sparse, for some reason mutex operations aren't annotated... Probably
because Ingo wrote the code...

johannes

--=-Qv+C+6a9GnS7rR+N+iAG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJxMsoAAoJEKVg1VMiehFYjRkQAIsg+T3bFATbgJvsTLW+MCKF
LR0SPKXZg8XrXRNaWUOxTAkYuPamuJq3PuD9aP2tPZwen3hfYWko+uJzNS/CPczZ
MvoFE3ONH6XOrNt3SAdevPVp2IYImqpTfkuZV3GeqR0W4+eIplKvUPy+Fequ+427
6ikk5EVmDjiKGxdPF/aFHcHAjfAITIhCdodAD1Nf1vb3Zzo+SD3b7qo2Yaz2mTBr
KUZ5xr2MOcu1qwZJhUaes1YYxkWZYlweIgwSG1wPRonK0NsfkSYeXVS1vUGqlu8o
v0aZQR4mmtcssplMVVEnezq2IKY4W/jYU0W8jldX/35BKFJmw8J3V17RBHg+MDX8
clUJrO/rf1ZwlW8bgDDs4kPjy08mXoXzkf8uUjy+5HHQAS5kpQpbmkOkjLLQe3kd
Og1PseaJZvdHt6NkV+MKIU5lvDmfkLMQ/esLd/OuzdTUE8uiV4uwhM1cB/KoQy5o
Pe2ky1H5Ak23udyf1WFP7gxB+mKGoVgjV5/A9mORM8PwIFPcRpyNpl5ox0ABSFYn
Wxu4CixZbwlaMHPLYoXITWVg4kCuui7+/8gKRl2bnATt9gX4TMO/Mbe8lXBFEH5p
ydZnQxqHt8GC37c12IRWNaD+HNAQq/k5C3fOtXCcIak3eayvAgQt3oaFNczZRig+
lC3pDzk2xBAFxdIWvmPx
=sXhs
-----END PGP SIGNATURE-----

--=-Qv+C+6a9GnS7rR+N+iAG--

