Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:43354 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302AbZI1J3Y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Sep 2009 05:29:24 -0400
Subject: Re: [PATCH 1/2] net: introduce NETDEV_POST_INIT notifier
From: Johannes Berg <johannes@sipsolutions.net>
To: netdev <netdev@vger.kernel.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Hugh Dickins <hugh.dickins@tiscali.co.uk>,
	Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <1254126089.6583.18.camel@johannes.local>
References: <1254126089.6583.18.camel@johannes.local>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-0uyeY+YOv0XPyBMT/sTl"
Date: Mon, 28 Sep 2009 11:29:23 +0200
Message-Id: <1254130163.6583.20.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-0uyeY+YOv0XPyBMT/sTl
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-09-28 at 10:21 +0200, Johannes Berg wrote:
> For various purposes including a wireless extensions
> bugfix, we need to hook into the netdev creation before
> before netdev_register_kobject(). This will also ease
> doing the dev type assignment that Marcel was working
> on for cfg80211 drivers w/o touching them all.
>=20
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> ---
> I decided that it doesn't make a lot of sense to be after ndo_init but
> before the other name/... checks.

Ignore this patch please, I have something better. Marcel, feel free to
pick this up once you continue working on your devtype thing.

johannes

--=-0uyeY+YOv0XPyBMT/sTl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKwIHwAAoJEODzc/N7+QmamzoP/R531Auz0xfIDvWzc/fnpZO7
b4NbXTCFNpHnJAKWz96s0n/WEsvODnUKZsDq3T0Z63vOQgax3yeJFAkjzJIPDVOS
RRLKZQxC3InC/VczSV2ethb0dbkcZcfcW64t9fu+zV1EQW0y8VvTfqvJMDnTCcRn
nfqIc08DcQ3bJ/LPm7DErGtbF2CJ86a31gnCLrwFhhuKIqhP0+il0o1G2n7WzbCt
HkX67a1owek/ZS+gq2lHc9xxvXwEPZz527lkfMrBLOzifYSgKupn3rL6ACr8e8er
y++CPzFC7q3vnNYHFvTCwDaJRxtINP5mWBHYFAMBcG1EeecyUFwUPrdxeXGAISUN
qxaITEykozakP0lo70FZFTORClfnw0yCY+jCUt9rKenDfCe60joDHbK/fHVfyzeQ
CslRT4CsSW+Q3/B6zRXoYVekYgKwGKrtfPwhC1LKVr6ALz0ksUo6plgf/6HPk2aD
Gk369WU+delYdkoVSjyLIdIsUmQ19aCUhoVkvU2czcz0qgFlpA5nQIzHRsw0l8oM
aZjDGopRwOCPHNLgWqudI5rO7Wio21Bqc2EiZUDevrnvDoSvZEiTLhTqJQAxJyYI
1NnqMVpln2iTZKqrjAmgKuOP7/uPiA6lfMTNkO3LACp/FJD93LjrbAwJ7lLV6ieb
0/61UB2mP5vY7rEkekyb
=escH
-----END PGP SIGNATURE-----

--=-0uyeY+YOv0XPyBMT/sTl--

