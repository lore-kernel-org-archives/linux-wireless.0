Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:49767 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753223AbbC1Nys (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Mar 2015 09:54:48 -0400
Message-ID: <5516B29E.3030705@rempel-privat.de> (sfid-20150328_145451_803221_24D8E8B9)
Date: Sat, 28 Mar 2015 14:54:38 +0100
From: Oleksij Rempel <linux@rempel-privat.de>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org, kvalo@codeaurora.org,
	ath9k-devel@lists.ath9k.org
Subject: Re: [PATCH v3 00/18] reduce some of ath9k_htc performance problems
References: <1427049003-8443-1-git-send-email-linux@rempel-privat.de>
In-Reply-To: <1427049003-8443-1-git-send-email-linux@rempel-privat.de>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="s3k4BIQJOiUrNoHtwcToMiasm05UNVLRL"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--s3k4BIQJOiUrNoHtwcToMiasm05UNVLRL
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hello all,
Any updates here?

Am 22.03.2015 um 19:29 schrieb Oleksij Rempel:
> This patchset adds new WMI_RMW handler to reduce some of usb related
> performance problems.
>=20
> Oleksij Rempel (18):
>   ath9k_htc: add new WMI_REG_RMW_CMDID command
>   ath9k: ar9271_hw_pa_cal - use defs instead of magin numbers
>   ath9k: ar9271_hw_pa_cal: use proper makroses.
>   ath9k: ar9271_hw_pa_cal: use RMW buffer
>   ath9k: add multi_read to be compatible with ath9k_htc
>   ath9k: add new function ath9k_hw_read_array
>   ath9k: ar9271_hw_pa_cal: use REG_READ_ARRAY
>   ath9k: use one shot read in ath9k_hw_update_mibstats
>   ath9k: ath9k_hw_loadnf: use REG_RMW
>   ath9k: write buffer related optimisation in ar5008_hw_set_channel_reg=
s
>   ath9k: ath9k_hw_set_4k_power_cal_tabl: use rmw buffer
>   ath9k: use rmw buffer in ath9k_hw_set_operating_mode and
>     ath9k_hw_reset
>   ath9k: ath9k_hw_4k_set_board_values: use rmw buffer
>   ath9k: ath9k_hw_analog_shift_rmw: use REG_RMW
>   ath9k: ath9k_hw_4k_set_board_values: use rmw buffer
>   ath9k: use REG_RMW and rmw buffer in ath9k_hw_4k_set_gain
>   ath9k: use REG_RMW and rmw buffer in ath9k_hw_4k_set_board_values
>   ath9k: use REG_RMW and rmw buffer in ath9k_hw_def_set_gain
>=20
>  drivers/net/wireless/ath/ath.h                |   3 +
>  drivers/net/wireless/ath/ath9k/ani.c          |  20 +++-
>  drivers/net/wireless/ath/ath9k/ar5008_phy.c   |   5 +-
>  drivers/net/wireless/ath/ath9k/ar9002_calib.c |  77 +++++++-------
>  drivers/net/wireless/ath/ath9k/calib.c        |  19 ++--
>  drivers/net/wireless/ath/ath9k/eeprom.c       |   7 +-
>  drivers/net/wireless/ath/ath9k/eeprom_4k.c    |  36 ++++---
>  drivers/net/wireless/ath/ath9k/eeprom_def.c   |  34 +++---
>  drivers/net/wireless/ath/ath9k/htc.h          |   5 +
>  drivers/net/wireless/ath/ath9k/htc_drv_init.c | 142 ++++++++++++++++++=
++++++--
>  drivers/net/wireless/ath/ath9k/hw.c           |  34 ++++++
>  drivers/net/wireless/ath/ath9k/hw.h           |  15 +++
>  drivers/net/wireless/ath/ath9k/init.c         |  11 ++
>  drivers/net/wireless/ath/ath9k/wmi.c          |   3 +
>  drivers/net/wireless/ath/ath9k/wmi.h          |  16 +++
>  15 files changed, 324 insertions(+), 103 deletions(-)
>=20


--=20
Regards,
Oleksij


--s3k4BIQJOiUrNoHtwcToMiasm05UNVLRL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iF4EAREIAAYFAlUWsqMACgkQHwImuRkmbWn6sAD/V+qo1JlM/oC3mw8PurjaMoje
qhWwTZ+uRTDy+Wlj8h0A/iwqnvuX9733hb1XsdE6kr3DkvW8pR+cv/q8g6TuUTf8
=yMFR
-----END PGP SIGNATURE-----

--s3k4BIQJOiUrNoHtwcToMiasm05UNVLRL--
