Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:40632 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753880AbaBQXFo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Feb 2014 18:05:44 -0500
Message-ID: <1392678335.10088.1.camel@deadeye.wl.decadent.org.uk> (sfid-20140218_000547_973793_B70053ED)
Subject: Re: linux-firmware: pull-request TI wireless firmware 2014-02-10
From: Ben Hutchings <ben@decadent.org.uk>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 17 Feb 2014 23:05:35 +0000
In-Reply-To: <1392024596-22285-1-git-send-email-arik@wizery.com>
References: <1392024596-22285-1-git-send-email-arik@wizery.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-e9GertaG2a58fBn3yBlp"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-e9GertaG2a58fBn3yBlp
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2014-02-10 at 11:29 +0200, Arik Nemtsov wrote:
> Hey Ben,
>=20
> Here's an updated FW for the Wilink 8 chip. The name change is due to cha=
nges
> in some driver/FW APIs. Sorry for the double send, adding the linux-wirel=
ess
> list now as well.
>=20
> The following changes since commit 4164c23d2e3b4863ca42d72f40dc7cc5d9fb8c=
6c:
>=20
>   rtlwifi: Add firmware for rtl8192ee (2014-02-09 13:26:05 +0000)
>=20
> are available in the git repository at:
>=20
>   git://github.com/TI-OpenLink/firmwares.git master
>=20
> for you to fetch changes up to 7f9cf6ebdedb4776d3c977003b9a7e33537014b2:
>=20
>   wl18xx: add version 3 of the wl18xx firmware (2014-02-10 11:02:23 +0200=
)

Pulled, thanks.

Ben.

> ----------------------------------------------------------------
> Arik Nemtsov (1):
>       wl18xx: add version 3 of the wl18xx firmware
>=20
>  WHENCE                          |   2 ++
>  ti-connectivity/wl18xx-fw-3.bin | Bin 0 -> 673328 bytes
>  2 files changed, 2 insertions(+)
>  create mode 100644 ti-connectivity/wl18xx-fw-3.bin
>=20
> diff --git a/WHENCE b/WHENCE
> index a5c0444..7263c1d 100644
> --- a/WHENCE
> +++ b/WHENCE
> @@ -1835,6 +1835,8 @@ File: ti-connectivity/wl18xx-fw.bin
>  Version: 8.2.0.0.100
>  File: ti-connectivity/wl18xx-fw-2.bin
>  Version: 8.5.0.0.55
> +File: ti-connectivity/wl18xx-fw-3.bin
> +Version: 8.8.0.0.13
>  File: ti-connectivity/wl18xx-conf.bin
>  Version: 6/5
> =20
> diff --git a/ti-connectivity/wl18xx-fw-3.bin b/ti-connectivity/wl18xx-fw-=
3.bin
> new file mode 100644
> index 0000000..3c799a3
> Binary files /dev/null and b/ti-connectivity/wl18xx-fw-3.bin differ

--=20
Ben Hutchings
You can't have everything.  Where would you put it?

--=-e9GertaG2a58fBn3yBlp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUAUwKVv+e/yOyVhhEJAQqbbg//Xjc+yWC/DAzgIV0VxkV+A+sXcacEIg8C
DATJbFKvv0BuaiAlNwkZ7897huiS9S3HRTVgwZ6k8+7Q/3XBksKC08A1YoLi4F0g
g1QPilGBHjhu/8rEjDOzJ/BQuDtdvaunRARLnNNETONGPcLwFfqzVu7VWqYLjlB9
CUvMmxxl1wAO87QvcmxYCHjwlrXmPFOTes+KuRJMwi3h3vYE0cskXzFJsGLz198E
qY1ycfBKn6bl15v/ScD+rPJ06jR4Yk+M3ZvxqRT1hS6omfD+W/UmJHSLZvx0Tx1V
7Gcq4fRco+8hz/uGnPrncs7ifBjILg/69SJy00vF2DM16spwf8WSPZmFAZwQctfJ
n65QA6z92ZvuVk6Sva5hJST2wW6zPE1Y9og3f2D4Myc5LS8qFoRJy1hPbcuuj4l6
crQICbYGpSH8QYIWP/lLHTjKfpszaYrFoq0dmI6kETXZNexfj/eWpe3ZuSd5KYYn
vOBqYQ/+LoZsXzy3/z/dDkPH+V+Zi1h1xi3sBHGuEUWpzD7dw95CXs6e3ypwuvng
6w1323+mbgmB8ZG1lsP6PdkCUt3GYRgNiVMa95KhKrlSytp+S3fNCoodYhAPz7Pf
oYcXKTXbMUaBHxsvxGrQndEii60qRXEGfDgnwHUgzpfnMFn1p6cfZjlGRtxUba3t
ULZHy2lfYYE=
=TxbK
-----END PGP SIGNATURE-----

--=-e9GertaG2a58fBn3yBlp--
