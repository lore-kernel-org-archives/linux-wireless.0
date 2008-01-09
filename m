Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:39024 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753419AbYAJMD2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jan 2008 07:03:28 -0500
Subject: Re: [PATCH] b43: Remove PIO support
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: John Linville <linville@tuxdriver.com>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
In-Reply-To: <200712261441.30437.mb@bu3sch.de> (sfid-20071226_134936_351777_3A34487A)
References: <200712261441.30437.mb@bu3sch.de>
	 (sfid-20071226_134936_351777_3A34487A)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-rQr3dF8pntTshB25wgvL"
Date: Wed, 09 Jan 2008 18:58:12 +0100
Message-Id: <1199901493.6762.32.camel@johannes.berg> (sfid-20080110_120331_950043_2CDADCDF)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-rQr3dF8pntTshB25wgvL
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

John,

On Wed, 2007-12-26 at 14:41 +0100, Michael Buesch wrote:
> Remove b43 PIO support.
> DMA works well on all supported devices. There's no reason to use PIO.
> Additionally, new devices don't support PIO in hardware anymore.
> b43 PIO support is dead and unused code.

You merged this patch, but

> After applying this patch please do
> git rm drivers/net/wireless/b43/pio.h
> git rm drivers/net/wireless/b43/pio.c
> to remove the main PIO support code.

forgot this.

johannes

--=-rQr3dF8pntTshB25wgvL
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR4ULM6Vg1VMiehFYAQIJHw/+NzziX1D9jjFYx/Fsw6PFY1AmOi7nalgW
scM/hk7uQGApkJdSOvoROfVKRL2TgCfFozrV8btZaNKePW+16dnYbjY8rTlSbQ+k
Y5hMucDWLcOcl9pzTcblBsRCrTmBLnbHe8sLXieF41HoBGZhD4jb4NkavYpE8FE4
UmUKl45aFx7andcZiSZWzpm6vpOQkZ72VsrQs5oRIiezb3Hcw6l7waMY/+i7MpQ1
V5DXg2fQRjAiFTugIEGPRU19qInIem9xijWKNPcfZ9HJzgPg4SllOAGBw0zWIh6N
yPUd5kATbW3nt1eGH8rFgmeYkrHwQuoGHwIIOcclcXKtswuUsMXnpjW+b9o7ulV/
RXnm61svNCQQocNrhafQAEjCT/onxyvN2G41KYvUb9tnwd5HrKRnB2o1Y3BH/xWq
3//kcKp7OKpZ1lIzabDoWMupXa1qVlzvlmN6RzHQ0hV4lfRL4keBH5wkgnJFY5IA
3wz/iQPiHgqKVE1dDiMCbP/z2F7+kV7VDzMm53CBbAR9FtvlfuhIFje2wruyQEsV
o0mXblcOoIFWsRC1hybsB0eG38OhXgMCYdWPCIZeUaoc6FLeckxN4qLq8PXcU5+3
26Oor7RaJEg7GeZjTt6MUMS0PcofQo64RGUlT6MlrOJGDRqOGJWb+cR1TFt1H3gC
VkpM20cgWGY=
=LEqR
-----END PGP SIGNATURE-----

--=-rQr3dF8pntTshB25wgvL--

