Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54132 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753121AbaA0AtE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Jan 2014 19:49:04 -0500
Message-ID: <1390783732.2735.85.camel@deadeye.wl.decadent.org.uk> (sfid-20140127_014927_047297_139E4853)
Subject: Re: [FIRMWARE PATCH] rtlwifi: Add firmware for rtl8821ae
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: David Woodhouse <dwmw2@infradead.org>,
	linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>
Date: Mon, 27 Jan 2014 00:48:52 +0000
In-Reply-To: <20140123163807.GA16360@kroah.com>
References: <20140123163807.GA16360@kroah.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-/+pcwKPxp/cx5Y7t1tkS"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-/+pcwKPxp/cx5Y7t1tkS
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2014-01-23 at 08:38 -0800, Greg Kroah-Hartman wrote:
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>=20
> This firmware is for a driver for the Realtek 8821AE PCI WIFI device.
> It came from a tarball from Realtek named
> wifi_driver_8821ae_0018.1129.2013.tar.gz and is allowed to be
> distributed under the LICENCE.rtlwifi_firmware.txt license.
>=20
> Cc: Larry Finger <Larry.Finger@lwfinger.net>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  WHENCE                  |   9 +++++++++
>  rtlwifi/rtl8821aefw.bin | Bin 0 -> 29198 bytes
>  2 files changed, 9 insertions(+)
>  create mode 100644 rtlwifi/rtl8821aefw.bin

Applid, but:

> diff --git a/WHENCE b/WHENCE
> index 00767b179a68..16ab53e2ba75 100644
> --- a/WHENCE
> +++ b/WHENCE
> @@ -1962,6 +1962,15 @@ Licence: Redistributable. See LICENCE.rtlwifi_firm=
ware.txt for details.
> =20
>  ------------------------------------------------------------------------=
--
> =20
> +Driver: rtl8821ae - Realtek 802.11n WLAN driver for RTL8821AE
> +
> +Info: Taken from Realtek version wifi_driver_8821ae_0018.1129.2013.tar.g=
z
> +File: rtlwifi/rtl8821ae.bin
[...]

This didn't match the actual filename.  I fixed it up this time, but
please take care to make this match.  (Really I should script a check
for this.)

Ben.

--=20
Ben Hutchings
If at first you don't succeed, you're doing about average.

--=-/+pcwKPxp/cx5Y7t1tkS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIVAwUAUuWs9Oe/yOyVhhEJAQor3RAAnacmTwvrUnwVt8ci7qIMA8Ke6oXu6dB9
mLGscWda74eEhcbChGp8KP+nl5qKdHS0wrNhbp+MOnrR0SBMCSJBx45bg25V0K4a
1Y5Bzu629OkPa+HxBsU3Y/b7tHg5uqTnsa2D+q3mZf9F9KPNDeTYcPWGXmmKjht8
7ZWLjg6NjF3em/ahs/K4bXgFKUAFFVyRyKhMso8qfS/lM6dKjfysNR9VDNTEGmbU
C5S4tJ+lXnE8GSb1J6buk73Y7bcCmTDwarl9/ZNsNdPRgbpRYnk6TCIWBuVcay1N
9d+sVg7tGgKB7V1KFg/9K8Ni0tw4LPQ8GqxxcaZfimEhXHEoD45jSVeMAHGd9Ir1
DUtF4q9mp3u/WZHTJEE5pASsgk1GIMLjtHwYfBItu723qpoZU1yOvIEMlUC80ZCA
gvdjK6Kv509oehaiS4dDJUsJWVf9LQ6qfjU0z1qSPqcuA6fNLSRJWnz0ozjGqAar
y59KHJXSFdkpk7dPgoKfrhPn8Y4AXAXvsvRSNBDrbLd1VI0wyQgHl2lUATPiQijK
Z3FySWqiwu7mOHXZZEpOvI12xVIehVg4PxD4bLjRAHMkUr/3qqQsxcrf/MKe5zh5
V+ZtVuHGLYbx+DRh+TevWbx04pGueg/4BhrHjqaZs5OOQKYhq2D6r+A0E4v6HLrN
Z7c3CREgrak=
=PsLi
-----END PGP SIGNATURE-----

--=-/+pcwKPxp/cx5Y7t1tkS--
