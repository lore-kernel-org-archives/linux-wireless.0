Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53307 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752032AbYDWQyT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Apr 2008 12:54:19 -0400
Subject: RE: Roaming problems
From: Johannes Berg <johannes@sipsolutions.net>
To: Lars Ericsson <Lars_Ericsson@telia.com>
Cc: 'Dan Williams' <dcbw@redhat.com>, linux-wireless@vger.kernel.org,
	hostap@lists.shmoo.com
In-Reply-To: <005401c8a561$4e27efb0$0b3ca8c0@gotws1589>
References: <005401c8a561$4e27efb0$0b3ca8c0@gotws1589>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-KQ9q8H2ub1zOkGNSwhxj"
Date: Wed, 23 Apr 2008 18:53:25 +0200
Message-Id: <1208969605.31429.88.camel@johannes.berg> (sfid-20080423_185456_205737_1BAAF7B5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-KQ9q8H2ub1zOkGNSwhxj
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-04-23 at 18:44 +0200, Lars Ericsson wrote:

> Currently this is what happens most of the time, when all ioclts had been
> issued from the driver, it drops current authentication/association atemp=
ts
> and start with the new one. Most of the times that works fine.
>=20
> But sometimes, when for any reason the 3 ioctls get delayed, the driver m=
ay
> success to associate with the old BSSID (since that is still valid in the
> driver). Then when all 3 ioctls has been received, including the new BSSI=
D,
> the driver re-starts the authentication/association sequence with the new
> BSSID.
>=20
> The problem is that the STA already have a valid association with the fir=
st
> AP. In this case the new BSSID silently ignores any
> authentication/association attempts. My believe is that it knows that the
> STA already have a valid association.

Uh huh. Aren't we disassociating when we change to a new bssid?

johannes

--=-KQ9q8H2ub1zOkGNSwhxj
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASA9phKVg1VMiehFYAQIxMxAAwyQ0/Vpmm21KjauZG/nZHK6GuppkETm7
THo+fY38xRS7GobUyddfTvHDVEHJUIJ14I9TvRUiha1RwqPlyzYKy0kNPcCHq30b
KVQJV6jSqRy8SM3UE0mUNnAuuUW/Snvm9ftL6gCYMl+HZpTaTi26xS5FBSwznl1H
Ata7sXGH5jHQ9YS+eht829GdyO7MCg9B79Een/7uM+NJw9gD4GMBfwAb3fvScetE
KlYjq5ZvaVfFudhWS2Rz9QDBpSQvgwhrGzEjjiozdQmI+Czh3TXSmurQ7l9L0+F7
qYy79C0IgsG99/yPk75DtU4e4q3dRDSB/pYjHvYhLmOHamlBbGLydQCVTDhxRlqd
gl8MriK4eW4xAEbgBoZW9JRbmHLcnCca8tlFeaFOwE2uU2ZK3HqMeQsiwLrGR+Vn
Z8POjm7qxJRTba6wzF0pYdijh+7Ccph6QqGxPyXu3r9HN64QDV2d1XtFckCJlPjM
XeEEmMo6mxoKpFPIWaMKgiv3vQ5/4RCpP98KM+bbUXiR85Kz8Wd/i7yvjzeqqOIv
ayonQzEMZWazITWfItVWEEnV0Pcmu+qkPOMQTLgqMnXm0Yt3+N7L8ObLPMd8sfrG
O/QyZy7sWAx6TJRKekjMVNhgr4Y6jsA9xo7hYItuvugnda8FPTkzYeJVSsuN25EM
M6dECpf2Pug=
=RfXm
-----END PGP SIGNATURE-----

--=-KQ9q8H2ub1zOkGNSwhxj--

