Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56701 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752177AbYK1V2H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Nov 2008 16:28:07 -0500
Subject: Re: [PATCH 4/5] ath9k: Add initial layout for an ath9k specific
	debugfs mechanism
From: Johannes Berg <johannes@sipsolutions.net>
To: Sujith <Sujith.Manoharan@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Jouni.Malinen@Atheros.com, Luis.Rodriguez@Atheros.com
In-Reply-To: <18736.8527.664371.487538@gargle.gargle.HOWL> (sfid-20081128_175330_110916_CC18E0A1)
References: <18736.8527.664371.487538@gargle.gargle.HOWL>
	 (sfid-20081128_175330_110916_CC18E0A1)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-3Dd8lMjv/1DI5NBkpkm6"
Date: Fri, 28 Nov 2008 22:28:02 +0100
Message-Id: <1227907682.3479.4.camel@johannes.berg> (sfid-20081128_222812_559167_6B2BD619)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-3Dd8lMjv/1DI5NBkpkm6
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-11-28 at 22:20 +0530, Sujith wrote:

> +	sc->sc_debug.debugfs_root =3D debugfs_create_dir(KBUILD_MODNAME, NULL);
> +	if (!sc->sc_debug.debugfs_root)
> +		goto err;
> +
> +	sc->sc_debug.debugfs_phy =3D debugfs_create_dir(wiphy_name(sc->hw->wiph=
y),
> +						      sc->sc_debug.debugfs_root);

Any reason not to use /debug/ieee80211/<phyN>/<KBUILD_MODNAME>/...?
Can't say I really care though.

johannes

--=-3Dd8lMjv/1DI5NBkpkm6
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJMGJeAAoJEKVg1VMiehFYZEcP/3AD2TOkvL4wfG0vker5O6d0
FTG5WcxFux9btt/NvCpOAFqMUkti7ACpruTWnOkVyoDxbGX/GKHdQJlKP9oXZ7dE
FFO4nllh0q2vJXxZFQl7JH5M332O4r3CLL8BQKwN2wNNIhxHbFNNOe21wvluqNiU
PaRrTzWhuTM7oRjBssGIOQNbfV87DVXN5SsL7ujlpPDqWzCrjBohWYHl0ye7mh1F
qUsCSrltQGDRc8/b00j8/tQPFOuK+kCvlSTU9dGxRyK/DqwtF6xZvIpPvPbhbZi0
AQOvxHGGqLcR81CL3FW/XMo+8sJ5GjIBb3G78qDWEqxxW9jxaPkVYzcbxrQK9CTi
nditMF6fPrszubKBckLBJcmAnCXEKOSZQRRAiaSsr/uli5gbOLDInD/b4wd0uj99
H7URdU1Tj3IO/QjdiicvpaJV96U/NONzae64Vdev0O51C41VveBJOqMaV5Tf6PfR
ZL+2E+keq80E4rRYiYdXHt2wFE0vQuFNpsdVNa6oDopjvywCe5sQmV5c4aPt4AED
G6hgoWoQgIoQWJj2imh6Ix5AyQv+KvwH7MhbrGQ6reD/hfG2TQwEwwltqIGnYU+H
Pfm+nJahreo8AD4HiIl9zIslqa/++guROuVtApA4CLYBMVxn7CCdKXSMXm0IQskk
AQ9S3l9zl6EZmoIE780Q
=ftCh
-----END PGP SIGNATURE-----

--=-3Dd8lMjv/1DI5NBkpkm6--

