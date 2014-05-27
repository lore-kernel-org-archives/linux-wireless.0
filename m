Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:58054 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752972AbaE0U1H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 May 2014 16:27:07 -0400
Message-ID: <1401222664.2586.8.camel@deadeye.wl.decadent.org.uk> (sfid-20140527_222723_021521_79AE0CAB)
Subject: Re: [PATCH] Adding RSI 91x firmware.
From: Ben Hutchings <ben@decadent.org.uk>
To: Fariya Fatima <fariyaf@gmail.com>
Cc: linux-wireless@vger.kernel.org, linux-firmware@kernel.org
Date: Tue, 27 May 2014 21:31:04 +0100
In-Reply-To: <1398716586-4010-1-git-send-email-fariyaf@gmail.com>
References: <1398716586-4010-1-git-send-email-fariyaf@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-Bi7xyHAytrf7SmovpfNE"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Bi7xyHAytrf7SmovpfNE
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2014-04-29 at 01:53 +0530, Fariya Fatima wrote:
> From: Fariya Fatima <fariyaf@gmail.com>

Sorry for the slow response.

> Signed-off-by: Fariya Fatima <fariyaf@gmail.com>
> ---
>  WHENCE     |   14 ++++++++++++++
>  rsi_91x.fw |  Bin 0 -> 94100 bytes
>  2 files changed, 14 insertions(+), 0 deletions(-)
>  create mode 100644 rsi_91x.fw
>=20
> diff --git a/WHENCE b/WHENCE
> index ca0f30b..c185822 100644
> --- a/WHENCE
> +++ b/WHENCE
> @@ -2413,3 +2413,17 @@ of MERCHANTABILITY or FITNESS FOR A PARTICULAR PUR=
POSE.
> =20
>  ------------------------------------------------------------------------=
--
> =20
> +Driver: rsi -- Redpine Signals Inc 91x driver
> +
> +File: rsi_91x.fw
> +
> +Licence:
> + * Firmware is:
> + *	Derived from proprietary unpublished source code,
> + *	Copyright (C) 2014 Redpine Signals Inc.
> + *
> + *	Permission is hereby granted for the distribution of this firmware
> + *	as part of Linux or other Open Source operating system kernel
> + *	provided this copyright notice is accompanying it.
> +
> +Found in binary form in kernel source.
[...]

I've applied this, but I removed the last two lines here as this
firmware wasn't included in mainline.

Ben.

--=20
Ben Hutchings
A free society is one where it is safe to be unpopular. - Adlai Stevenson

--=-Bi7xyHAytrf7SmovpfNE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUAU4T2Eue/yOyVhhEJAQq8Yw//RSpMzkFR0Ozya/3yZfZXzY/IieYw4b5g
DioMPkVWaI3Evb3sk1sWT4o9bDTVIamkwG4Na5ouhqbA7qIyytJannvjmQDOxVFd
5AZU9PpHLdw7h8R2ln3gB8K0ToAbZBgX6hOdi7kkVDTQHNDWjlS/KJK3Sy0yDv6y
aU9U7SN0IUr/pIf8Qc0xTDz8GVriTYdRSbUt/wYA0kq6Co0hyJlYMKtZ6BfN9dAE
v1Ap2WNIe23USw8yuR4U5MTNFsU/9mOVX3JaF9EKSKjHHavqe9KBnOwwslbswVFE
VL199/zUaCeDB1MJesvwEtLofiIBxGsuD6hrQeRlq3WWtHdt3/tqu/nKfbEndJ6j
PMtviOPd4g4gUv2+21GujMF5eL8Cuy7oJcEfNoOLAxkhA4rdndXIW6fxFIxdl1Wv
lDF9u9+U9GoS50iZPJlrpQFevoV5B9sL6UaRLXs8dM4nRdvrwesdARbtc5Di392J
pa1mlS58xrIlNAtd8CBsEwnQIyaOhV/7vgKa2UUyuDay8+qdC3t/wkYgmIg6bykO
eGW8II1kJ89I7pISxt/U3pNgyq33Zbl5wGi6oSPSIrXvv3G8yBWDzGQ+awJkvnWS
gUNm0V8fcYNAqARrXdsJCFzu8JJXvHrydF4XXyFh+OY1joafR/eJlZf3PZ1D4/br
C2g/XvTLdQ0=
=LCdH
-----END PGP SIGNATURE-----

--=-Bi7xyHAytrf7SmovpfNE--
