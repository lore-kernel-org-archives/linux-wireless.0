Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:48966 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751248AbYKAJPT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Nov 2008 05:15:19 -0400
Subject: Re: crash with rt61pci when resuming with card ejected
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <200811010958.09194.IvDoorn@gmail.com> (sfid-20081101_095814_286751_27D8275F)
References: <1225361553.3690.3.camel@johannes.berg>
	 <200810312301.39373.IvDoorn@gmail.com>
	 <1225491085.3550.5.camel@johannes.berg>
	 <200811010958.09194.IvDoorn@gmail.com>
	 (sfid-20081101_095814_286751_27D8275F)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ILlTMeClAH0pYi4UkgXk"
Date: Sat, 01 Nov 2008 10:15:13 +0100
Message-Id: <1225530913.3560.0.camel@johannes.berg> (sfid-20081101_101530_608437_4912FF4C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ILlTMeClAH0pYi4UkgXk
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2008-11-01 at 09:58 +0100, Ivo van Doorn wrote:

> Could you try this patch? It doesn't matter if it is on top or as a repla=
cement
> of my previous patch.
>=20
> This patch should also fix suspend/resume handling in general, I suddenly=
 realized
> there was quite a big bug in there regarding EEPROM/CSR handling.=20

Now it just hangs at resume, rather than crashing. At suspend it already
logs some MCU errors though.

johannes

--=-ILlTMeClAH0pYi4UkgXk
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJDB4eAAoJEKVg1VMiehFYVgoP/j8DDrvu/AoV7NLMo852CDwr
zk71i2PvDui3e3ualgAG4b30/grDYLJ6eo75cXKgJVF/0iiUHyQL0nj1eZZG4VdL
+SPtMBeJBJtYCV0VRjSurkAqnz5SqDzjSxEBBiGngER7897rIhf6vS9OEQztpSg3
5gBKLeFK+GiaBT2pIMnckN+A+DXNdxnPVj2rJl4kWVNbEhhZZs+hexfFriBCiRev
LsfXe4XtM+R5CtGMHwJuMnQ4srEPRcQL2bnv8YcHi0ODeWalMrLKfGSOT1oOnTJD
ay8TdIo/nNN6GhskpAczEmYifkMPs8fmYtxQjNRV6SEsIB8HrpQgYBW1vNMOVi09
3PXCXYOj2jeJV1rSAePEO3TzQPPwgnibcuDuwTLmaYh9jDjL1glmU48ORfBaVxwP
c8qIay0uW3oythyqKTnmI9qcTjSyx8jBFi4ctaXM2S6uFmqm84jgOI0foYJOX4iP
DA4Fh6gkovWY2VQ95HK2Ppgnq7mq6Mbpr+9HjPDGyvjkvEihrXvAGOEhMpKkEYxX
mU//eoEommUrDw5WjjVM82sXy+ZaChn7K1hUp9iNvzwLlCdq8YC7Hhdpc5BKnPwA
oK4HapdeQfA5VAXdGDXy4PV7z1VrkBr/vvZPVGsFhxWt2uQb31oGvv6WaSnmkTqy
H6O32R4rYXQaJlN8ilhL
=efLg
-----END PGP SIGNATURE-----

--=-ILlTMeClAH0pYi4UkgXk--

