Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:38714 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752650AbYKEPwI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Nov 2008 10:52:08 -0500
Subject: Re: plan for libertas and mac80211 and cfg80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Cliff Brake <cliff.brake@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <f96d234e0811050728t63f3793eqc395ff979dafd9f6@mail.gmail.com> (sfid-20081105_162837_225849_AF63D3FD)
References: <f96d234e0811050728t63f3793eqc395ff979dafd9f6@mail.gmail.com>
	 (sfid-20081105_162837_225849_AF63D3FD)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-GV1Tei1Ae5Jug+oLkDAB"
Date: Wed, 05 Nov 2008 16:52:10 +0100
Message-Id: <1225900330.3619.125.camel@johannes.berg> (sfid-20081105_165211_477993_EC34DDBF)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-GV1Tei1Ae5Jug+oLkDAB
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-11-05 at 10:28 -0500, Cliff Brake wrote:
> Hello,
>=20
> I am using the marvell 8686 in several projects.  Is there any plan to
> move the libertas driver to mac80211 in the future? =20

There's the libertas_tf driver that uses a different firmware, the
libertas driver uses a smarter firmware that's "too smart" to be used
with mac80211.

> If not, will
> cfg80211 mechanisms be supported with this driver?

Depends which mechanisms and who's interested in doing any work on it.

johannes

--=-GV1Tei1Ae5Jug+oLkDAB
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJEcEmAAoJEKVg1VMiehFYKtgQAJvsdEtsg8zh0kUVqSG/L96l
fu8bWLb9Ah/qWl6nIjf18+ZBaei4w4bLbMZj/4+02IdR7irR0pFG73djSQTupolw
aumsAyiw+eKdGEtkpVo6L1GEyBDIjKCqYh/wSaIPtW5KLd3cTZtKHtf8RxIdQnfx
jAvUnEjdlESnCHpoHVKoAQVRf/aOBKYCQYB691N7gxB6GSQSwX9n5GShCBszAG2H
Q4N4uM2HtquJxb8rm1i2WOPdyWGUNJ3NwDj+N/cMwipfshwF6X/Q+YafEowhCS9H
QlIhSrnSTaWi9LtEQO0MfTv2nQQU2cOOpWT/jp+cAsycwqXr9dTWqlF/LaEG5OH5
qwW+DvS1K1T5Z1T1NWNXurBNE2NBpLl5x0nZUBqkIHjBy2tWeNnJtfQZuhj0TMlu
vLfKHBi9ZdA4fxyJDXmxT9osbn1aZGKAy06w4GEoxFcs2F69MFwqItUUeczlyXZi
YlOVdMRYu3Khhz5fIyFPpFd6z5mY/35R6oc61RwqPIq8RNoyR1p82UYxGQiq1yO3
+7Rbmmic1UbxsPnLIsVmgPCa8olQMCVBLOJ3bPa2V8fRVOVVDFRZ634bBFZdjYsb
82mGK83HsTJKKf3URa7CHT7FRPAHMe8hEg2HNMYkOITZlzmJ81j7/OqwRlGczwYc
+PbeiZbX7VaWswLvYwEh
=tF2n
-----END PGP SIGNATURE-----

--=-GV1Tei1Ae5Jug+oLkDAB--

