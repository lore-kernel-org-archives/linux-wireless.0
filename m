Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:38780 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753896AbYCTSfx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Mar 2008 14:35:53 -0400
Subject: Re: [PATCH/RFC] introduce ARCH_CAN_UNALIGNED_ACCESS Kconfig symbol
From: Johannes Berg <johannes@sipsolutions.net>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Daniel Drake <dsd@gentoo.org>,
	Linux Kernel list <linux-kernel@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	netdev <netdev@vger.kernel.org>
In-Reply-To: <20080320181310.GA17884@uranus.ravnborg.org>
References: <1206023695.16475.137.camel@johannes.berg>
	 <20080320181310.GA17884@uranus.ravnborg.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-0FES/eduH35huO1gJhWo"
Date: Thu, 20 Mar 2008 19:35:35 +0100
Message-Id: <1206038135.16475.148.camel@johannes.berg> (sfid-20080320_183557_874203_1EE7D4EA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-0FES/eduH35huO1gJhWo
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Thu, 2008-03-20 at 19:13 +0100, Sam Ravnborg wrote:
> On Thu, Mar 20, 2008 at 03:34:55PM +0100, Johannes Berg wrote:
> > In many cases, especially in networking, it can be beneficial to
> > know at compile time whether the architecture can do unaligned
> > accesses. This patch introduces a new Kconfig symbol
> > 	ARCH_CAN_UNALIGNED_ACCESS
>=20
> Can we please have a single symbol defined and name it:
> HAVE_*
>=20
> Then the architectures that HAVE this feature can select the symbol.

Sure. Where should it be defined? arch/Kconfig?

> This follows the suggestion as available in
> Documentation/kbuild/kconfig-language.txt

Guess I haven't read that in a while.

johannes

--=-0FES/eduH35huO1gJhWo
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR+KudaVg1VMiehFYAQJ7ig//byJi8CKfE/7515uLj4GdSidKrvL6LGt4
QcEahi7hVp4CIXnD0l8bIvWQEiqjjSrkVMMetC8aQxtUa6hqh02BLIJsqLZxpomv
/gKtks9bRK5JsABLejd+Q+OTjQL7zPlaaN1Rawj2XvJu+OkjdbHwzkIroEswnHzJ
9SzCZwAfuoVh6DYsgxfeWxPEbCUrOLy1gqRQTUau4fR2Tv1qA0Wdlfy3z18AzkZQ
/dULBvQPqsdoEt8/4V0iw36oKdaCPFCKDKhTurEZRKDTiuJM04enMPCXz8S8cfzY
Cz+L8a7jHNHfqMEAlw15Tut+STjK5F+wIPTSiBdunhsEMmHkc3D5ggnY+yLiqbT1
jXXONx52+Fk8wk9iHkppQEzIUTou/vkBXa0RQR/sEXk7SiAZQaerND5QWL6UyHtR
grdGFIZ1VIq2Ug8ld5RkVLuHW0loAlLoR5W3+q5T3/apE6jgCBvZtfKURmbnKeaQ
gLEynMdfHGh67LQvkt9smfh2ejWr5EALKepDwBlSrknX7ar2KxyeFv6RoeWG0EAN
vZTaIlQgYTKmfGA5oB4FW/HJ+6Ha4H9qxPMOmyVQ7vNxVCBT7YxldqzPnAx6i1gp
XQ1JdJ4FkUrLkrXvx4l5mmlZALPkpWhdmrvvaUYdQTydN5i9zUyLCeuAXa2uGbw1
LTCPv2yD58Q=
=fWRa
-----END PGP SIGNATURE-----

--=-0FES/eduH35huO1gJhWo--

