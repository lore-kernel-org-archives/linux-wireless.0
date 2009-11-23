Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59127 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693AbZKWQAl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Nov 2009 11:00:41 -0500
Subject: Re: [PATCH 2.6.32] rfkill: fix miscdev ops
From: Johannes Berg <johannes@sipsolutions.net>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	iwlwifi maling list <ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <1258985555.7236.6.camel@maxim-laptop>
References: <1258968499.3271.5.camel@maxim-laptop>
	 <1258972050.7094.140.camel@johannes.local>
	 <1258973082.3675.0.camel@maxim-laptop>
	 <1258973362.7094.151.camel@johannes.local>
	 <1258985555.7236.6.camel@maxim-laptop>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-gctnGuPyW05OQqwNQDMX"
Date: Mon, 23 Nov 2009 17:00:14 +0100
Message-ID: <1258992014.7094.175.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-gctnGuPyW05OQqwNQDMX
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-11-23 at 16:12 +0200, Maxim Levitsky wrote:

> Not important, however I had seen that iwlwifi now chokes on reload,
> sometimes with this:
>=20
>=20
> [  830.333386] iwl3945: Intel(R) PRO/Wireless 3945ABG/BG Network Connecti=
on driver for Linux, 1.2.26kds
> [  830.333407] iwl3945: Copyright(c) 2003-2009 Intel Corporation
> [  830.333536] iwl3945 0000:06:00.0: PCI INT A -> GSI 19 (level, low) -> =
IRQ 19
> [  830.374979] iwl3945 0000:06:00.0: Tunable channels: 13 802.11bg, 0 802=
.11a channels
> [  830.374995] iwl3945 0000:06:00.0: Detected Intel Wireless WiFi Link 39=
45BG
> [  830.375163] iwl3945 0000:06:00.0: irq 32 for MSI/MSI-X
> [  830.376859] phy0: Selected rate control algorithm 'iwl-3945-rs'
> [  830.427214] iwl3945 0000:06:00.0: firmware: requesting iwlwifi-3945-2.=
ucode
> [  830.526945] iwl3945 0000:06:00.0: loaded firmware version 15.32.2.9
> [  830.544236] CE: hpet increasing min_delta_ns to 15000 nsec
> [  830.575694] iwl3945 0000:06:00.0: BSM uCode verification failed at add=
r 0x00003800+0 (of 900), is 0xa5a5a5a2, s/b 0xf802020

I'd really appreciate if you started separate threads for separate
issues -- this can be in no way related to the fix except maybe that the
fix makes it possible for you to run into this whereas before it'd
crash :)

johannes

--=-gctnGuPyW05OQqwNQDMX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLCrGKAAoJEODzc/N7+QmatksP/A0Az5W/Dnn3KY45+8JhqiaC
dWqS7qKgVh75xMktMXiaYvfVIuTHh6BRnITvhtkZCyhGj80BXXDgy7I2XSZQsGUF
xcEaxfRoRyYFb20ie/nODdz7mthmMv8W3IOufWyVlDHtrbsyodAvX6OjbIY0JkZq
iU3GFysAoGrdwEIWSiypkBaEwGDGczG0v5rv/liXfQ3tdf/8nUE4Fwl81IB2ff30
PNR5gupElX8FPtFMXj+y2Gs4PUf6FIa9xSkeYvk03r8UF1PZCBK2wdE+i4gXtOkZ
ICrjmBSjz0MqW4TqdTPWYxYFTGuNBypwaFS5qmMM0kVWNrCC50txGl1pLbnpTFyX
V05Gm5vZ6jY317HBmCOx1pFWVoswRC5T/corzrdBuoLpJsrsLVAaOB4sTnqgLu8y
p4vbg0XlBnbA7tWHfvJ2G+7LWarE3j7BwM8qiDsvjv9iX629RVqREuPdNzqKTaPy
Sg7s2VNDX4gBBuuQxZCCVY9Z9DapgE6eLHpqmlvpph+LCrFNkJCPif01yy6+j41I
xcsxoJgmmmdvstSQntCE3cERTTtswPqQD8Fd1XkXMMyQ+5+fLynO4LGUlgauyaGf
mxubYad/M83RRyOt0ppzLHhj/iWFhi6A1999sC9jl1CwFXPCwWreNzWA2F38S2zG
88vkqCSqruBhOBps+ONE
=GlFe
-----END PGP SIGNATURE-----

--=-gctnGuPyW05OQqwNQDMX--

