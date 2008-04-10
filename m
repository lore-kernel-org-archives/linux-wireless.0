Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:44291 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756600AbYDJOu0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Apr 2008 10:50:26 -0400
Subject: Re: mac80211 ifup & ifdown
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <200804100017.23359.IvDoorn@gmail.com> (sfid-20080409_231437_772669_7AA983E7)
References: <200804100017.23359.IvDoorn@gmail.com>
	 (sfid-20080409_231437_772669_7AA983E7)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ELxutk0kWeee+h/zkNTF"
Date: Thu, 10 Apr 2008 16:50:11 +0200
Message-Id: <1207839011.19080.11.camel@johannes.berg> (sfid-20080410_155034_458693_87FE78B1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ELxutk0kWeee+h/zkNTF
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> I think I recently saw some discussion about mac80211 having a bug
> when the interface was brought down and back up again which would
> leave mac80211 & driver in a state from which it could no longer be
> able to associate again.
>=20
> I can't find the particular email again, but was this issue indeed a bug
> with mac80211? And if so, is that bug present in 2.6.25 or only in
> wireless-testing?

The only thing I can remember is that it didn't used to automatically
re-associate which should be in now.

johannes

--=-ELxutk0kWeee+h/zkNTF
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR/4pIaVg1VMiehFYAQKvGBAAqywQjIDaU+PTyI7anBqMuF3mBuFsMtW+
MDDurqEws1ibeGasHdjSs0QHjIVMUJG4NhSR0oUEh68gDSUy2mXJyJ7EDi26oOxR
5d//tjnOzNr61VSKr/pIm52MqwDRLmy0Lrd6phw+fUtrWtOaIH2dte6JziRSR5Ax
XsrY97Pz3r0CPMcAH70RdVMkBNf+9yJYHTJiGXPdh2cNzyup4evbpGBSv6+7bxA7
reeQwPG6dUC3n82xORA2pyAE07mCnjyc5zvyQN4HCwDFxf8oW32iqZtHcTyJZ0Py
x8Bk8Z6YrJwiF6WdRmkCgo7Nh63Ct1EZrUexOmiVLhwA+azN1K+hCxtkJxJtT/vO
CvTrSPe/tblbTVNgEhzoJPrnyWWPRy8aDsk/3yr3d9JpgqFmhHTo1s6GKSsW3OAO
zkWVzkQH9kKowzOL0BhDzeaZTqY3184LSJDCyF+WViIzQ1kOIDYNpS22EgxN5qIN
yZois7lAYTYkdIUbZJcp7wJupDS/LrcKFlX7P0HJumWo6MxfiAdUOQI3EefdcH8Y
IAIce30SoA5KxU++b8+mLDvjRYLpxRW9B1v40HEr5lAeDPKwi8PvTyJ5Qzp8YjQu
WSgU2LEeKBvGMxB2CgjaoC0JNZ7/KOE8SCrMx2D2mgIFOKNEztSp8MavIw6RETRM
ypCEJoMxw5E=
=n240
-----END PGP SIGNATURE-----

--=-ELxutk0kWeee+h/zkNTF--

