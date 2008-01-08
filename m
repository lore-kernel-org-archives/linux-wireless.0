Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:60203 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768AbYAHRXL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Jan 2008 12:23:11 -0500
Subject: Re: Warning emited by 2.6.24-rc6-git5
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Ivo van Doorn <ivdoorn@gmail.com>, chris2553@googlemail.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <1199812167.6762.1.camel@johannes.berg> (sfid-20080108_171433_924622_7CA175B9)
References: <200712290942.37396.chris2553@googlemail.com>
	 <200712291614.55732.IvDoorn@gmail.com>
	 <1199261473.4172.58.camel@johannes.berg>
	 <200801022012.52287.IvDoorn@gmail.com>
	 <1ba2fa240801080744u5a076202n91f11b0de87384f8@mail.gmail.com>
	 (sfid-20080108_154444_241831_C6355BE0)  <1199812167.6762.1.camel@johannes.berg>
	 (sfid-20080108_171433_924622_7CA175B9)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-cRDTn0D4IXje+syNfRZR"
Date: Tue, 08 Jan 2008 18:22:56 +0100
Message-Id: <1199812976.6762.7.camel@johannes.berg> (sfid-20080108_172314_951196_BA4903A2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-cRDTn0D4IXje+syNfRZR
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Tue, 2008-01-08 at 18:09 +0100, Johannes Berg wrote:
> > I didn't test the copy solution yet but in 11n rates I see as a show
> > stopper. All 11n packets are QoS packets.
>=20
> Really, go fix your firmware.

I meant to write more here but accidentally deleted parts when
restructuring. The firmware should insert padding to make sure the
payload is aligned on a four-byte boundary at all times when the start
of the DMA area is aligned that way.

johannes

--=-cRDTn0D4IXje+syNfRZR
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR4Oxb6Vg1VMiehFYAQJOMxAAqxdY/YvNLXhLN0i9BQ3QLpKKkvN+yEUl
lfBvYRADVMQLzn2LT/ZZHRXUUWNt+FLvCvEWvJwxHv9x8ZfwSFTasGZXuw/ldlCK
jOkD7XoDtvdVHxf+41j5IBjgV9ZFpNabKj0Kx+A6LJFlGcDt6VMcVtVx5bsDl5NI
4Saayp1oJnAmnUce7Xo9dhURPrR3AyvRXN+G5ZKJwzoyUjHQBRQTIi4mshEyjMhq
sYnwLydjxpT5I8Xp2jDVZZvW/EAtXcs+nUylUv1SQzqSWwUd4oiXbGbzR/y+c02t
xXYuJJupkuptOPOIwJHYEl1uGuLmFhFHvn13/zb5KHe88H/eQYqoEA8agwoTe9Bi
zUIE6qmWOOUV21ofiliqggWLklOZ/+FnpNjqoOgP25GRLwoQP7Ya2T7ZXVQGZc3a
hoIcZ3vYAJ60sW1/Sx2tE9mPSnCy0vrD+RduM8q5K7ogDrnSQX2GdBhqxnPSxvqQ
jta7+yL/YU3fNIPW23ZCXmXEKG4mtBP4ETS8ZppVN1+84C1bGrdEVkhQqdjHLvbF
D0JoL4jQNuz5327HuhUEldU3vfI2b3JJ9rQbOivK8qHiya4FRythWfmAZcDxupE6
DcBV0cB4QcxCElnXiLC85mZ24inov64MM76LGAclgfhGqB4LEBUSc+DLAeaRkzXA
4780Fy0ahEU=
=PiRv
-----END PGP SIGNATURE-----

--=-cRDTn0D4IXje+syNfRZR--

