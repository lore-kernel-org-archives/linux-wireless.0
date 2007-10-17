Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:59696 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755403AbXJQIRR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Oct 2007 04:17:17 -0400
Subject: Re: Problem with in-kernel iwl3945 driver
From: Johannes Berg <johannes@sipsolutions.net>
To: Ismail =?ISO-8859-1?Q?D=F6nmez?= <ismail@pardus.org.tr>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <200710161703.51343.ismail@pardus.org.tr> (sfid-20071016_150340_479148_972107C4)
References: <200710161317.45460.ismail@pardus.org.tr>
	 <200710161703.51343.ismail@pardus.org.tr>
	 (sfid-20071016_150340_479148_972107C4)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ExqSLKU6QSV1OlMm64Wr"
Date: Wed, 17 Oct 2007 10:18:01 +0200
Message-Id: <1192609081.8841.8.camel@johannes.berg> (sfid-20071017_091720_643715_0963B58A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ExqSLKU6QSV1OlMm64Wr
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Tue, 2007-10-16 at 17:03 +0300, Ismail D=C3=B6nmez wrote:
> Replying to myself,
>=20
> Tuesday 16 October 2007 Tarihinde 13:17:45 yazm=C4=B1=C5=9Ft=C4=B1n=C4=B1=
z:
> [...]
> > wlan0     IEEE 802.11b  ESSID:"XXYYZZ"
>                          ^^^^^^^
> Looks like its in 802.11b mode instead of 802.11g.  That might be a clue =
for=20
> slowdown.

A fix was committed under the title "fix set_channel regression"

johannes

--=-ExqSLKU6QSV1OlMm64Wr
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARxXFOKVg1VMiehFYAQL/bA//QE4xBEgcA8POr0XshYCv7ucn8t8IQW8i
Gld8DXeXP7J5XS+TriE9TFlkk4zNCSmfkNkajC5E5MfGdBEtPm8vPXELfP1lYp29
cWh3vQUpEPYdNt5dqwbybaiVgk1ZNBEZO2PRMwEIg30pROQQ/vmpdMrGvFCZ7nsR
EGAW5Wxgbsrgp+mTagbchJhLmN1NIxFdoTSN7dwcBCd1m4O4v80Vk83yuqnB5yr9
g2Ho3GKIHCsOKJ2cHSIHb6WCtVOhVhilzmlPtYXfDp6Dcnn3PxG2ywO2zvsvuVex
9Os8Lcaqs/aZfOSZI5CyDW1DZoh1cxvmSQwFD730xcjHFkA0liHGHgBslUYnXiBJ
f3NhiqwzgigsmGvPpmZMbWo2GMTCPfogjYkkmpqY8iHvwwzp3MmL2jJyYwNluI/w
myWsKyQCVdxRwl/wEzhRCW1pLd88RtlkhjEPrOcgYSeEIF41aimKknwY1Q0em+Gf
qhdRHHYKKegDxlqqLBHcpmdX2CUfpGnzdikhWw1vf2Y1DdwT26n/VYYf/n3flnC7
Y7eNOB+OY3aYpUmG+7bSWr2w5ch9D63YF63n4qUVmUryilO7GNgE5+1rEn5EwAoH
+4x8j8GftNqvFe5aBarhgdgX8Orfi878mod6fdHiHscPKeLGO2HHzoUE8I6etN2W
GJMDFK8Yn4c=
=+GzC
-----END PGP SIGNATURE-----

--=-ExqSLKU6QSV1OlMm64Wr--

