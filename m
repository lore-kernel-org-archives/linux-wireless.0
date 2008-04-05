Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:43420 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466AbYDELD0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Apr 2008 07:03:26 -0400
Subject: Re: [PATCH] b43: Fix PHY TX control words in SHM
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: John Linville <linville@tuxdriver.com>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
In-Reply-To: <200804042143.07849.mb@bu3sch.de> (sfid-20080404_204629_411334_E42A5E2F)
References: <200804042143.07849.mb@bu3sch.de>
	 (sfid-20080404_204629_411334_E42A5E2F)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-SV+0qPBQl728m1MUvhk6"
Date: Sat, 05 Apr 2008 13:03:20 +0200
Message-Id: <1207393400.3860.7.camel@johannes.berg> (sfid-20080405_120330_111322_3B31F1F0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-SV+0qPBQl728m1MUvhk6
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Fri, 2008-04-04 at 21:43 +0200, Michael Buesch wrote:
> This fixes the initialization of the PHY TX control words in
> shared memory. These control words are used for management frames
> like beacons.

This actually breaks beacons, if I don't use this it sends them,
otherwise it only gets PHY TX errors for beacons.

johannes

--=-SV+0qPBQl728m1MUvhk6
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR/dcd6Vg1VMiehFYAQIWqRAAvBH+refhpFCQwZsBtAGqR6cg2Aa0NS1k
Cvg0OfmZB+hpV5hS+89gGuzqZ2czGEyo+rmVIaFTuse7bV/e+y5PQulB194n2WeD
Ua/fSgPqtWIYVZqUHPnhhPCjNGRiT+GQN1QNcJqnspI9zQOWyZD9I0oYe+Ne8s1P
IgA5i7+5lvopR8DS/UaXqYqVONh6H5YEq7vt+D/spDkd2CH8KL1emzsQ2zf7oLY0
XZHwUP2NEhCKGijLUmU2xr17SfE7DZWkG3P4uWShFKkQwVNZJoTGuhdZnkE91cSe
Gjedx5uW5ZlHTjB1yTARUy2IysMkwyy2gU4fIKM8WzUhehRb728W9BKlt+By0SRF
OqkbPrDf2eYWcQgoHSUwqIBXGPGpJoiFL77Z5Gy+/5rTGOkesIYANs5RIQRbHM7w
WTSgLmAL3E/rDjv98HIJQjaMXkVXDtf8lWHkBH4uF4imae2xp8VB2jkwtyltagZy
8nmtumJMibPxksWHzXy59deyjGJnWcqyakrsmaz8fs810nwsV2QpgR9mWXoevK5j
7c/IW/c7aQ1jzZclzAJGxm3HblRNZQmfeTTvKZhhW2cIidTIZI/FiY1rBIlH1S7z
52D5M0Sl4C36wB7MNrlDrfUukMaEah57lDLaKcjvjeks2+umozM+DqUZ3UGeNb2K
tmnQpXOIy40=
=+nyo
-----END PGP SIGNATURE-----

--=-SV+0qPBQl728m1MUvhk6--

