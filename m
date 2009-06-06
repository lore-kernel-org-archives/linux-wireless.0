Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:48300 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752632AbZFFR24 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Jun 2009 13:28:56 -0400
Subject: Re: [PATCH 0/2] ar9170-fw: Roll-your-own toolchain
From: Johannes Berg <johannes@sipsolutions.net>
To: Jan Kiszka <jan.kiszka@web.de>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	otus-devel@lists.madwifi-project.org,
	linux-wireless@vger.kernel.org
In-Reply-To: <4A2AA6BC.5040004@web.de>
References: <4A2AA395.3060406@web.de>
	 <1244308808.15640.4.camel@johannes.local>  <4A2AA6BC.5040004@web.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-BR3Vu7lGs6OGVrdZfAjW"
Date: Sat, 06 Jun 2009 19:28:53 +0200
Message-Id: <1244309333.17485.0.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-BR3Vu7lGs6OGVrdZfAjW
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-06-06 at 19:26 +0200, Jan Kiszka wrote:

> But does you device enter an endless reset loop?
>=20
> [ 5337.468082] usb 2-2: new high speed USB device using ehci_hcd and addr=
ess 30
> [ 5337.648024] usb 2-2: New USB device found, idVendor=3D07d1, idProduct=
=3D3c10
> [ 5337.648032] usb 2-2: New USB device strings: Mfr=3D16, Product=3D32, S=
erialNumber=3D48
> [ 5337.648038] usb 2-2: Product: USB2.0 WLAN
> [ 5337.648042] usb 2-2: Manufacturer: ATHER
> [ 5337.648046] usb 2-2: SerialNumber: 12345
> [ 5337.648235] usb 2-2: configuration #1 chosen from 1 choice
> [ 5337.764060] usb 2-2: reset high speed USB device using ehci_hcd and ad=
dress 30
> [ 5338.940054] usb 2-2: firmware: requesting ar9170.fw
> [ 5340.552081] usb 2-2: device is in a bad state. please reconnect it!
> [ 5341.552118] ar9170usb: probe of 2-2:1.0 failed with error -110
> [ 5341.556838] usb 2-2: USB disconnect, address 30
> [ 5341.800076] usb 2-2: new high speed USB device using ehci_hcd and addr=
ess 31
> ...

Yes. With the AP firmware, that is. I don't care about that firmware at
all.

johannes

--=-BR3Vu7lGs6OGVrdZfAjW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKKqdSAAoJEODzc/N7+Qmau2wP/jybgOYUjEaRr/XtoLCPWXXH
bJV1fKESZFreXOWhzx6MQrQmrm8j4S2g/4Z7sYfuOk08nqbUcWHfn+3vDyAmgCXr
LPhIVstqptsrt9J0CmMXw5OQ2EUEXiVM5BYeWNBZ7SkCqiyc0qiS2unK6nPuWxoH
KFpA5Q518aVMJaCbv033tFGJrqKcluGVjM9s2KVGEZPTFECv98Xc4DDuHMpNbkJo
+HWffuGr7eqPTqgRCA7dF5XYEHbToAL/9O9SJ4xLTBtRW0QLK5hZ9szPocx4Bd4N
BFU9Gb5Z4PFEeWbdOmUYYbPI8SPOqhdNpxEIhq9UHcHHeZJfd6rmTsepYApo5QDf
7/o9/UadibwLGv2nc7BLiPdGXPYYDU41GmNFLI0glqGLSQu3uXXzAhSPT6v1qUcg
7+XTQy0PeZVfi6ojA/gVon9xupWe0dBRl0XMjl4mbkvN+IWqf4whw6nHOaRRSzcK
GjxVyUDbdEGiMC0oX0PcCSxWmO0n37IyWyXIMB1t7zzq8WV62Nox4RQoPdKOQh+w
mK9hWo1Pycg9O09tIPQfdBvlhKl+asLp/YOCObgT3FbkX7UzG1+Wn02usBq/3bW5
z4hE4bFDvzeqVzMiEGcz5DIVnQ2D82Z1IPMi9S42MfAd/TZm5nXtJUBEEVc4TPK0
iCfzW8u/zMcu2WxudbAs
=GUvO
-----END PGP SIGNATURE-----

--=-BR3Vu7lGs6OGVrdZfAjW--

