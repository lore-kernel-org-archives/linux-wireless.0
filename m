Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:40323 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752703AbZFFRiy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Jun 2009 13:38:54 -0400
Subject: Re: [RFC V2] b43/legacy: port to cfg80211 rfkill
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200906061134.47483.mb@bu3sch.de>
References: <4a2961a7.RxVbjEA4JdOf01BF%Larry.Finger@lwfinger.net>
	 <200906052338.05653.mb@bu3sch.de> <1244241126.15640.3.camel@johannes.local>
	 <200906061134.47483.mb@bu3sch.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-pU/FDuILB2gr409cBCd3"
Date: Sat, 06 Jun 2009 19:38:54 +0200
Message-Id: <1244309934.17485.7.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-pU/FDuILB2gr409cBCd3
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-06-06 at 11:34 +0200, Michael Buesch wrote:

> It is OK to poll the bit while the device is supposed to be on. But it's =
not
> OK to turn it on to check the bit.

Well, I'm going to do that anyway.

> > Larry, thanks for your patch, I'll modify it to turn off the core again
> > after checking the rfkill bit tomorrow.
>=20
> How frequent will that polling happen?

Every 2 seconds, currently, I think.

johannes

--=-pU/FDuILB2gr409cBCd3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKKqmqAAoJEODzc/N7+Qma7DIP/jQH6DPLzsp8HAKe4AtoNvWi
7wGoqXvFqbnl36b1V9LID4w7w8J5UIrNNYwE1T92uHJ/BS4AnxlY4n7+rSsQc2TB
SSGVd5qmZh0lpNODNYkgRZsY1sbXTPlZScA7xX4gFuOyToq7cUYnsBbvWTY8xXyr
+0VkRFoL76gJZ42mXreD2fnF5caBni1+/nUZAg3WDeIbn1yZOI+WQk70C7+oFu5z
e7ArL5MUoEkVhZQTHEEkNS3vSYYJh1CZ3t+0L/i9qTmB5KGZHbAqu+iNenu+dfgG
CIFAXOftzC7leiqgacpi8DVBmQtQtI/8zGBoCkLhi5lmfMJA26LHGk9gtmBn2A3v
sw2f0A8G7bPSpwaB2NYQaC8iPsQlij/P6VaRf5kch/jk+hts1GEieyuGM7M8fdog
wCjN58ps+2V2lqKgDg0FiXa0lp0r0Jic3om1DFtBVHAx7A4RI+7g1Tow32xQ8Gix
9qBmlFfWKdaf89jZRJ9/AMDyPNJeQV1ls+ZYJ1MjobHXwgOXnBdVRh5VnUNUPexm
zf+Ng+mtNFxZgLjAIZGAV3A8ZsyiO1V71iKNtwobC65qhLQEXSfEyuMoDcxYJ1Ej
ItZ65uErBpf7/CKiRUfhKGJ71xvlni3Kr2AHfxu69Z93qzljkw7yFMCwFqUwlUNH
ba+EOG2lIyDKOr83mkna
=RzL2
-----END PGP SIGNATURE-----

--=-pU/FDuILB2gr409cBCd3--

