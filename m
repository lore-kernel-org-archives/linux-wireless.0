Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:59678 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750820AbcDMQpU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Apr 2016 12:45:20 -0400
Subject: Re: [PATCH] ath9k: ar5008_hw_cmn_spur_mitigate: add missing mask_m &
 mask_p initialisation
To: Kalle Valo <kvalo@codeaurora.org>
References: <120e427452ad7e93f17828e8bba4b043@openmailbox.org>
 <1460482664-21086-1-git-send-email-linux@rempel-privat.de>
 <878u0hzvz0.fsf@purkki.adurom.net> <874mb5zvt0.fsf@purkki.adurom.net>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	lkml2017@openmailbox.org
From: Oleksij Rempel <linux@rempel-privat.de>
Message-ID: <570E778E.6090104@rempel-privat.de> (sfid-20160413_184523_249554_9EBC2E6B)
Date: Wed, 13 Apr 2016 18:45:02 +0200
MIME-Version: 1.0
In-Reply-To: <874mb5zvt0.fsf@purkki.adurom.net>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="aiFL43sOVbaDFA5ajAKEhj9G8bJNievhU"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--aiFL43sOVbaDFA5ajAKEhj9G8bJNievhU
Content-Type: multipart/mixed; boundary="fvGrAlXAtqqqDrouWqNtSOGxVIfhC5Mh7"
From: Oleksij Rempel <linux@rempel-privat.de>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
 lkml2017@openmailbox.org
Message-ID: <570E778E.6090104@rempel-privat.de>
Subject: Re: [PATCH] ath9k: ar5008_hw_cmn_spur_mitigate: add missing mask_m &
 mask_p initialisation
References: <120e427452ad7e93f17828e8bba4b043@openmailbox.org>
 <1460482664-21086-1-git-send-email-linux@rempel-privat.de>
 <878u0hzvz0.fsf@purkki.adurom.net> <874mb5zvt0.fsf@purkki.adurom.net>
In-Reply-To: <874mb5zvt0.fsf@purkki.adurom.net>

--fvGrAlXAtqqqDrouWqNtSOGxVIfhC5Mh7
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Am 13.04.2016 um 11:45 schrieb Kalle Valo:
> Kalle Valo <kvalo@codeaurora.org> writes:
>=20
>> Oleksij Rempel <linux@rempel-privat.de> writes:
>>
>>> by moving common code to ar5008_hw_cmn_spur_mitigate i forgot to move=

>>> mask_m & mask_p initialisation. This coused a performance regression
>>> on ar9281.
>>>
>>> Fixes: f911085ffa88 ("ath9k: split ar5008_hw_spur_mitigate and reuse =
common code in ar9002_hw_spur_mitigate.")
>>> Reported-by: Gustav Frederiksen <lkml2017@openmailbox.org>
>>> Tested-by: Gustav Frederiksen <lkml2017@openmailbox.org>
>>> Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
>>
>> If no objections I'm planning to send this to 4.6.
>=20
> Should we also CC stable (4.2+)? I can add that before I commit the
> patch.
>=20

Yes, please.
Thank you.

--=20
Regards,
Oleksij


--fvGrAlXAtqqqDrouWqNtSOGxVIfhC5Mh7--

--aiFL43sOVbaDFA5ajAKEhj9G8bJNievhU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iF4EAREIAAYFAlcOd5QACgkQHwImuRkmbWkycgD/SCAfOy2fnf5Sm2lfiChHtk12
L1W6oOkPfKZTHCTSmvkA/RXrWtHx/B8RgR3i4eTDlCNYSduonMztdjD/u8kxHll0
=y8dm
-----END PGP SIGNATURE-----

--aiFL43sOVbaDFA5ajAKEhj9G8bJNievhU--
