Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:41248 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758564AbbCDUWh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Mar 2015 15:22:37 -0500
Date: Wed, 4 Mar 2015 15:22:35 -0500
From: Mike Frysinger <vapier@gentoo.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH crda 2/4] allow people to turn off -Werror
Message-ID: <20150304202235.GB7320@vapier> (sfid-20150304_212246_171902_75D6A917)
References: <1425498714-8654-1-git-send-email-vapier@gentoo.org>
 <1425498714-8654-2-git-send-email-vapier@gentoo.org>
 <1425498807.1810.14.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="4bRzO86E/ozDv8r1"
In-Reply-To: <1425498807.1810.14.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--4bRzO86E/ozDv8r1
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 04 Mar 2015 20:53, Johannes Berg wrote:
> On Wed, 2015-03-04 at 14:51 -0500, Mike Frysinger wrote:
> > From: Mike Frysinger <vapier@chromium.org>
> >=20
> > Forcing -Werror at build time easily breaks across compiler settings,
> > compiler versions, architectures, C libraries, etc...  Add a knob so
> > distro peeps can turn it off.
>=20
> > +WERROR =3D -Werror
>=20
> Doesn't that need ?=3D ?

yes, if you wanted to support:
	WERROR=3D make

but the expectation is that you'd do:
	make WERROR=3D

in which case this code is working as i intended.  if the maintainers want =
to=20
use ?=3D then it doesn't matter to me.
-mike

--4bRzO86E/ozDv8r1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJU92mLAAoJEEFjO5/oN/WBwCEP/1jYg/VWnwCYWBG5FFka4GZn
Dczg1rjjOsuryfS7Xra8QQchmD60K7IJHPJLfJ9/R1snTBLG2qUdLYy6VXrz4+sv
BQrzTymr3KtWSt/66xPTDBV/caS1g419TMHOIQX43f7JakUchtyKWDCeq6EZ12AV
6sjLMGoCWMWL9zuznX1wXWmdJWPD4Bou8oZboIS0bvKPs/WIyCvhGTjkOeITLbwG
34evNryU6fCM5Tgo8cPzAOkQ3BAQCWz8hyBdbX7FhsrABQ4GV9i6yPu4AtAOcrbz
cINbbXneEx8SpoIzsnbtscQ0+eMFci+6OFxnK4EW7R7gh2htOAPOL77K/WYw+GhN
PJyjysuFgS3io1MbL+lTLXFp5F7flHXPz1KPILnJhKHuAbRx2SZzTlrGr7iT6Q5B
dAS2YRg4dMHN1rF5DW/wCTowD1gcYBglRY7Pn2RHFhKULJD8xmegpYD3pjo2eLi0
yF0rR5ej7mzsNyollt5Y94u3VFSqRQEdleeQFjOQcWY6o4j7uXATcdh1tVDRAIX8
hUtNxTHjpuLTso0cs1yY80ECcdClIwbr/uZJ0WeadCkZtKGsCgxRCpTN5y208ktx
lUa/YoMuxQ1tSXmQU5ZwhbE2M8onW07jpUvlP2LUG7/Bkj3IoJNvzhF4l3vxf34J
zHrNIQ95SMeQPuVbxgHe
=Dw9f
-----END PGP SIGNATURE-----

--4bRzO86E/ozDv8r1--
