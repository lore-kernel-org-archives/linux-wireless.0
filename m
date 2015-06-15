Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:61708 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754617AbbFOSzr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Jun 2015 14:55:47 -0400
Message-ID: <557F1FA7.5060802@rempel-privat.de> (sfid-20150615_205550_829704_67EB48E2)
Date: Mon, 15 Jun 2015 20:55:35 +0200
From: Oleksij Rempel <linux@rempel-privat.de>
MIME-Version: 1.0
To: Julian Calaby <julian.calaby@gmail.com>
CC: ath9k-devel@qca.qualcomm.com, kvalo@codeaurora.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath9k_htc: introduce support for different fw versions
References: <1434298342-1620-1-git-send-email-linux@rempel-privat.de> <CAGRGNgUWJ-LDgdxe1TJw2YOroMKaYDj3ehUu7j_zoqX17BxbjQ@mail.gmail.com>
In-Reply-To: <CAGRGNgUWJ-LDgdxe1TJw2YOroMKaYDj3ehUu7j_zoqX17BxbjQ@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="I2GUXLHBGeqxJKoAabjrEckLqmSQDomR5"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--I2GUXLHBGeqxJKoAabjrEckLqmSQDomR5
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Am 15.06.2015 um 01:27 schrieb Julian Calaby:
> Hi Oleksij,
>=20
> On Mon, Jun 15, 2015 at 2:12 AM, Oleksij Rempel <linux@rempel-privat.de=
> wrote:
>> Current kernel support only one fw name with theoretically only one
>> fw version. By replacing fw with other version we will break compatibi=
lity
>> with older kernels.
>>
>> To avoid this kind of regression this patch will reuse fw version mode=
l
>> from iwlwifi driver.
>>
>> Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
>> ---
>>  drivers/net/wireless/ath/ath9k/hif_usb.c      | 102 +++++++++++++++++=
+++------
>>  drivers/net/wireless/ath/ath9k/hif_usb.h      |  13 +++-
>>  drivers/net/wireless/ath/ath9k/htc_drv_init.c |   4 +
>>  3 files changed, 95 insertions(+), 24 deletions(-)
>>
>> diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wi=
reless/ath/ath9k/hif_usb.c
>> index 10c02f5..18407f2 100644
>> --- a/drivers/net/wireless/ath/ath9k/hif_usb.c
>> +++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
>> @@ -17,10 +17,6 @@
>>  #include <asm/unaligned.h>
>>  #include "htc.h"
>>
>> -/* identify firmware images */
>> -#define FIRMWARE_AR7010_1_1     "htc_7010.fw"
>> -#define FIRMWARE_AR9271         "htc_9271.fw"
>> -
>>  MODULE_FIRMWARE(FIRMWARE_AR7010_1_1);
>>  MODULE_FIRMWARE(FIRMWARE_AR9271);
>=20
> Shouldn't you declare the versioned firmware names here too?

Thank you.


--=20
Regards,
Oleksij


--I2GUXLHBGeqxJKoAabjrEckLqmSQDomR5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iF4EAREIAAYFAlV/H6cACgkQHwImuRkmbWlhrQD+ICNLtcqcYEpwLP4lUM1tXk0n
ziLzLxjLuPSGx8N8s68A/10sagfrPBc0696tN1EYPV/fW4GSHeLOZOrIgiShiEHx
=ZNd7
-----END PGP SIGNATURE-----

--I2GUXLHBGeqxJKoAabjrEckLqmSQDomR5--
