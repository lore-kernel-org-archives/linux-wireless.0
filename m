Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:33904 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832AbZDUMcg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Apr 2009 08:32:36 -0400
Subject: Re: [PATCH ] mwl8: fix build warning.
From: Johannes Berg <johannes@sipsolutions.net>
To: Rami Rosen <roszenrami@gmail.com>
Cc: linville@tuxdriver.com,
	linux-wireless <linux-wireless@vger.kernel.org>,
	David Miller <davem@davemloft.net>, buytenh@marvell.com
In-Reply-To: <b25312890904210457u1fffa553sa661d5b093a6e80f@mail.gmail.com> (sfid-20090421_135746_848217_7C9C959B)
References: <b25312890904210457u1fffa553sa661d5b093a6e80f@mail.gmail.com>
	 (sfid-20090421_135746_848217_7C9C959B)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-kEU5mM47+d+X2ubsF2fF"
Date: Tue, 21 Apr 2009 14:32:00 +0200
Message-Id: <1240317120.17388.16.camel@johannes.local> (sfid-20090421_143239_532126_FEACCBCC)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-kEU5mM47+d+X2ubsF2fF
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-04-21 at 14:57 +0300, Rami Rosen wrote:
> This patch fixes a build warning in mwl8.c.
> (Marvell TOPDOG wireless driver)
>=20
> The warning it fixes is: "large integer implicitly truncated to unsigned =
type."

> -		rx_desc->rx_ctrl =3D
> -			cpu_to_le32(MWL8K_RX_CTRL_OWNED_BY_HOST);
> +		rx_desc->rx_ctrl =3D MWL8K_RX_CTRL_OWNED_BY_HOST;

Umm. This really needs to come with an explanation.

johannes

--=-kEU5mM47+d+X2ubsF2fF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ7by9AAoJEKVg1VMiehFYnSUP/ir0ExJQA/7nKjDrvZHNgkIA
ZZc8qxk85VtWTjfd6XHKNM+qqbAGAT7zR/2JZAgTFQaTDyLocg53P/sM7tNzNRbK
MbTAn6ELc9ruIOPZQ6i9tgN86uc48zFPy9qwAOEnBOqnCK8Msx6Y5FfADKUzyfnD
Bg9HkRZD1hPnJgHQJDDjVFVs1ffSrV3V1eOpYZvvOmiKcsP+FL8OyN32wdailZtu
J3nlvERg+RqKHgoPdAmdrXHL28WXcHadX35DPYpN9064qvS8kGdDIiPXxX36ow6G
Y9qCMNLbyiT2IQP1iEIIod3PlM5Aqca7tsTDSxEhYVoBSEEyQFsXI3NdxNfrJyB7
20tsZmoAXzkqtuqHPjB39DOlp5M5V4t/YElwVCs5R+zctVwPxOsItaz4ymXIobVA
HRqLXELEA2T2oyv2MTU9eWVSPrnA4ylIS3rKXEFsadiIsfrS91WDu3KXBqyIw2B1
uVkXh7nWzxcqf1v/9mRjZlC78Za3G5hN+XxAfXKNXofkhNoKfSzcE2+wSn/tqiVr
ojWpxVDfCNuC7r0Oi6R2FRdhd5zI+8ZcmZGQu1an72DeE+GDRIhljCnklJvRIm+k
NsWiVFD95WbaewDki3UpiQ2T+zU4+REnZUWAarfrkGLgUEvC66tr27f8qtsBtsCd
iq3VPMtuVPJbTdsiVpS0
=ugqU
-----END PGP SIGNATURE-----

--=-kEU5mM47+d+X2ubsF2fF--

