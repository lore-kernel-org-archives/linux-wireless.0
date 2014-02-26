Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:50972 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751287AbaBZIo0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Feb 2014 03:44:26 -0500
Received: from [192.168.1.221] ([93.218.100.117]) by mail.gmx.com (mrgmx103)
 with ESMTPSA (Nemesis) id 0Lk81O-1WpzB343J4-00c7IQ for
 <linux-wireless@vger.kernel.org>; Wed, 26 Feb 2014 09:44:24 +0100
Message-ID: <530DA962.4050706@rempel-privat.de> (sfid-20140226_094429_245074_23EA90DF)
Date: Wed, 26 Feb 2014 09:44:18 +0100
From: Oleksij Rempel <linux@rempel-privat.de>
MIME-Version: 1.0
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ath9k-devel@lists.ath9k.org
CC: Oleksij Rempel <linux@rempel-privat.de>,
	Sujith Manoharan <sujith@msujith.org>
Subject: Re: [PATCH 0/7] ath9k|ath9k_htc: remove code dups
References: <1393336136-31069-1-git-send-email-linux@rempel-privat.de>
In-Reply-To: <1393336136-31069-1-git-send-email-linux@rempel-privat.de>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="GEiqMPV1C2TkfLfe6PSWxEAujutBWGQXe"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--GEiqMPV1C2TkfLfe6PSWxEAujutBWGQXe
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi Sujith,

i need you ACK btw NACK :)

Am 25.02.2014 14:48, schrieb Oleksij Rempel:
> ath9k code moved to common-init.c and then reused in ath9k_htc.
>=20
> Oleksij Rempel (7):
>   ath9k: move ath9k_init_channels_rates to common-init
>   ath9k_htc: use ath9k_cmn_init_channels_rates
>   ath9k: move setup_ht_cap to common-init
>   ath9k_htc: use ath9k_cmn_setup_ht_cap
>   ath9k-common: set maxstream=3D1 for ar9271
>   ath9k: move ath9k_reload_chainmask_settings to common
>   ath9k_htc: use ath9k_cmn_reload_chainmask
>=20
>  drivers/net/wireless/ath/ath.h                |   1 +
>  drivers/net/wireless/ath/ath9k/Makefile       |   3 +-
>  drivers/net/wireless/ath/ath9k/ath9k.h        |   1 -
>  drivers/net/wireless/ath/ath9k/beacon.c       |   2 +-
>  drivers/net/wireless/ath/ath9k/common-init.c  | 244 ++++++++++++++++++=
++++++++
>  drivers/net/wireless/ath/ath9k/common-init.h  |  20 +++
>  drivers/net/wireless/ath/ath9k/common.h       |   2 +
>  drivers/net/wireless/ath/ath9k/htc.h          |   1 -
>  drivers/net/wireless/ath/ath9k/htc_drv_init.c | 176 +-----------------=
-
>  drivers/net/wireless/ath/ath9k/init.c         | 230 +-----------------=
------
>  drivers/net/wireless/ath/ath9k/main.c         |   2 +-
>  drivers/net/wireless/ath/ath9k/xmit.c         |   3 +-
>  12 files changed, 286 insertions(+), 399 deletions(-)
>  create mode 100644 drivers/net/wireless/ath/ath9k/common-init.c
>  create mode 100644 drivers/net/wireless/ath/ath9k/common-init.h
>

--=20
Regards,
Oleksij


--GEiqMPV1C2TkfLfe6PSWxEAujutBWGQXe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlMNqWIACgkQHwImuRkmbWn8hAD+Knp/OSM30YCzA8Ct77cVw4uo
VbeLgaYkNyxRzX0EP1AA/R+QDiKBfUnu8iv0esXyOsKtx/JEfqNEqGwmbc3iMdGS
=2dj7
-----END PGP SIGNATURE-----

--GEiqMPV1C2TkfLfe6PSWxEAujutBWGQXe--
