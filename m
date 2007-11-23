Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:38364 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752495AbXKWUXS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Nov 2007 15:23:18 -0500
Subject: Re: mac80211 regression: doesn't associate automatically
From: Johannes Berg <johannes@sipsolutions.net>
To: Will Dyson <will.dyson@gmail.com>
Cc: Holger Schurig <hs4233@mail.mn-solutions.de>,
	linux-wireless@vger.kernel.org
In-Reply-To: <8e6f94720711231134t66bc0bcbt9651297221cca56b@mail.gmail.com> (sfid-20071123_193420_868158_0ADA9C2F)
References: <200711220912.10452.hs4233@mail.mn-solutions.de>
	 <200711221605.55506.hs4233@mail.mn-solutions.de>
	 <1195746110.4149.23.camel@johannes.berg>
	 <200711221719.40412.hs4233@mail.mn-solutions.de>
	 <8e6f94720711221232p16b90daaya5fe3550729b49c8@mail.gmail.com>
	 <1195822116.4149.116.camel@johannes.berg>
	 <8e6f94720711231134t66bc0bcbt9651297221cca56b@mail.gmail.com>
	 (sfid-20071123_193420_868158_0ADA9C2F)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-mOy7JscLip075XDHz1vy"
Date: Fri, 23 Nov 2007 21:22:19 +0100
Message-Id: <1195849339.4149.153.camel@johannes.berg> (sfid-20071123_202321_881432_2EE50758)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-mOy7JscLip075XDHz1vy
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Fri, 2007-11-23 at 14:34 -0500, Will Dyson wrote:
> On Nov 23, 2007 7:48 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
>=20
> > I don't think this can work because when say wpa_supplicant changes the
> > key the last thing we want is to have that cause a reconsideration of
> > which AP we're associated with. Or even a disassoc/reassoc cycle.
>=20
> Ah, yes dynamic WEP (or does wpa also go through those ioctls?). Thanks.

Yup, WPA does too.

johannes

--=-mOy7JscLip075XDHz1vy
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR0c2eqVg1VMiehFYAQIQVxAAloWvqWFBBeKYSFKg1aMajCZmkPzxM+Qj
AO51ZdIu1ONL6dBdt043+YxF2KmTkAKbEz+Zcx1JFvLiPNLfrTiK/T6n5pnA3JfE
Pme2sFKzYZyeDqB0EL4fb9HOzupO3zK6JFDoZi/NipfPUDLI+qtPeGZPPCoxLikI
0f8IyYSs//AFrV7t2FA1BCGUvacyZsMIVrqrIrT+ny9oDZLw4Iz/fXMDRFgRQn7Z
/P4xqr/+IdE30BaKKpoWsbnwGFbZvfbpf/3j9pNyfc1U6V0Ja9/1vpiuoagqwqAg
uI9uoTwepk3sJrJcECxboesmHRjoF9ZtKsGkPmZHda65qr71htL2A33i2G9qWH0Z
CayUjrQzBF8uW9gImBanbh/V0EDdg01dcz0qDzjiqbTefWcDhbyKpY+QNcUrZWSo
eLoyr6IIdhTKgXBvk0lOC+nUGPcYpbTNTgadVjQQOc/lmCKvds9eDimf11vYD2cO
GYgG1FBioCfEh+4UCPWu++H14gYES5KQIO02oA4SbjRii5H2rlaxPHY652g0O+QF
OJ4ORorHAd8hHWp7973hp9T9UG6ujTcp7/ZbiCp8YHx7HOA+XoxKBMMEbYykYA13
BKxXGn+xWcd2sDUGvForK3MXUlnAj93WBZyguPZQZvGZQlZYW29YWJldms2GMPAL
bz1Nnt753pI=
=ctsK
-----END PGP SIGNATURE-----

--=-mOy7JscLip075XDHz1vy--

