Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:55670 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751710AbbLXH4L (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Dec 2015 02:56:11 -0500
Subject: Re: ath9k driver broken since kernel v4.2
To: Bart Van Assche <bart.vanassche@gmail.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
References: <567BA01B.60806@acm.org>
From: Oleksij Rempel <linux@rempel-privat.de>
Message-ID: <567BA50D.7000805@rempel-privat.de> (sfid-20151224_092249_022503_719E1401)
Date: Thu, 24 Dec 2015 08:55:57 +0100
MIME-Version: 1.0
In-Reply-To: <567BA01B.60806@acm.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="awvjan8NPAJDfkk0HGS9gRIvPDhv2GkE4"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--awvjan8NPAJDfkk0HGS9gRIvPDhv2GkE4
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi Bart

Am 24.12.2015 um 08:34 schrieb Bart Van Assche:
> Hello,
>=20
> The ath9k driver drops more than 90% of all packets with Linux kernel
> v4.4-rc6 on my laptop. This behavior also occurs with kernel v4.2.
> However, with Linux kernel versions v4.1.5 and v3.19.3 the ath9k driver=

> works fine on the same laptop. Is this report sufficient for one of the=

> ath9k drivers to look further into this or do you perhaps expect me to
> run a bisect ?

Many people using this driver. For example it works fine on my laptop.
Since no body knows why your HW is affected try to use git bisect.

--=20
Regards,
Oleksij


--awvjan8NPAJDfkk0HGS9gRIvPDhv2GkE4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iF4EAREIAAYFAlZ7pRIACgkQHwImuRkmbWmSKgD/XfR5bCrRLMSG7WJonUE5sgrq
cJ3zPczqVoGhvVkFEW4BAI8F8eAMEzBq9wK73bK5nZsAFHD9O8llHVmkl4iy2Lyn
=7ylw
-----END PGP SIGNATURE-----

--awvjan8NPAJDfkk0HGS9gRIvPDhv2GkE4--
