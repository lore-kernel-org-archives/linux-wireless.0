Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:55588 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756175AbYJMXhc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Oct 2008 19:37:32 -0400
Subject: Re: [RFC/RFT] p54: Fix for big-endian architecture
From: Johannes Berg <johannes@sipsolutions.net>
To: Christian Lamparter <chunkeey@web.de>
Cc: Pavel Roskin <proski@gnu.org>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <200810140131.38439.chunkeey@web.de> (sfid-20081014_012807_857638_E68FA116)
References: <48EE20FB.4060700@lwfinger.net> <1223938526.27118.6.camel@dv>
	 <1223939151.27769.3.camel@dv>  <200810140131.38439.chunkeey@web.de>
	 (sfid-20081014_012807_857638_E68FA116)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-sAgoBkxfMxGEcmKzaBMu"
Date: Tue, 14 Oct 2008 01:36:56 +0200
Message-Id: <1223941016.10113.12.camel@johannes.berg> (sfid-20081014_013735_727252_715DDD87)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-sAgoBkxfMxGEcmKzaBMu
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-10-14 at 01:31 +0200, Christian Lamparter wrote:

> hmm, strange...
> so dev->conf.channel->band =3D 1 (=3D> IEEE80211_BAND_2GHZ)

Ummm, no, 0 is 2 GHz, 1 is 5 GHz.

johannes

--=-sAgoBkxfMxGEcmKzaBMu
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI89uUAAoJEKVg1VMiehFY2g0P/29PNu1LS89WBEU+3R+5bfo9
+qbQrIirHB97sQRQIhpuWb/nSTizVa1m3N0+68tNobZRyCKDxUESnhngtRCguml0
LTYisyizvtlpVitin6RfdsUracgeHHA+GTkjSmCjEvcDV5yPBPMnWcHIKieGMxRf
v9jZ2Qhg8TPrMglT0TpQVNr8uX1/Fo6jYjGoOKkDIALYAUnBqQ2DZs63gyJUB36r
yhDEm0YmsCf89EAZroLszXi1R1GWYeC4xEuG8oGLVkp0xsqbAFN2tjQOI/SbGUKf
i7TrDruMi13wL6y3XKe1Uyp5e9hWI1Umg5X/q5SgASo+DKI3vCMt20BdagmERcp9
13cEML70GjeAG9Wn26p5oqGCqR2BNMRCOirg/tbVG4wwm/abCsc4YOBBGs3Yb/7h
ibJziF+qEToGjM+iT3qQDzJMFu9yPBIkP7J3UaR8Wu98OxtIvjridxB8pCJkmeS8
N/RsDHMDcNSifs/yw5opX1lOS/sz7ez12ONWVogRQ/Q2iVB9aMrZ5shlrPrea6O3
6pWA3vK5xdchUbdxWwqTSYI8Qg/7JKFvwOgwE0qkQ2DfRa5FHy9+CDjyX10dErdJ
fEPg4QJq2Q8sLdRFbeiFxRcb69vuLABj5QNcRtOrVR/F9HS5yHurXu0Ypea08Rae
SReWsrRfckXO6Z5JVRyp
=e/m+
-----END PGP SIGNATURE-----

--=-sAgoBkxfMxGEcmKzaBMu--

