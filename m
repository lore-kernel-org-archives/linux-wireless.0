Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:50446 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156AbZKNSjc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Nov 2009 13:39:32 -0500
Subject: Re: Unable to buid mac80211 with pid and minstrel
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: =?ISO-8859-1?Q?Mart=EDn?= Ernesto Barreyro
	<barreyromartin@gmail.com>, linux-wireless@vger.kernel.org,
	Gabor Juhos <juhosg@openwrt.org>
In-Reply-To: <43e72e890911140943t3a70b9a9g3ab9002b4acb92de@mail.gmail.com>
References: <1258156563.4589.2.camel@localhost.localdomain>
	 <43e72e890911131614v1b5ac6f5xa80caab69f400d4e@mail.gmail.com>
	 <1258159451.4589.3.camel@localhost.localdomain>
	 <43e72e890911140943t3a70b9a9g3ab9002b4acb92de@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-1naManXzFbIp6tSLvuBx"
Date: Sat, 14 Nov 2009 19:39:33 +0100
Message-ID: <1258223973.21252.1.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-1naManXzFbIp6tSLvuBx
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-11-14 at 09:43 -0800, Luis R. Rodriguez wrote:

> Anyone recall why PID is pegged to embedded?

The entire selection is since we didn't think it'd matter to anyone to
have _no_ algorithms (only embedded systems with ath9k and its rc), and
minstrel was deemed to be a good default for everything else.

johannes

--=-1naManXzFbIp6tSLvuBx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJK/vlhAAoJEODzc/N7+QmaJVwP+QFelAui68NF4t6jfuTSZpYi
0utMtCQq42CgOiLsRqTIREk+Ocy5QPICeAQrACPdsYOXQM2sgNCPdLQDFt5hyyC+
C3nGCmA17wOxUFGatL8g5lo45S0cOKntDshJr9AWXzdPjPF8wWaI57R5wrVyhtQc
G+cYnaxquPYuxOcytn+OQKPsOVKfgW1OgPJfr3M98D0uxDShj/ffrJ+645RluQif
E7Bo72Ed0ksqWoJnH5Tb6LRiduImlYGt0/eOE+NTXtKhVmxA/B57wtSEsCQdqzci
1JE3wSlRLTOGICQhvJcSMiyisjV9jhaOfoLQjpPg5QHwMoTtg04KDQsnSbSY/v2U
jiA1DVr+g1pkqHYpSKDzOtcfg1GgaaYsQn9Xf8XX3Dbfb91RxMoBl0Ckur+X2lrd
oEMSiYZKXRhpg78Tefhqq4Bp9RQ+otUR+RSM9ks6dSOhMq0i1AHEDr9r/5ZNQ3Rd
tFkM3A91YMyNWiHmRxYPD8r2xDNGYLdyObqA1+Cj+Y+w2uFnBMKIQk7d343bo6RR
DD+whv4vOwi8jLWFInHXfGNreLz64z5ajrPq0aPK9o7dZDHoW/l1L8hQWZGrnToi
sSUxHHL3ZRlWVb2r7WunZSysyf43cln27+PLepqj2iPEt9++QkFH2fAt/Y0kmikS
R59k3VOAYcK83/hgpgxh
=EAlj
-----END PGP SIGNATURE-----

--=-1naManXzFbIp6tSLvuBx--

