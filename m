Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:33651 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344AbYCKQSk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Mar 2008 12:18:40 -0400
Subject: Re: [PATCH] PS3: gelic: ignore scan info from zero SSID beacons
From: Johannes Berg <johannes@sipsolutions.net>
To: Masakazu Mokuno <mokuno@sm.sony.co.jp>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, cbe-oss-dev@ozlabs.org,
	Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
	Stefan Assmann <sassmann@suse.de>,
	Dan Williams <dcbw@redhat.com>
In-Reply-To: <20080311130630.0AF0.40F06B3A@sm.sony.co.jp> (sfid-20080311_051712_368863_0E0A4ECC)
References: <20080311130630.0AF0.40F06B3A@sm.sony.co.jp>
	 (sfid-20080311_051712_368863_0E0A4ECC)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-eU2wxxI7625/rrKjIUUX"
Date: Tue, 11 Mar 2008 17:18:07 +0100
Message-Id: <1205252287.6387.54.camel@johannes.berg> (sfid-20080311_161843_840500_3AA6F316)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-eU2wxxI7625/rrKjIUUX
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Tue, 2008-03-11 at 13:15 +0900, Masakazu Mokuno wrote:
> Some implementations of the hidden SSID APs emit beacons which have the z=
ero
> length SSID information element instead of SSID padded by null (\0) chara=
cters.
> If the firmware of the PS3 wireless hardware meets these beacons, it aban=
dons parsing
> IEs. Thus guest OSes get the invalid scan information for the AP.
>=20
> To work around this, ignore these scan informations from the list.

I'm not sure this is a good idea. Is there any way to get at decent
information from those beacons?

johannes

--=-eU2wxxI7625/rrKjIUUX
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR9awvqVg1VMiehFYAQKsEQ//fEVW1wIlEBFadkNBtLz9OhuyCC4Yk/oj
+JrkqKztULyFzbnhb0A5L0t8lwEtzPy34JCp9Glt1tGqg7cfHmMhB+2KLKHR8iMN
UiNtXVJ0/2wW63kKlfYKoTUb7i1B1oLFqFvjHKY4wmU5jdLByRfDxLW7JcCJaNr1
b/0N+T+A/gN6YV8eZGkat9wIbFeWBAwWksFr+AJsQCbCG6P0EeiZ7FivZoKUxak0
ndXMRoSjaT93CdL3ndM11XzvCp/oaajxWePfG1Dc29HIQitqWw+9XT93mZBgZ32I
L7zP/kefqRc5BccYz+0PBCOMKMVtdV8Vu7JnQcaMGwfKmizHGIAkf2/bTr0HI/1A
kTwdDg9g9c5nqEf1UJCv/FMsFEOt0HYIoeidxbGJRNChKHhtBIUa7RSAgTM0WEnf
xImjkqzJXoBv5/2s/YeSU0VLgWErsIbPrge239z25dTKNj4YCHlPyDnqBYtobECv
9MB0DQhMLvAg4Pa+CBkJg6gWVp5xHTaAgxIP0zprtLehnPU2yxpOoYhqLasTJhd5
R/XJfok1xZX/8049k73rWDZJl3Ol+gOVEvq1DMHddqgoFEJWvNYZ5L9mvrfaKi08
+8KxsAkeOWqcm5K3wLE4lTe1Dw7/SahRPeSB/yFgqKrll+lNCeHByE7M+4ZK/gte
GoeJHbQ9iVE=
=wdJj
-----END PGP SIGNATURE-----

--=-eU2wxxI7625/rrKjIUUX--

