Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:52807 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756081AbZKWKSl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Nov 2009 05:18:41 -0500
Subject: Re: Fatal DMA error problem with netbook and BCM4312
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Chris Vine <chris@cvine.freeserve.co.uk>,
	wireless <linux-wireless@vger.kernel.org>,
	bcm43xx-dev@lists.berlios.de
In-Reply-To: <4B09EAEF.6010202@lwfinger.net>
References: <4AFA09C8.4060602@gmail.com> <200911131216.43704.mb@bu3sch.de>
	 <4AFD83CA.2050508@lwfinger.net> <200911131836.26857.mb@bu3sch.de>
	 <4AFD9E20.3060501@gmail.com> <4AFDD1C9.4050402@lwfinger.net>
	 <4AFDF68C.4040804@polymtl.ca> <4AFE1E5F.9040009@lwfinger.net>
	 <4AFEFC2C.5030704@polymtl.ca> <4B068ED9.5070107@lwfinger.net>
	 <20091120195834.334d8bc0@boulder.homenet>	<4B06F685.1020405@lwfinger.net>
	 <20091121001512.02326eda@boulder.homenet>
	 <20091122190353.06cfdab7@boulder.homenet>  <4B09EAEF.6010202@lwfinger.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-yw531TMBigT/kBypnquH"
Date: Mon, 23 Nov 2009 11:18:37 +0100
Message-ID: <1258971517.7094.139.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-yw531TMBigT/kBypnquH
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2009-11-22 at 19:52 -0600, Larry Finger wrote:

> We know that the wl driver does something to the interface that persists =
across
> a warm boot - we just do not know what. It does not appear to be done in =
any of
> the MMIO traffic - at least I have not seen it in the mmio-trace output. =
If
> anyone has a KVM setup using PCI passthrough, it is possible to trace PCI
> configuration traffic?

I'm pretty sure even the binary driver has to go through
drivers/pci/access.c, maybe you can just insert logging into that code?

johannes

--=-yw531TMBigT/kBypnquH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLCmF5AAoJEODzc/N7+Qma2M0P/jm5z12Hd9es2+/0M1FUvlEp
V1qGmBIZg1ymoGVssUj8AsRoE4+5nhzy8caSUVWw8xuyC9tZsV8naESTjawWHaED
sdSFAVu4IjRH8PdTtkRKmW5SZfji58rO3lqBmMxu09u3D05QIYrBHuvr4MZGeHkr
V1YK5TOtuMn2vvs8p3B9XgirNLGRYzgL1MrQC+H4Bh5eOw5PwGOTpe07gUwUT0GX
zMexP6tgonxWlnmfFvYahUKStj8ZJ3Ta6mQrzbsXtqzvKw6MjA3vjMF0PwLxNykg
/IDzRTSaUlrt79lzxkKDO/p7qNwkJV6Azg7gneHrnzSqBe5u1v2W3g/Ux/JEojjf
bYwoB5/7LEjlcdFjZyDOoeFX2/5LCwNGBQ+GVcb5pMDaNjP+2CxvpSbOhrI2e27M
AD0anNN5BterhI0McOzc0vRkUATGYZ0cSDgUUIdYKgaNCUKzyIGTCjnig6LbZplM
UtraMGhr2o8T696Oj+YJjDKNx7sCmrg+w6I/xmTtHnzD4sMa6nn4CsnHtG+aOrkL
+qtrvMe0HfVlHYNJtpNEMpoJqlIVPAFBxbSHld2NfkmJjlHnyj97RpLbtRG8anfW
y9VOF3Krer9Y7PNzw6NwdiUmfUxYjgCfLfUIuvFbYHJ/da6EVS13PC/wwIWOgm+D
VsJMRKBBzZQPAPsX4pG9
=1yaX
-----END PGP SIGNATURE-----

--=-yw531TMBigT/kBypnquH--

