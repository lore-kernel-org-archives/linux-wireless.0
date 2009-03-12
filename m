Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53662 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754975AbZCLWHy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Mar 2009 18:07:54 -0400
Subject: Re: [PATCH] mwl8k: Marvell TOPDOG wireless driver
From: Johannes Berg <johannes@sipsolutions.net>
To: Lennert Buytenhek <buytenh@wantstofly.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20090310091333.GG4738@xi.wantstofly.org> (sfid-20090310_101347_405119_5EF3E76C)
References: <20090310091333.GG4738@xi.wantstofly.org>
	 (sfid-20090310_101347_405119_5EF3E76C)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-kflP/oMD9nlQbkAdv5TI"
Date: Thu, 12 Mar 2009 14:07:50 +0100
Message-Id: <1236863270.20489.0.camel@johannes.local> (sfid-20090312_230756_189873_58A847FA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-kflP/oMD9nlQbkAdv5TI
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-03-10 at 10:13 +0100, Lennert Buytenhek wrote:
> Add a driver for Marvell 88w8xxx TOPDOG PCI/PCIe wireless parts.
> This initial version supports the 88w8687 802.11b/g PCIe part on
> channels 1-11, and only STA mode is currently implemented.

my 64-bit powerpc box says:

drivers/net/wireless/mwl8k.c: In function =E2=80=98mwl8k_rxq_init=E2=80=99:
drivers/net/wireless/mwl8k.c:897: warning: large integer implicitly
truncated to unsigned type


johannes

--=-kflP/oMD9nlQbkAdv5TI
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJuQkjAAoJEKVg1VMiehFYv9wP/2eCwY/mdIu5DRiDc1FJNdg7
7wBzzxLVOe7szycuq69A8iIzlIQCBGQ+JtV7/YFmAJNHyl5xBGEGDV0nQ+ewRhN4
pkZfbhN2ogCOEO4eq8q5mWRJlA+tAq5j/FMo7GdqVEnhCfzUDdHFm01GYQeWVEWX
mgXRkcX+cfIrpwZW8uDqKyA91b6bmpAiY+1sZ7woemtbBddccVbDv51ONyRN50RQ
4DumyD/k1USSlBaLbQX1rnDWXDcfG1Fr4xFpzOAQicjZn4bOeNCn5Wry8oCbdJHq
5zVXli//A8v4Q3FDseiTPB52OV86EirVwLOo0EikiN5Vf+IM4XkFqLk8kj3H3FLx
P7Y9NRw+Pwd+si5lkG5JE86DcMv3nP1pHG+R/lm20kf1w99skIRP2MqpyAcby3JZ
0o4c5w1QQPKCVh7pfwl+Xndglx5cmZY+h+hEgbtE7wYaHBThHfJF8SiaESUetkOr
MeIyVDyNK8E4th16uOMfkq2kThypFcimOkIcIzU9h18gIl2EJop6t05KIsjPRxUW
p0XtQMLWjn73Grgg9rcJ+NLm3mnyfHOF/bQWpGcPXJjx2h14cxbSwjQw5asclGRj
mSx3zJKEKCmb10+zbTTf9fxz2+NB/Un3QjnbakYVZhyG5/a21iQPFtWiTgH869q+
2oxCNk9PIF97F7aJ1cuZ
=mG6C
-----END PGP SIGNATURE-----

--=-kflP/oMD9nlQbkAdv5TI--

