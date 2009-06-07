Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:54135 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752312AbZFGRUU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Jun 2009 13:20:20 -0400
Subject: Re: [PATCH] b43/legacy: port to cfg80211 rfkill
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Michael Buesch <mb@bu3sch.de>
In-Reply-To: <4A2BB985.4020403@lwfinger.net>
References: <1244311473.17485.20.camel@johannes.local>
	 <4A2BB985.4020403@lwfinger.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-LrCwRz2lr1LWRGAtoI0u"
Date: Sun, 07 Jun 2009 19:20:12 +0200
Message-Id: <1244395212.12956.4.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-LrCwRz2lr1LWRGAtoI0u
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2009-06-07 at 07:58 -0500, Larry Finger wrote:

> > This is quite heavyweight and can probably be improved by not bringing
> > up the PHY, radio, etc. just to poll the bit. We probably don't even
> > need firmware, just MMIO accesses, but I can't test anything like that
> > and this should work.
> >=20
> > Please don't merge before anyone has tested it at least once though :)
>=20
> This one works, but so does the lightweight method proposed by
> Michael. It saves both time and power. With your permission, I would
> like to submit that one as V4 of the RFC/RFT (V2 of the patch).

Certainly, please do, I appreciate it. I no longer have any devices
easily available for testing and was pretty certain this version would
work.

johannes

--=-LrCwRz2lr1LWRGAtoI0u
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKK/bJAAoJEODzc/N7+QmaTcQQAJFQhrKZOxAsPpQ9CVvtNTNQ
6mS8k1avHQAyXCsvHhqHX7NWfC2KbqQCU14q8Dtk6JvR4gvsdnipfS3/jS4bB+SI
g2EKF+hwX82xT9nQzUkiZZ97m0suWD/GoQAhTbiznhDLqNWw/gf5fCaog/G1iBvl
QlzjXbl2FyGkjjgDpQsvjEfpFES/h5nDbV6ziPu7fBvVdlD1X5h5CDk+itlXW4hT
PulNTDh7j9mBaHP+NKr8WhmlRVfDVdRO9inckmZEPX6/IL9Ybn4ospO/2DslpYC2
neiUPgjVO0KKOooLS7rltdYfshgNT9UCB0h8Im5vnWpBWbe9IepV+YJqrLognGr4
skUXpsiemTteLXhDSAUAuvf9jfoaM1kBHrazsel5xDJ0k2dB1O9WDcMC3PuHL5Ai
mUtFu/f5FHfBabLNtoLIt+pQhszYR4am3W9z+MxPPunAlkSIha1ZrcLFYSY8FWIV
VAe9E21npTa2tjpNRHqif5L+z79E8mChVvuAjTxRhBhiTeI7O/RFuNY/wtDbOWHG
MlkF/EsizTZXL5eLYGpF7ZuUonvoo6t9lwe6IeGGsWEjLDNyNq2Hnwk4rYmuQNwB
0yJzQJ+x/0A40SJLuz6Iv9arlJmckXyle8JWff1qQyN8XvpDTa4PQ3XOMl8T2b+/
uSAFsx1cQAVxiIv74xYQ
=5nkE
-----END PGP SIGNATURE-----

--=-LrCwRz2lr1LWRGAtoI0u--

