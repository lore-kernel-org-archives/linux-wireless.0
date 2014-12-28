Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:62411 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751344AbaL1MqZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Dec 2014 07:46:25 -0500
Message-ID: <549FFB8F.9010701@rempel-privat.de> (sfid-20141228_134747_666903_0B23969F)
Date: Sun, 28 Dec 2014 13:46:07 +0100
From: Oleksij Rempel <linux@rempel-privat.de>
MIME-Version: 1.0
To: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
	linux-wireless@vger.kernel.org
CC: nbd@openwrt.org, thomas@net.t-labs.tu-berlin.de, adrian@freebsd.org
Subject: Re: [RFC 0/3] add TPC capability for AR9002 based chips
References: <1419689545-26965-1-git-send-email-lorenzo.bianconi83@gmail.com>
In-Reply-To: <1419689545-26965-1-git-send-email-lorenzo.bianconi83@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="CFSNfwaXIqAPXdjLGCSCL7XdPrPRe7ddD"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--CFSNfwaXIqAPXdjLGCSCL7XdPrPRe7ddD
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi, can you please describe some testcases for you patches.

Am 27.12.2014 um 15:12 schrieb Lorenzo Bianconi:
> This patchset adds TPC capability to ath9k for AR9002 based chips
>=20
> *[RFC 1/3]: add TX power per-rate tables to cap TX power in TX descript=
or path
> *[RFC 2/3]: cap per-packet TX power according to TX power per-rate tabl=
es
> *[RFC 3/3]: enable per-packet TPC on AR9002 based chips by default
>=20
> This pachset is based on Adrian Chadd's hints
> (https://www.mail-archive.com/ath9k-devel@lists.ath9k.org/msg10396.html=
)
>=20
> Lorenzo Bianconi (3):
>   ath9k: add power per-rate tables for AR9002 chips
>   ath9k: add TPC to TX path for AR9002 based chips
>   ath9k: enable per-packet TPC on AR9002 based chips
>=20
>  drivers/net/wireless/ath/ath9k/ar5008_phy.c  | 80 ++++++++++++++++++++=
++++++++
>  drivers/net/wireless/ath/ath9k/debug.c       |  5 --
>  drivers/net/wireless/ath/ath9k/eeprom_4k.c   | 14 +++++
>  drivers/net/wireless/ath/ath9k/eeprom_9287.c | 15 ++++++
>  drivers/net/wireless/ath/ath9k/eeprom_def.c  | 14 +++++
>  drivers/net/wireless/ath/ath9k/hw.c          |  3 +-
>  drivers/net/wireless/ath/ath9k/hw.h          |  2 +
>  drivers/net/wireless/ath/ath9k/xmit.c        | 66 +++++++++++++++++++-=
---
>  8 files changed, 181 insertions(+), 18 deletions(-)
>=20


--=20
Regards,
Oleksij


--CFSNfwaXIqAPXdjLGCSCL7XdPrPRe7ddD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iF4EAREIAAYFAlSf+48ACgkQHwImuRkmbWkBIAD7BeOCPzd+tNwhC4+b/2YGvfQL
ee0xkvPItxkqey14zhoA/i/eE9Y8Z/rPBQwGzoCZwJnbdq++CAgQEUzBLl9Lnp82
=hEAk
-----END PGP SIGNATURE-----

--CFSNfwaXIqAPXdjLGCSCL7XdPrPRe7ddD--
