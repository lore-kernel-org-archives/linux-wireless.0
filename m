Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:55538 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757522Ab3EBNGY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 May 2013 09:06:24 -0400
Date: Thu, 2 May 2013 15:06:03 +0200
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: Thommy Jakobsson <thommyj@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	b43-dev@lists.infradead.org, Larry.Finger@lwfinger.net
Subject: Re: [PATCH] B43: Handle DMA RX descriptor underrun
Message-ID: <20130502150603.2ac36385@milhouse> (sfid-20130502_150628_346569_AE82D01F)
In-Reply-To: <alpine.DEB.2.02.1304231851040.1513@kelly.ryd.net>
References: <alpine.DEB.2.02.1304231851040.1513@kelly.ryd.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/ugTe_DC_=MVtQbrJDDzt82a"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Sig_/ugTe_DC_=MVtQbrJDDzt82a
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 23 Apr 2013 21:45:11 +0200 (CEST)
Thommy Jakobsson <thommyj@gmail.com> wrote:

> From: Thommy Jakobsson <thommyj@gmail.com>
>=20
> Add handling of rx descriptor underflow. This fixes a fault that could
> happen on slow machines, where data is received faster than the CPU can
> handle. In such a case the device will use up all rx descriptors and
> refuse to send any more data before confirming that it is ok. This
> patch enables necessary interrupt to discover such a situation and will
> handle them by dropping everything in the ring buffer.
>=20
> Reviewed-by: Michael Buesch <m@bues.ch>
> Signed-off-by: Thommy Jakobsson <thommyj@gmail.com>
> Cc: stable <stable@vger.kernel.org>

Anybody interested in porting this to b43legacy (and testing)?

--=20
Michael

--Sig_/ugTe_DC_=MVtQbrJDDzt82a
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRgmS7AAoJEPUyvh2QjYsOjAsQAM31RzyinNXTvF1+IibmbXqk
cYXpApNwrtbN5i1azFVmpPxnwkdYjQGi4l8bDBwLvQ9LA/Frt7DfF0egi5vMRhbq
21Q0Wmx2Pu+yvfLC2pqs2SG4qG8OqSTY2sW7/B3dKbSlhmJi9BNFI0esNgN7OcCe
BcvV7kA1uKwi7EFoyVYDMPKYdDnx9x5z0tz0gfBgM1noPauw/q08GPfd5XaynNFf
QEiNqsZ41+PIHjEB39/veDLTla+UJ4G1Y5eFDTG1YdiUxgS3Zvkfnb63TCV0HbMc
fbJa8LBs2cW81RiDUngKal0RO0sl141knJ0Q8bDqnCI7B0SMDi1qO/HhHwu+Vt2d
/KtMhMBJTURqebXxcLCzk+NrqwPWAg+5VODiZjD3cFc2YZxj+9Kht+OjuiY0h/3B
7XOSays7sly9ab+tIYgGmlr4w354yxQkiPBkTAug5TpoVL79pwUqYH6J+NY2/38F
+pYPfBhGJwJmqw/o9EzfDMBXofTnxRoWbCvdD2GSBTV5JANtlgbqvHTGanm4g8RZ
PBl2n4ORs2KH4j9cg7xYuf9XC82IZKbE68ePGlY1UeWFtUP19TjGbAij6fSTIxDv
eJfNSLqoRn1y6QZASrOtnw5hR/qXrUHG3x8LsefcVkSOGtFjC3AQp5XL5uxd5hU+
LZ7tHKCLvESHuM98gFsI
=Is1A
-----END PGP SIGNATURE-----

--Sig_/ugTe_DC_=MVtQbrJDDzt82a--
