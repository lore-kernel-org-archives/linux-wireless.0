Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:34114 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755569AbYIRSdD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Sep 2008 14:33:03 -0400
Subject: Re: temorarily out of range -> no TCP?
From: Johannes Berg <johannes@sipsolutions.net>
To: Anders Eriksson <aeriksson@fastmail.fm>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20080918141955.0119E93CCA7@tippex.mynet.homeunix.org> (sfid-20080918_162007_153222_33378A12)
References: <20080918141955.0119E93CCA7@tippex.mynet.homeunix.org>
	 (sfid-20080918_162007_153222_33378A12)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-gvetb/TsSkqfmXUcBUG8"
Date: Thu, 18 Sep 2008 20:32:28 +0200
Message-Id: <1221762748.20772.7.camel@johannes.berg> (sfid-20080918_203309_675989_C648A086)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-gvetb/TsSkqfmXUcBUG8
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-09-18 at 16:19 +0200, Anders Eriksson wrote:

> As I have a fixed IP address for the client, I see no reason why the tcp =
must=20
> die just because the link level device is temporarily gone. IMO, it shoul=
d
> hang there waiting for a route to send it's packets, and a suitable route
> _is_ provided when I modprobe/dhcpc the client.

Oh and that works just fine for me, I do it all the time. ssh can take a
long time to recover though, for some reason, so I tend to kill it (I do
everything in screen anyway).

johannes

--=-gvetb/TsSkqfmXUcBUG8
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI0p64AAoJEKVg1VMiehFYNcQQAK1tQ/2+J3g0UfUXi6iKZjEm
rC2ruJjphxyHptAOKMa+MLgK0Rl9Hs3SoVMkX4dvRsJB8EQ9HGIjD0auSEp68BuT
2IhP1wh5XxhHxLwWR6spwzsbSWyehCKxwroV9iR9cQ4f2agUGa8odJ+LxXE4Mzj2
U069Gb43VV3B8xk/GNGtllNyH/DLDbRhDnBg3wWiLWlAhMRKNwQ9tPXgGSXjnU6J
2h2B7vWwpKUnjMj/T+zi3zP2I+Noi9V02zJ6CG1GQeyDmgqttbTqgqCiuripwgUI
eyuUyAuwR06UWKQEZTJFFc6kOmwKOWzq5eWnyFjtNs/kYz57nMs9mYeuDTe0ixoU
oiFUI88OfOZjugsZlkN2k1HBhv29EoDK/oHF2pd9Fru21qzMrS9jzfvq7MRH0vfX
FotzgmeGE973qOD2uS/Zw/J5x/pDv2vUhhIS03DA+o70BqpjUQsAVRiNQCgbX2VH
WvhVFptcbUbk9UmJXQ7xYmJIkma/o2Cq/gOIxko+uwvHiKA22yAN9NFJtJ5dexJI
6TNGIMASNLvlHTjOYyEG/cUHIHNrYHdwE50Ea4prshvPaWwgR9OTpigolbQhldNK
/PGNuH41k6Y/PkyLxksfaQthhtxQKqyA1PXzrmsCG23BadBm7W3lfvuus11URt0/
Jju0QJ2ondDMxfxFhv+K
=ZRo3
-----END PGP SIGNATURE-----

--=-gvetb/TsSkqfmXUcBUG8--

