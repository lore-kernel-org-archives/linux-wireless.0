Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:50912 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753972AbYKTR77 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Nov 2008 12:59:59 -0500
Subject: Re: Fwd: p54: testing AP mode: cannot switch to master mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: linux-wireless@vger.kernel.org,
	Stefan Steuerwald <salsasepp@googlemail.com>
In-Reply-To: <200811201537.19047.hs4233@mail.mn-solutions.de>
References: <f76a32050811190306s6a86f46dwc245200069ff8a82@mail.gmail.com>
	 <f76a32050811200050u48bc150en34e94c7671672ae6@mail.gmail.com>
	 <f76a32050811200544p3c647cb3t392025feef02c8f9@mail.gmail.com>
	 <200811201537.19047.hs4233@mail.mn-solutions.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-+o9WqbNMmkaHXYFXyU70"
Date: Thu, 20 Nov 2008 18:59:54 +0100
Message-Id: <1227203994.3766.24.camel@johannes.berg> (sfid-20081120_190002_736689_4D8E33F3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-+o9WqbNMmkaHXYFXyU70
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-11-20 at 15:37 +0100, Holger Schurig wrote:

> Just make a trace with beacons towards your mac80211 based AP and=20
> one trace towards another access points and compare the beacon.

No need to compare; you just need to check whether the AID bit is
properly set in the TIM. I think p54 may have problems with that, in
fact.

johannes

--=-+o9WqbNMmkaHXYFXyU70
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJJaWXAAoJEKVg1VMiehFYjRAP/3rLiy2sJT9zBXr5OfM2Y6qf
o5yeRQJgtGqCaSEyRFp2HDKVt/B/lWkkZg4K5BON8SrgsBASAsYFjSRfzdeFXKZD
j0xFh3cyJpMz3F4O1TvGZd9HqhCvrd9bv9gL51pl6rM+gruW1M7DN5pDrxOeWQoz
/eklureZ49u2dmjmN/zsXmR0yuPC5/9YNPx2q4VMFDXpu2K/XrNM3H/mSIPr8SGD
d6q9Ahk3dxbYIhyBZxZNilJxuOu74qoEkx/qPQf7DQbPcAgPyxFm1HLv5pUavZ0V
RJ75ZNcDVUbNOBtYnUxglU971QdzfT+qMc4k0kexQ/1iFQ4eJsoXEUwqAUWv3Je7
umpRDXA0BuIb+8YYE/Amf1bPfpF5hzWslVl5rofz+kQyX9UeGQZBuFBYi8Vox61L
0w6zQEUP2ERp6gEquGi4b1SRv+bB9aqEpTeQsbaSHnrL4HOx63GWVKGw6td59Bpk
yzX1DheYlNM/BKlaWI3HvAZaZBl9srv3ZarjOOLqPWyoFlRsgEtk+NTjHlVbQLTc
UIx4mHRANy5Y0uK74XncBt6UO5JEuV7MIirURedIAHhWr2gq7G52tzl1nWAEzGUP
9B9sGhS62VUjRm6/kWzWLPwVYDB5MOUENLqU7X5KR+HSF/55jkJsJwFPPFK0TDu2
chqjYzDccTOkUqzPEvp6
=OLxS
-----END PGP SIGNATURE-----

--=-+o9WqbNMmkaHXYFXyU70--

