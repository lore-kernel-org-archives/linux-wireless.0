Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:51779 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754164AbbIWQnL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Sep 2015 12:43:11 -0400
Subject: Re: [PATCH] ath9k_htc: use ether_addr_copy() instead of memcpy()
To: Sujith Manoharan <sujith@msujith.org>
References: <87lhbylifx.fsf@kamboji.qca.qualcomm.com>
 <1442931866-17115-1-git-send-email-linux@rempel-privat.de>
 <22018.42528.871404.504088@gargle.gargle.HOWL>
Cc: kvalo@codeaurora.org, ath9k-devel@qca.qualcomm.com,
	linux-wireless@vger.kernel.org
From: Oleksij Rempel <linux@rempel-privat.de>
Message-ID: <5602D690.7000806@rempel-privat.de> (sfid-20150923_184317_700581_C756FF40)
Date: Wed, 23 Sep 2015 18:42:56 +0200
MIME-Version: 1.0
In-Reply-To: <22018.42528.871404.504088@gargle.gargle.HOWL>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="otMsrEfS3ofs8iPkbRalkmS5xDHNwSv4e"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--otMsrEfS3ofs8iPkbRalkmS5xDHNwSv4e
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Am 23.09.2015 um 15:16 schrieb Sujith Manoharan:
> Oleksij Rempel wrote:
>> Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
>> ---
>>  drivers/net/wireless/ath/ath9k/htc_drv_init.c |  2 +-
>>  drivers/net/wireless/ath/ath9k/htc_drv_main.c | 24 ++++++++++++------=
------
>>  2 files changed, 13 insertions(+), 13 deletions(-)
>=20
> Both the arguments for ether_addr_copy() need to be
> aligned. Is this the case for all the replacements in
> this patch ?
>=20
> Sujith
>=20

hm... you right. Kvalo, please drop this patch.

--=20
Regards,
Oleksij


--otMsrEfS3ofs8iPkbRalkmS5xDHNwSv4e
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iF4EAREIAAYFAlYC1pcACgkQHwImuRkmbWmbhgD/SHmvMn5EMuA4dseizLZ/pheQ
AtecQLtGMEV3LY5HrboA/Rad/6Z5BUvvsGwbpOTXenfLC1qTjLGX2q02hexvtwhr
=46Jp
-----END PGP SIGNATURE-----

--otMsrEfS3ofs8iPkbRalkmS5xDHNwSv4e--
