Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:38458 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266AbYITUvt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Sep 2008 16:51:49 -0400
Subject: Re: [PATCH] b43: Fix Bluetooth coexistence SPROM coding error for
	Motorola 7010 variant of BCM4306
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	John W Linville <linville@tuxdriver.com>,
	bbullins@triad.rr.com, bcm43xx-dev@lists.berlios.de,
	linux-wireless@vger.kernel.org
In-Reply-To: <200809201744.55571.mb@bu3sch.de> (sfid-20080920_174550_869772_E28C99C2)
References: <48d401da.Q+F4HRESoxeIVa3r%Larry.Finger@lwfinger.net>
	 <200809201744.55571.mb@bu3sch.de> (sfid-20080920_174550_869772_E28C99C2)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-/at1znZOQ7ksl++lSPqP"
Date: Sat, 20 Sep 2008 22:51:35 +0200
Message-Id: <1221943895.3023.1.camel@johannes.berg> (sfid-20080920_225155_420426_63F4995C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-/at1znZOQ7ksl++lSPqP
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2008-09-20 at 17:44 +0200, Michael Buesch wrote:
> On Friday 19 September 2008 21:47:38 Larry Finger wrote:
> > An additional BCM4306 has been found with the Bluetooth coexistence
> > SPROM coding error.

Does anyone actually make laptops that use these bluetooth coexistence
pins? All CSR bluetooth chips do it automatically I'm told, maybe we
should just kill them completely.

johannes

--=-/at1znZOQ7ksl++lSPqP
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI1WJUAAoJEKVg1VMiehFYkAEQAI4BZmff2A6tKJtP9e9dcfeW
B+PWWiMiyIE6kr3KXy/u05tqPAU+nYedTAgFTnTBY5ySZ3jijc2qdMeYFjXuFoxA
SpPviia9NNiJkVq1NiEF3MDe09cyG/VAHbmtJ2d67jD+Im4qYc71bZRrV/vIpMs7
+GOfZpIHjZce5wC0dMQMwNqsMjYiDOfSY6sFUNnG52IQaaUjkMqEpsxuNfDRiJe3
fQfLCx832dZFrdq34Wny2xkYZK69oQcBh0MUEk6Z8NNHaJn1mUiZqgDeFrB7KiTf
I0a5mUYn0vp65m8+uNf3FLYkGfI2rDoCLWYQEn7I+NeDObffVdyuivLGGhi6+ePU
eaMK5BOugtWXqWhrGSP3YmQeLkeLPFhd0RYKZPf1avUkzSgN/eapzhTL07J7qlFW
womP1e8X0u05gE1FZjoERc0WZeNMLkjlN5Ric21TEDzKeurB/YCT8LbBYb+VPG6s
6fE4eYNJH+EYl8PCJ6Z+tCRGDINnlQAYa7lnk4ThNKlCs4h6eOwx+zw3q8ZnHhjw
Ua3EgjNihP8UVkjJdXnLMtJ7o5U6ZUL6AZLzTfSqWwbYc99cP4c2Wtsn6vT15vbv
PpyoPWz7Gi22lO+y36LGGjXSwq3JCm9YSoHnlPNqXeqvS5y+YC3M4Kx0KjxjQDUI
VcceWx+efziyyOl2TLhA
=AQyb
-----END PGP SIGNATURE-----

--=-/at1znZOQ7ksl++lSPqP--

