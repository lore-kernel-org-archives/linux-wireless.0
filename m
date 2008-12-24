Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35454 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316AbYLXXwA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Dec 2008 18:52:00 -0500
Subject: Re: [PATCH] b43/ssb: Add SPROM8 extraction and LP-PHY detection
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: linville@tuxdriver.com, Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
In-Reply-To: <200812250039.28824.mb@bu3sch.de> (sfid-20081225_004044_707129_A1975627)
References: <200812250039.28824.mb@bu3sch.de>
	 (sfid-20081225_004044_707129_A1975627)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-D+3xCzzQpCec+UFvm91O"
Date: Thu, 25 Dec 2008 00:52:04 +0100
Message-Id: <1230162724.3162.3.camel@johannes> (sfid-20081225_005206_194685_2E017219)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-D+3xCzzQpCec+UFvm91O
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-12-25 at 00:39 +0100, Michael Buesch wrote:
> This adds detection code for the LP-PHY and SPROM
> extraction code for version 8, which is needed by the LP-PHY and
> newer N-PHY.

I still get mac address ff:ff:ff:ff:ff:ff with this, but it might just
be that we need to use a different address or something, will double
check. We can fix that, so don't take this as a nack, the patch lays the
foundation, and the devices aren't supported anyway.

johannes

--=-D+3xCzzQpCec+UFvm91O
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJUssiAAoJEKVg1VMiehFYt2UP+wZbwXiNmRYcYG0HI6upuYo/
ks9Cb854UVdLHrbet49ZBGzyUaVnjE38xvf+Fs6xJHSYZEDobaACBba72p3iUFJY
e+3rmM3IKbXkwBYyTh1MAS1eMyC0Fu1fk91UfWLABxxL8zjHiQqsmoEMTorBaOHm
7+PAOi27elWyBxe+nizL6BEgoMTmOBYyidONngI/Ra2UrTsNquHI7brfxj5hJnfb
0pM3YKqZ6qAyaWQ7LyWQx/kN+iczF0XNLx0mYvJXoiUNQIWFHQN3XjiMQkk4EP1+
z9nDzZkjaWU+4Olelg1RuEIZ+BoXdm/zp0thP25Df9mZrDNzqjwCuelaYP6+UVfb
Nz3zWF0Rrr1M7UBPeqbW5YF6kZyGOK+uA4sEMOUJMuyb+tjn2BLzpfLLZRiiEJ+Q
UHbD2iD4/D8a4a6+FWIy2HX9c6d7VIPQusbCy4y6ni78CJwZVhwLlXdLNJl6o+Qe
n8SJt8Rcv9M8jI1yvUschRBXjEnz4nsze8iIQn0CMzDQjnw30eqBYhBevzRVQNMR
pOuzQXomPXlNxPyUrVnqFmmQh5RC8VuImDwLL/UPP9ajyQ5X14aop8cDgX3ln2IL
dPExSDGRQW4xswD7M0ZMBrcDk2w+k+NrTqcenY3oQZrllsxrm8bKcVWurA48fdPP
mce8qbHSqCU2rjgqf4lz
=pDAe
-----END PGP SIGNATURE-----

--=-D+3xCzzQpCec+UFvm91O--

