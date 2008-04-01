Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:59717 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752306AbYDAMJd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Apr 2008 08:09:33 -0400
Subject: Re: is adm8211 capable of sending arbitrary frames?
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Wu <flamingice@sourmilk.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <200803311438.41956.flamingice@sourmilk.net>
References: <1206449800.16475.255.camel@johannes.berg>
	 <200803311438.41956.flamingice@sourmilk.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-rRCtaEuDNekezr10t8lp"
Date: Tue, 01 Apr 2008 14:09:28 +0200
Message-Id: <1207051768.5143.62.camel@johannes.berg> (sfid-20080401_130936_632495_EF456298)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-rRCtaEuDNekezr10t8lp
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > This appears to mean that it can send neither QoS frames properly nor
> > can actually communicate with an AP other than the one it is associated
> > to. The latter isn't much of a problem, but it seems that the driver
> > will fall over with QoS AP since it doesn't strip the QoS-data bit from
> > the frame control. Or does the hardware do that? In any case, mac80211
> > shouldn't be announcing QoS support for this driver, should it?
> >
> ADM8211A does not support QoS.. ADM8211B might and ADM8211C does for sure=
, but=20
> that revision was never sold AFAIK.

Right.

> At any rate, there is no QoS support for this driver.

Yeah but afaict mac80211 is buggy, it can send QoS frames even if the
driver only has one queue...

johannes

--=-rRCtaEuDNekezr10t8lp
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIUAwUAR/Il96Vg1VMiehFYAQI+KA/2Lwh0EMo3/4d1SWwJmuDbmWLYVqeMH2aL
3R+XXo/PuP2QYyGeXlV7M0cB4ApFXjNVFPrqcnEVICdD10Bl10fQrTSifGTP0kNc
uKSnexXc0JVFQN3s3SHH79i3LUd+XqCaOpQ3837kmptkCAWAUZ00N+ZFXvBCZeea
gspF1E+vQFH3pC6cV7KJ1sY4WVEJqqoUnd6TeOf6LyYZR2jmQREiiIz6kfraWnuK
cFycUnDijlSrW9k5EExImIKlA6FWER/aVFEop3noHJtWNpU44g2Vsk5i6QqBlJGl
YslRvfCMXxdvwZsbFFI4P6HLuj9FVeRo7/HeAvBy2TLQ7XizjwY8T2ahnWbkYsfR
dNG6r3c52muMc6ikbYiVQynz18WKrkgOldWtjmMRKuoOfrOpKGJojScbvaw3N3Q0
d9iEP01zUXAeha/oXXsrXm2dJwmp+7qKdjb0sRKu1UUaWf641mEn8u3WiXSwsjKM
fjEBA65IecVx7BSenRuvrhPBlzhcZnYe5S3R4VxTBeo2tUWkaIqrXYJ/KeazYmc2
fRR5WEguVsJ+Ar4LC54+pbyPg9xDzkmdLvrodNTtCJNDPQAt4eO/OJ1Jfu8z2arP
S4ORzqzrc6f1LmSfAh9GQOyF4luRZSbHekosU4HbBwB13F7kqwyu7jz9tCJRYcUv
BTR5zWYIMA==
=wV+x
-----END PGP SIGNATURE-----

--=-rRCtaEuDNekezr10t8lp--

