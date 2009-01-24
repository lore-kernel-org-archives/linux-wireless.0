Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:39668 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753794AbZAXORU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Jan 2009 09:17:20 -0500
Subject: Re: [PATCH] ath9k: Read and write the TSF via debugfs
From: Johannes Berg <johannes@sipsolutions.net>
To: Alina Friedrichsen <x-alina@gmx.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20090123222602.50450@gmx.net> (sfid-20090123_232635_135057_A4C5AB03)
References: <20090123044421.270720@gmx.net>
	 (sfid-20090123_054428_080982_2340614F) <1232748841.3977.10.camel@johannes.local>
	 <20090123222602.50450@gmx.net> (sfid-20090123_232635_135057_A4C5AB03)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-jF3i9x+QHwt2pOhpyzGK"
Date: Sat, 24 Jan 2009 15:17:16 +0100
Message-Id: <1232806636.4036.8.camel@johannes.local> (sfid-20090124_151723_166893_F0F8D135)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-jF3i9x+QHwt2pOhpyzGK
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-01-23 at 23:26 +0100, Alina Friedrichsen wrote:
> Hi Johannes!
>=20
> > Ok, read I can understand, but write??
>=20
> I need to write it to test if the BSSID merge to the older IBSS
> network works correctly.=20
>=20
> I don't want to run around the block to test it. ;)

Fine, but that definitely doesn't need to have support in mac80211, I
don't really want to see debug-only hooks that people will be left
wondering about.

johannes

--=-jF3i9x+QHwt2pOhpyzGK
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJeyLpAAoJEKVg1VMiehFYuVsP/3JmryQHy0KsywJSUrLQS8BR
oW2839CcQlCTNaBd4BzBIBZq2837AlNaZPDC0072p61N9o3JOg076SX8PS2FaRgw
L3h/SWAniHg6/YWRoWl7mXaKsrSBRzRuIGM8M++06Z1JwVajB+2pVwbDenz7Hj2Z
O+S6WnpWqugJoi4aG8q8dT3EiPzXkHJ45BUdUljPpszzo4zja5SyahwPmgTXiS0I
ec1NkLOOMJFT7uIVLOXSaG31D9XgyCs51giZl9s/NjRN3XSkdiWLMybbIWiYt/lS
FWMxGqIFH/25h7Enu4vfO4Ll+gPrMi25c6zYTYSbPvqtcp9Tr0IiOvqbhIymvgmG
+R+EGOEUOoCxsN9+KrpCvr8Y+Hj3OpdKqmWyh/70ig9+HFtZQNZaUsRL7vRlAvVY
4Vi3q14y/juISK4C+xXgZgzVIBzhAOFjb2OAvcplPGRF4FkB2ZIvrMvWp9QY6OWb
nFE5S5MKIjh0ylJ/tRprzlc1AmlScrfr3mrZKyVMYrr9vo/ImORHULXOxTu+wwZ3
qTWScxiKo7gBw5IaNrtPJ7wXf3eaLTxLxqqEJz5ww8LYMjZDSO37c3BK0cjaQb1e
lJx3TSdzqhi4zoXAVGCUFjVyV/w8nccPF+3/7tm6S7eCmeJEr78QqBpYfzU7yaxo
0WZ5H8UMEAM0O3f1vblH
=aoDG
-----END PGP SIGNATURE-----

--=-jF3i9x+QHwt2pOhpyzGK--

