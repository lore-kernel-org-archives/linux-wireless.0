Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:60435 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756073AbZLOOwX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Dec 2009 09:52:23 -0500
Subject: Re: [PATCH 17/19] [RFC, v2] libertas: Kconfig entry for
 libertas+cfg80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org
In-Reply-To: <200912151544.00402.hs4233@mail.mn-solutions.de>
References: <20091022133043.185554096@mail.mn-solutions.de>
	 <200910260859.39002.hs4233@mail.mn-solutions.de>
	 <1256587966.2110.28.camel@localhost.localdomain>
	 <200912151544.00402.hs4233@mail.mn-solutions.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-I02DeofbcoabrC6P4lrt"
Date: Tue, 15 Dec 2009 15:52:10 +0100
Message-ID: <1260888730.10356.9.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-I02DeofbcoabrC6P4lrt
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-12-15 at 15:44 +0100, Holger Schurig wrote:

> Nothing of this is really a WEXT-only, so I'd rather get rid of=20
> WEXT completely, even for mesh. However, I need to abduct or=20
> re-use the cfg80211 ibss commands for this, but I guess that's=20
> not a problem.
>=20
>=20
> Dan, Johannes, does this make sense?

I'd rather have new mesh commands. Right now, mesh joining/leaving is
implicit with interface up/down after you set mesh parameters, but
that's not very flexible.

johannes

--=-I02DeofbcoabrC6P4lrt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLJ6KWAAoJEODzc/N7+Qma0ZAQAM8Gxqg8DZBc0fkMHq0EtIUW
Sz62bkvgrc372SQP23HFT0DWXERdVo+9n75S22xU8LPO7/Ia46OSP60nGanqbePs
3WYZQvh3HY34Rv4mXUBFTsv4Jzuz0z8gcCdI9IBR8TNMql6KNY9YYS0hl3hBBaFA
01431mSlFJhCjFQ3/XXLvgU3xO2eGlQO0V2YJZRq1EjI/UYK/TE9zgAmyFFvUyZO
HNJwl01VF603vVkmjs3AFauuPmFtf88BFBvoCCIc/Kj54mactokLS6e0NFqclVf1
H9HCjhm7WQhG+My7R9mOa0njpwM7/0s+2Q+C2UT/tSSE3V+F7+nSPOv3Gdbl8ztB
AyAoHDGxUKV51ZdY2enSuWr4PtDunxujYhZpPElAHZf3L9UMw+NNrMqR/2t4EfYd
7f7i2LUVP3aPmQK3VO47KxfUkaXAUFCPWXvpuU5/8PiBjSP7fyYnzt7rPpL4rnxD
We8fftorks+7HU1jo8UrhXY2SgFrVrhGHe87E1nIj4Y9aRrNFOdimHVPRhcEkAar
/re1fvC8+0bL36Vylcycl+lH3yY7U7vGShbc/a7d5Gmh8iEF+XPOQO3dzpAvIwUq
r+oy4Gpc+GcdpYJyKr/V31pIoQKxb5pYwFI3hWIfDWJ07ZiLYAkuykvRoGluj+ab
u3YN2yEpOdDytKgsbvuB
=GgpX
-----END PGP SIGNATURE-----

--=-I02DeofbcoabrC6P4lrt--

