Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:59331 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753059AbbIRJvE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Sep 2015 05:51:04 -0400
Subject: Re: [PATCH v4] ath9k_htc: introduce support for different fw versions
To: Kalle Valo <kvalo@codeaurora.org>
References: <1441537741-11846-1-git-send-email-linux@rempel-privat.de>
 <87fv2crx5a.fsf@kamboji.qca.qualcomm.com>
Cc: ath9k-devel@qca.qualcomm.com, linux-wireless@vger.kernel.org
From: Oleksij Rempel <linux@rempel-privat.de>
Message-ID: <55FBDE7A.9020109@rempel-privat.de> (sfid-20150918_115113_007181_1569A8F7)
Date: Fri, 18 Sep 2015 11:50:50 +0200
MIME-Version: 1.0
In-Reply-To: <87fv2crx5a.fsf@kamboji.qca.qualcomm.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="aG0quLCh8ACbV3xE0OOhmXuN8A7NioKnB"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--aG0quLCh8ACbV3xE0OOhmXuN8A7NioKnB
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Am 18.09.2015 um 09:42 schrieb Kalle Valo:
> Oleksij Rempel <linux@rempel-privat.de> writes:
>=20
>> Current kernel support only one fw name with theoretically only one
>> fw version located in =E2=80=9Cfirmware/htc_[9271|7010].fw=E2=80=9D. W=
hich is ok so far we
>> have only one fw version (1.3). After we realised new fw 1.4, we faced=

>> compatibility problem which was decided to solve by firmware name and
>> location:
>> - new firmware is located now in
>> 	firmware/ath9k_htc/htc_[9271|7010]-1.4.0.fw
>> - old version 1.3 should be on old place, so old kernel have no issues=

>> 	with it.
>> - new kernels including this patch should be able to try different
>> 	supported (min..max) fw version.
>> - new kernel should be able to support old fw location too. At least f=
or
>> 	now.
>>
>> At same time this patch will add new module option which should allow =
user
>> to play with development  fw version without replacing stable one. If =
user
>> will set =E2=80=9Cath9k_htc use_dev_fw=3D1=E2=80=9D module will try to=
 find
>> firmware/ath9k_htc/htc_[9271|7010]-1.dev.0.fw first and if it fails, u=
se
>> stable version: for example...1.4.0.fw.
>>
>> Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
>=20
> Thanks, applied manually. You forgot to CC linux-wireless and hence
> patchwork didn't see this.
>=20
> In the future please add a changelog when sending new versions of a
> patch.
>=20

ok,
thank you!

--=20
Regards,
Oleksij


--aG0quLCh8ACbV3xE0OOhmXuN8A7NioKnB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iF4EAREIAAYFAlX73n4ACgkQHwImuRkmbWmS7QD/ffNWM6ddQmihd8XqDuW3t9Nl
3cGsYpXO6lgkzaFDr6IBAJeFp7NSTA+3l8Vk/8jOM5OD4L44sSda/9pMqaEZtzdN
=CnX/
-----END PGP SIGNATURE-----

--aG0quLCh8ACbV3xE0OOhmXuN8A7NioKnB--
