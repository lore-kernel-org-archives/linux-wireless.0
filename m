Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49335 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752764Ab0BIIAx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Feb 2010 03:00:53 -0500
Subject: Re: [PATCH 2/2] mac80211: give warning if building w/out rate ctrl
 algorithm
From: Johannes Berg <johannes@sipsolutions.net>
To: Andres Salomon <dilinger@collabora.co.uk>
Cc: linux-wireless@vger.kernel.org, akpm@linux-foundation.org
In-Reply-To: <20100208120735.4b41a4a6@mycelium.queued.net>
References: <20100207214837.027dfd3d@mycelium.queued.net>
	 <1265619993.3783.0.camel@johannes.berg>
	 <20100208120735.4b41a4a6@mycelium.queued.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-QG8NeqvtcZidKI45Tld8"
Date: Tue, 09 Feb 2010 09:00:49 +0100
Message-ID: <1265702449.3783.20.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-QG8NeqvtcZidKI45Tld8
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2010-02-08 at 12:07 -0500, Andres Salomon wrote:

> > > +comment "mac80211 will not work properly w/out rate control
> > > algorithm"
> > > +	depends on MAC80211_HAS_RC=3Dn
> >=20
> > Except that isn't true for hardware that doesn't require an algorithm,
> > or drivers that provide it themselves, like iwlagn or ath9k. I would
> > prefer it to be worded accordingly.
> >=20
>=20
> Noted.  I was wondering if there were any.
>=20
> How about having drivers that need them depend upon MAC80211_HAS_RC or
> some such, and having the text say something like "most drivers require
> rate control"?

I guess that might make sense in that if you have any driver that needs
it, it'd remind you to select one. I'd be happy with that if you want to
do it, but that means touching all the driver Kconfig. Alternatively,
I'd just reword the warning to include that possibility.

johannes

--=-QG8NeqvtcZidKI45Tld8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLcRYtAAoJEODzc/N7+QmaMzIP/3R2JKYM5TFuF2RdiGeroNan
FuEKrMD7TF/EZJvmg3VDtaZnueFiyUO8eRniz4okuT2A4MSpC2UWxcUFKdfYfIz2
U2bKXCVz/m8rVdbUkaOur3BQ4QjJD5r5sy8vFC5OYqorDc+KDhpU5Rf/lokAkYA3
vwSBPlWaCRA4aAL2JaFaOXVzZ4GSq4KyvjYah8O4P8+7q8y2ELBHUkLkCGrqj/ox
gYg8XVppMIzxD9XRxVIsjmVOZGSTcg7hc8ZVluxeZshAA9eYAeKkz4KtkVPmUY37
Kvl9tVYWKX9TwGhOQL28igGycZ7JRuQnQJH+SsF8k9evoEd7bmQxSFOTfIZtB1sa
McwjSwKd+ZKAOI1/PCwhHUooPXqMOVjYbnO3iQBhUas2YDfVI1W6TUMMv6WAfL6S
vUaJySl8Yp3XN/DxSQ6I3VR7tAubA/V2UvFbkQ4XFAyusIbsgU/iVA9fumQxthpm
Q7CkhUsknhTV+Hi72qeRcjF5OUbwIEbZCLWmqhaIUppOukppZajHyVyxIj6td8QL
xNKl6tj/o+UpZigNw9FkPqZfo1TP+Df2QfienvlT1QEcPGOI4SW6ZV6tbPEswS6f
IQ/iBdKbVrq6WNtLiqlvikD30fDWDN9xrCFoRQi6zLbiBubMNKlqOwcWGIQ5QM3f
bMwYaz7mkWpCf+6dM7Vl
=6Zz3
-----END PGP SIGNATURE-----

--=-QG8NeqvtcZidKI45Tld8--

