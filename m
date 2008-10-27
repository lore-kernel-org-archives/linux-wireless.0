Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44526 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752029AbYJ0QwL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Oct 2008 12:52:11 -0400
Subject: Re: [PATCH] mac80211.h: fix kernel-doc excesses
From: Johannes Berg <johannes@sipsolutions.net>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <20081027094703.754167e2.randy.dunlap@oracle.com>
References: <20081027094703.754167e2.randy.dunlap@oracle.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-k38kNmEkLvpyZoK4HXQ8"
Date: Mon, 27 Oct 2008 17:52:06 +0100
Message-Id: <1225126326.3796.31.camel@johannes.berg> (sfid-20081027_175216_035536_D82F75BC)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-k38kNmEkLvpyZoK4HXQ8
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-10-27 at 09:47 -0700, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
>=20
> Fix mac80211.h kernel-doc: it had some extra parameters that were
> no longer valid and incorrect format for a return value in 2 places.
>=20
> Warning(lin2628-rc2//include/net/mac80211.h:1487): Excess function
> parameter or struct member 'control' description in
> 'ieee80211_beacon_get'

Cool, is that new functionality? Thanks.

Acked-by: Johannes Berg <johannes@sipsolutions.net>

johannes

--=-k38kNmEkLvpyZoK4HXQ8
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJBfGyAAoJEKVg1VMiehFYHmcP/30CjYt27GqnHXaEEY5RG/Ow
j3Axi6qvlffkTGJmrY2TAPenuDgB3DNSg7kd6jrkoSSe53Jvi9TaZFyMfCHZS4ep
ioIi3sQGpRVT0tgbr/ohnlggXUl9N7B+k1XHON2fkhGD7SNp5J8LRsisc6v2QcGC
12wnzGiojdg0OjwE7tQTQgTXbyhMaQyz7DNBeKQSyuC5ADo8I/vZJLDlz1wTEo35
yPxZuLz+oqg6WXS0wSOcQSgUgDXofWC0KjIRE0AiGg5g7pptNvaP/gMRSB7ZLG/c
3s9dLWk90X0ZTdarl2WfvK1ErVwhna2MLL4be+w3HXUAb13Qf7UmzZlmQS0ZwxDS
K1OS9nhVZtRC/twxNLViu6OJIleMGlSJCII0REjdjmAc0jxScLVsF+qoa2JibWg7
AZyAjQwZgGxXnfFF2qtZGyJJw8tDk6nqZo7V/00uIbVFs5d4F2i/xs7y5tw2hZ4x
aq+fPQ6ypfRJ2sdodCh1evAo2okQUCrbFsf9F5YTiswZiZk57VgxsD5YLW7VY4FJ
T0S4upaYLq6YOBxMfW6H14SxU926zHVBYg5bBcQKPdReiRChRfHoYB38g4PQGs4t
wXydDazt/+zkXKWRU1g4Vn8dAWQRAwSfTKjb0RYmSOcTJNGgLur9WaWYaHy5jjo7
b9tU8aA0Bac70UVEArGR
=lnSz
-----END PGP SIGNATURE-----

--=-k38kNmEkLvpyZoK4HXQ8--

