Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:51420 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750755Ab3ARIEF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jan 2013 03:04:05 -0500
Message-ID: <1358496170.6252.67.camel@cumari.coelho.fi> (sfid-20130118_090409_465710_6C2C5C70)
Subject: Re: pull request: TI wireless drivers 2013-01-17 (for 3.9)
From: Luciano Coelho <coelho@ti.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Date: Fri, 18 Jan 2013 10:02:50 +0200
In-Reply-To: <1358432608.6252.55.camel@cumari.coelho.fi>
References: <1358432608.6252.55.camel@cumari.coelho.fi>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="=-sGl0esuw/+zaFSpY99C0"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--=-sGl0esuw/+zaFSpY99C0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2013-01-17 at 16:23 +0200, Luciano Coelho wrote:
> Hi John,
>=20
> Lots of bugfixes and improvements in our TI wireless drivers,
> including support for multi-channel.  Intended for 3.9.
>=20
> There is a lot of patches.  This is because I couldn't do integration
> for a while and then we missed the 3.8 window.
>=20
> Please let me know if you have any problems with it!

John, please ignore this pull request.  I made a small mistake (left a
__devexit) when I merged stuff.  I'll send v2 in a minute.

Sorry for the trouble!

--
Luca.

--=-sGl0esuw/+zaFSpY99C0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQ+QGqAAoJEKFHnKIaPMX6U7YP/i8/igO3/V6TdkGk/NUFoOVQ
+HpHBdXczmXBan6a47d3Ph69is9aqOMJG91eCTa7nm+xHU3bL8A74hfbFCMfnzz8
v71RnTuH9nnuhKB3ZI+Y31rlxaKJx8YNPKGQm2haid7G0m8eJnhkk10NECIwrC9i
jRlSIm4WYv6s2dJMUqltSJapjradgBv00dopte00DUEEaXku4rcwokVbAAMWLnEa
5C2gduQdv2uFHF3OjyjK6smVrb/H8qrOc9I7+Ij/5ACWDcA8GuHj9sVAVmXYCBZs
26FYzkFf/yl9chqrVzmRsWEAG+HUPh1q2LAagECbr22PBrq1gL0d57pYiGVDljWw
IVRVEEdam1hwbmppv5VfrF5dcy51+0GLzwIxuoZ5WFZD34eaJ/q8+lh9T7CQGu5B
W8wa0qSPOhPmRJcxhslsDxDvp8LBnRxPSIB+AVT5V7Bco5DYbYkge0wAVzA71GXh
hcRmvJLumToEDBCSh2WnW0iQfx9rVkFQEjs2hoBtxKJrguOgaKjaAMDiBfVUqRg8
2Uukptxj1W3kVmLeeQLc5oGgBGtGg/cTBaa6fkwvCUS3P5tfSHgLx475FGnTmSTq
yviCGFOMkPsKsCaBuOfTqFrIQWT3H0F68M/7KhYDppUMuWGpuu+Pf+R5/HfnFcAM
bVY6Pj9R9QnQlIMwaRsY
=lgAL
-----END PGP SIGNATURE-----

--=-sGl0esuw/+zaFSpY99C0--
