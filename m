Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:46304 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751639AbYHSOAP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Aug 2008 10:00:15 -0400
Subject: Re: [PATCH] Use only precedence level of DSCP field for frame
	classification
From: Johannes Berg <johannes@sipsolutions.net>
To: Daniel Wagner <wagi@monom.org>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20080819134435.GB11660@notlob.celestrius.com>
References: <48AA887D.5090307@monom.org>
	 <ee101a74bd16a9467853b5ac049c5da4.squirrel@secure.sipsolutions.net>
	 <48AA8E2C.4060303@monom.org> <48AAAD30.2080207@monom.org>
	 <48AAB70A.4090402@monom.org> <20080819134435.GB11660@notlob.celestrius.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-qCMAPG3xYeWh3oywZECz"
Date: Tue, 19 Aug 2008 15:59:38 +0200
Message-Id: <1219154378.3476.6.camel@johannes.berg> (sfid-20080819_160019_636055_5F26AB0D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-qCMAPG3xYeWh3oywZECz
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-08-19 at 15:44 +0200, Daniel Wagner wrote:
> Bit 4-5 of DSCP should not be considered by classify_d1. The
> 802.11 QoS Priority field is only depending on the precedence level.

Mind explaining a bit more? I don't even know what DSCP really is, any
good reference?

johannes

--=-qCMAPG3xYeWh3oywZECz
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIqtHGAAoJEKVg1VMiehFYeE8QAIhIgKYcJyXylvFFr5oknkjV
J+nfdHeTPs0k1J0p6fFZezA8/AIWTzzlZ7S2jw9FztH6A3n4o46uvqyNfKCYS5Ui
vXsodvwlt1q1Vzgwt86HaX1LTmLnR04Y517EfD2tt0vfwJNHrP0NK6YTk0fYGRRd
+C9Q5OSZYtyTkIFghY7smDnckMcjQVpR/qgA1WPnXWZzfFvPKlWY+2FfIxXqSRsw
UWBzNzavmK8fEBx3YRVgvGmV8VIV7BLXqnsVuZLAWEUY+juwcML/7SHKVhvp7PHC
WRrxdIxPmnyZG2hayxhtoihOdhk9zzmJ9HBFlaKPx1EdMYDdcpNpk0TBOvlGKPcK
zVRnOYfqKXnCnCAkSjHgFP1iteyh3HJKbXb40cfvKF3QoAJ8iaWqYa55tEUv9MKU
1RQ/ZHcD1d7UN9q4hBFwTo4yqR1npT+Cud4TYAEmJsLH9jJpDGM3iUPCEcw7eqVs
fuZ3g5mDtTZ5R7jUkPx7FFAtR2JE9MJeYDQSBuoJPIEB0gTVHhhzN5+v70utQdcx
F5DAWJwi+bmgtl9od3cu4w58KiDnSLKkKGoXrP6ptlZkbW4eVT9OAUmZOfNavI+1
/82Zxm0gvqSVFaSzI5b4VD40/gx0guvTRqUNYSl7EmetrpkSIE2kcXjzA43IqNd5
kdjypWmdq6hu9BZWGnvC
=OFjF
-----END PGP SIGNATURE-----

--=-qCMAPG3xYeWh3oywZECz--

