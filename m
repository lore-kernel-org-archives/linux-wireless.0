Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:49388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754027AbcLQJhM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 17 Dec 2016 04:37:12 -0500
Date: Sat, 17 Dec 2016 10:37:05 +0100
From: Sebastian Reichel <sre@kernel.org>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Gery Kahn <geryk@ti.com>, Shahar Lev <shahar@wizery.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pavel Machek <pavel@ucw.cz>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Subject: Re: wl1251 NVS calibration data format
Message-ID: <20161217093705.p64yzumqlu3u5aq7@earth> (sfid-20161217_103732_681068_37F186AA)
References: <201612161201.48356@pali>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="soy4ow6nzax6mq6z"
In-Reply-To: <201612161201.48356@pali>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--soy4ow6nzax6mq6z
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Dec 16, 2016 at 12:01:48PM +0100, Pali Roh=E1r wrote:
> Hi! Do you know format of wl1251 NVS calibration data file?
>=20
> I found that there is tool for changing NVS file for wl1271 and newer=20
> chips (so not for wl1251!) at: https://github.com/gxk/ti-utils
>=20
> And wl1271 has in NVS data already place for MAC address. And in wlcore=
=20
> (for wl1271 and newer) there is really kernel code which is doing=20
> something with MAC address in NVS, see:=20
> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/driv=
ers/net/wireless/ti/wlcore/boot.c#n352
>=20
> So... I would like to know if in wl1251 NVS calibration file is also=20
> some place for MAC address or not.
>=20
> Default wl1251 NVS calibration file is available in linux-firmware:=20
> https://git.kernel.org/cgit/linux/kernel/git/firmware/linux-firmware.git/=
tree/ti-connectivity/wl1251-nvs.bin

Pandora people [0] have a description of the format at [1].

[0] https://pandorawiki.org/WiFi
[1] http://notaz.gp2x.de/misc/pnd/wl1251/nvs_map.txt

-- Sebastian

--soy4ow6nzax6mq6z
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE72YNB0Y/i3JqeVQT2O7X88g7+poFAlhVBykACgkQ2O7X88g7
+pqCkg//UyMm+RLgsUyvQ56U3gS4k8BgKB6gJ1YYXy7B88JxKVWrswYk10RGm3od
6AFrDIkiMD5OHA1XPhw8YD/CAOoLVBFCE0IpAuNe1YUut59mmuESotqZQiy5N1yJ
Lsc/nl9RDLgsiDkwx+QdR4OeIFE2gDOgPT1S2UvZuoBrpZpg2rpHDr7rVkOqXb/C
qmElWRP1+pVhxErZiAKIxlS3fj8wOhOpQs2rxdkxSXwXjHHe5CB5nglRD/gKOUKF
HJS/ZTIZk/U57i6MUqXRbxYZHUQ9Gx4Ru/3WafE0i7rsftxAtAvId0BiYCum+BP0
DcsSWXk+KfmyszUjbOD1lSQg3c0rmcl48voMG2KJ3jjIAvJ4SzgV9jqUQQ6/c2ML
2GZhmUTcEZOlLd4oHZXf3kpyRv7styEpn6DkuAqP2BLRJBXWi5eHXNKH9ByS2a+W
B5FKgp9p3A146K3misyPHZaJTxR3edK+XypmKvH47ETnwcpejB3sJStADcq1IdAr
EFhdpUh1aROrCJLVLRRxRNzYZFVrKisakPaRu0tfLqCDvH0uVb6Isp0qpo9tXewd
7ly7+gpHDZA1NNWzwfph+K5UFjfQ4EpOZ+3BBzi2kPIwPJyR0pyH98j/ZB+q6OHe
EgkuO04Se4budyHBVDfNHpnMd1QTPqMK7tuOhP4JWO9WdFZKfeo=
=FQG3
-----END PGP SIGNATURE-----

--soy4ow6nzax6mq6z--
