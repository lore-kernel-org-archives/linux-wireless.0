Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:54229 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752156AbaAZNlK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Jan 2014 08:41:10 -0500
Received: from [192.168.1.100] ([93.196.93.204]) by mail.gmx.com (mrgmx103)
 with ESMTPSA (Nemesis) id 0Lkfii-1VXGKM2VL2-00aZU4 for
 <linux-wireless@vger.kernel.org>; Sun, 26 Jan 2014 14:41:09 +0100
Message-ID: <52E51061.9090006@rempel-privat.de> (sfid-20140126_144114_143906_7EEE4428)
Date: Sun, 26 Jan 2014 14:40:49 +0100
From: Oleksij Rempel <linux@rempel-privat.de>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	ath9k-devel@lists.ath9k.org
Subject: Re: [PATCH 0/5] eliminate some ath9k_htc code
References: <1390243693-9061-1-git-send-email-linux@rempel-privat.de>
In-Reply-To: <1390243693-9061-1-git-send-email-linux@rempel-privat.de>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="0C3eQ7tVBGnkNU6l4kqarSdml7tuxWR0O"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--0C3eQ7tVBGnkNU6l4kqarSdml7tuxWR0O
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Please do not apply this patch set, it will need some changes.

Am 20.01.2014 19:48, schrieb Oleksij Rempel:
> Ath9k_htc has too match outdated copy/paste from ath9k.
>=20
> This patch set trying to remove some of it and make some function commo=
n
> to both drivers.
>=20
> Oleksij Rempel (5):
>   ath: add last_rssi to ath_common
>   ath9k: move ath9k_process_rssi to common.c
>   ath9k: move ath9k_process_rate to common.c
>   ath9k: move ath9k_rx_accept to common.c
>   ath9k_htc: rework ath9k_rx_prepare and make use of common funcs
>=20
>  drivers/net/wireless/ath/ath.h                |   2 +
>  drivers/net/wireless/ath/ath9k/ath9k.h        |   1 -
>  drivers/net/wireless/ath/ath9k/common.c       | 192 ++++++++++++++++++=
+++++
>  drivers/net/wireless/ath/ath9k/common.h       |  14 ++
>  drivers/net/wireless/ath/ath9k/htc.h          |   1 -
>  drivers/net/wireless/ath/ath9k/htc_drv_init.c |   1 +
>  drivers/net/wireless/ath/ath9k/htc_drv_main.c |   1 +
>  drivers/net/wireless/ath/ath9k/htc_drv_txrx.c | 149 ++++++------------=

>  drivers/net/wireless/ath/ath9k/init.c         |   2 +-
>  drivers/net/wireless/ath/ath9k/mac.h          |   9 +-
>  drivers/net/wireless/ath/ath9k/main.c         |   2 +-
>  drivers/net/wireless/ath/ath9k/recv.c         | 211 ++----------------=
--------
>  12 files changed, 270 insertions(+), 315 deletions(-)
>=20


--=20
Regards,
Oleksij


--0C3eQ7tVBGnkNU6l4kqarSdml7tuxWR0O
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlLlEHEACgkQHwImuRkmbWm5rgD9Gn3PH/kgzlYM9ZPQijkyMwtt
lyyHeVst4yKN6XI1uqEA+wVGP3GIJ587Uv055VO+xCVxKRHyphFtSmTzAG3PAtRT
=1ZJu
-----END PGP SIGNATURE-----

--0C3eQ7tVBGnkNU6l4kqarSdml7tuxWR0O--
