Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gerolde.archlinux.org ([66.211.214.132]:45333 "EHLO
	gerolde.archlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751766Ab3JaXly (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Oct 2013 19:41:54 -0400
Message-ID: <5272E897.8060606@archlinux.org> (sfid-20131101_004158_150622_EBCF290E)
Date: Fri, 01 Nov 2013 00:32:39 +0100
From: =?ISO-8859-15?Q?Thomas_B=E4chler?= <thomas@archlinux.org>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [ANN] wireless-regdb: master-2013-10-11
References: <20131011202459.GF14329@tuxdriver.com>
In-Reply-To: <20131011202459.GF14329@tuxdriver.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="TWE708XUr7v9i8oxLE881u6vcRenVf90r"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--TWE708XUr7v9i8oxLE881u6vcRenVf90r
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Am 11.10.2013 22:24, schrieb John W. Linville:
> (Cutting the short log, since the original version got classified as
> SPAM on vger.kernel.org...??)
>=20
> A new release of wireless-regdb (master-2013-10-11) is available at:
>=20
> http://www.kernel.org/pub/software/network/wireless-regdb/wireless-regd=
b-2013.10.11.tar.gz
>=20
> Here is the short log of the changes included since the 2013-02-13
> release:
>=20
> SNIP -- you'll have to check it yourself:

We can't use the database file:

$ regdbdump regulatory.bin
Database signature verification failed.



--TWE708XUr7v9i8oxLE881u6vcRenVf90r
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJScuibAAoJEChPw0yOSxolYqgP/iv0bIf3Yq7STX566Ol2Ih5q
8hGYrOnPLjqEuopIIaYPUOtcoibzUoxR+7PImHFjWYNDNEGyGKjRZ8XorU3Efodv
dMKn1zLpmBLmecX2L13JBXWntImI+ApdCBuv4dIxlw5yvcAEI8iXyFFVvljrzEn3
waLPTYNTjQyOeW69bflzH66iwdeMCWxhXC6NNi98j0oal11BUD1y5mdtnirfyqvK
H+xO4DzAtvbOsCIBmYojVxWba/nL2PNFegCkynjY7WASloMVR4AgnzexZUDpe9Bv
f8hQmvZBfaOF9mnQPBLK4CMXVFHLouhdr3vgQHHSNuOOI570RKZDtnYkeex3Jn3Q
XtVdLOSc6UJ819f36gmRWphaMOxhsq7n7nD28yqwyZ1iei96FOJ/IftIgsVxiZ2v
HUuMEAx6VjVOivpausFtY7CwVFEJQ+2dGCdxMS+FxO1JzxQr4FnjO4bifFyvcDw6
LDG/69pxnpkeCvVY5WxbeG0xB04/GInLL865KLlZPkfK8b0U/wk8zezixqlALldm
pBtsFTM9lw3hLsp5tPmd7wSRnpDZpeVXL2taknub3hm/stwggYcN9QYKt6+pvEWT
L/aPxnG/++HyWoJ4+ui4LfvfZWqA27F0ECWarAobxH8q3Az7PF3Vg0GaKb2fCWxM
/G0LRXKuiGiBAiwNks7W
=TsV7
-----END PGP SIGNATURE-----

--TWE708XUr7v9i8oxLE881u6vcRenVf90r--
