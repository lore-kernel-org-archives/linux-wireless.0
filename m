Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:47396 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805AbZIRRLp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Sep 2009 13:11:45 -0400
Subject: Re: [RFC] nl80211: introduce NL80211_ATTR_SCAN_EXPIRE
From: Johannes Berg <johannes@sipsolutions.net>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	John W Linville <linville@tuxdriver.com>
In-Reply-To: <200909181849.22302.hs4233@mail.mn-solutions.de>
References: <200909181849.22302.hs4233@mail.mn-solutions.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-nLCU3SAA2u19MahWI5hv"
Date: Fri, 18 Sep 2009 10:10:42 -0700
Message-Id: <1253293842.4787.1.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-nLCU3SAA2u19MahWI5hv
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-09-18 at 18:49 +0200, Holger Schurig wrote:
> This attribute allows user-space to override or turn of the default
> BSS expiration time for NL80211_CMD_GET_SCAN.
>=20
> It also allows to set an expiration for NL80211_CMD_TRIGGER_SCAN. Setting
> the expiration to 0 will clean the whole BSS list.

tbh, I don't really understand the need for it. changing your AP
settings doesn't seem like a use case anyone would really care about
that much.

johannes

--=-nLCU3SAA2u19MahWI5hv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIbBAABAgAGBQJKs78PAAoJEODzc/N7+QmaRlgP9AuM+WImhXi9xof6o4G+AQUr
ihYYMLZc5FMwmCC2XcO8TCtDSHSmw6aMEETLTTLDnBhqcNR3iPCQthQBP7PogXli
/8BwlTn0rJYFGOtj9vhzMcXmuD4wDJUWWJ7WsJwn2ukovUcKhftMq86BJ1vthop4
B519jZkeTqk8DvebIFNabQrmzzavpmw0zu79Y9ZFzZ/pwnyJRT9oF6rG4uQInTPM
HLkdjM0rSBjDvYlqUwKnJmoKur3N2YwYuVHeSPczqIUB9zUNyJcjMgiYJ85F2FXb
GNTmniNu1XboLH5vmFphBpVY7Rx6bFmpDtBCJYnMPv6ZbBj/aUL6WEtx9b2hUlqK
4iuQn70eBIBDbqMhQ48Li16lYfurUKW+3MR+AJcgRoykbAnIsIN+NqxQqanm1EYI
VfVFMYOhI7lFbnIorVxIKnNJLV/tq7DudLNd5JEfOcGNJJ9yhrmOfV5mWHquvmVa
Z3PcfTQ4xHpV47Ahu/BWPYK0j0U5CeyMGiCgCth/QTLk8EcPSWIjpLwNHngByARf
nSF3m8JARrSyWnfzrBL6fvUBW/YFp6akTmZqPKFqD+zjVOJYHrNyLq5zrVUri5/J
7okHjQTk/CJr6SD2ComOq6k4LmeFvB9lNLdpmb3dg07UwzSqw8K+v8lSKYbMEdAu
OWGYEsLSRo37WOAR9fM=
=VyRo
-----END PGP SIGNATURE-----

--=-nLCU3SAA2u19MahWI5hv--

