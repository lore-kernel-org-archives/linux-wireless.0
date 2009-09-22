Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:46117 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753786AbZIWGei (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Sep 2009 02:34:38 -0400
Subject: Re: [RFC] nl80211: introduce NL80211_ATTR_SCAN_EXPIRE
From: Johannes Berg <johannes@sipsolutions.net>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	John W Linville <linville@tuxdriver.com>
In-Reply-To: <200909210946.19675.hs4233@mail.mn-solutions.de>
References: <200909181849.22302.hs4233@mail.mn-solutions.de>
	 <200909210842.59852.hs4233@mail.mn-solutions.de>
	 <1253517333.4458.7.camel@johannes.local>
	 <200909210946.19675.hs4233@mail.mn-solutions.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-IGmDKo3Y32zv2N0fY609"
Date: Tue, 22 Sep 2009 20:50:00 +0200
Message-Id: <1253645400.4458.16.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-IGmDKo3Y32zv2N0fY609
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-09-21 at 09:46 +0200, Holger Schurig wrote:

> I hope this now makes more sense.

It does, but I disagree with the solution. IMO we should just add a
"last seen at" timestamp to each BSS so wpa_supplicant can make the
decision which ones to look at and which ones to ignore. They'll all be
used when you don't let wpa_supplicant roam, but that doesn't really
matter much.

johannes


--=-IGmDKo3Y32zv2N0fY609
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKuRxVAAoJEODzc/N7+QmaQT0QAJR5BP5aUs/0o+rnUeG1xVrV
pTL/7qVxtGvrS/2d4p5RXmi0qW9jtjCYAzKSqNhDOAEMmK85t1DyoX0ss3qUCBCY
GhpfNuZXfEtEYDwmSAdG+i13gVVUWxf218FLCNgMk2mVcJYJCW7UoXcttTBUQk64
Mx/nuonhNMr5Mws8dDBIGEBLdqbWUt3JFUmelIfY3Tbu0CwjrJLu4Q6xddIayrUk
COBkL9REeK6A8iu2v8dxY405lmTpJtvpTkBGcVqO5xF6ES4txtxjRBdQMgctwMxp
FBukawkwYRixdw3gXDEPeDJDeNtmxPkWtwDKn8ZIQjyEdnVe4e1cDU9bxKFsPVeV
yYW2r/olo0/h7CUM3MnsoFpKMNxyOUK4s1tJhhfTD00QiZONBlWJv+vK8EG1VRHV
oHWsZ/YoYrQiYxiFuBU7hiGJcBUlkUVEGIFTqQ22syYZc4IICILJGEsoycbvIA6I
uVYjJWpiIVkPy6cHpJwLhu+P1Xf8eL38CAgACXUbysNMbYtQ9hHb+Wzy5RnpTor5
IXWGg6bFIPYvtoJqE1MNSm5zEcknN5rJ5e2znd0wxcJCodh8uK4wTifq9dlPUVoZ
Im1NPlaFtZLuV89bpOKICmlAbfRYcWTT9SPwPTDFldgHeyMcf7xpfriaGOYYpNPx
itCACK7P4zE+PmrnSJwx
=NFu0
-----END PGP SIGNATURE-----

--=-IGmDKo3Y32zv2N0fY609--

