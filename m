Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:61622 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753045AbaCJPJX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Mar 2014 11:09:23 -0400
Message-ID: <531DD589.1090109@rempel-privat.de> (sfid-20140310_160927_218085_A8C70167)
Date: Mon, 10 Mar 2014 16:08:57 +0100
From: Oleksij Rempel <linux@rempel-privat.de>
MIME-Version: 1.0
To: Sujith Manoharan <sujith@msujith.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>
Subject: Re: [PATCH 00/23] ath9k|ath9k_htc: move dups to common-beacon
References: <1393704966-13985-1-git-send-email-linux@rempel-privat.de>	<21266.37896.937680.416439@gargle.gargle.HOWL>	<5312DD46.3030800@rempel-privat.de>	<21266.58035.719712.344551@gargle.gargle.HOWL>	<20140306184235.GA7788@tuxdriver.com>	<5319978F.6060803@rempel-privat.de> <21273.40172.734118.220513@gargle.gargle.HOWL>
In-Reply-To: <21273.40172.734118.220513@gargle.gargle.HOWL>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Jl97I2O5Kkm2lEXciI8EsU5M9uqtLfTuw"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Jl97I2O5Kkm2lEXciI8EsU5M9uqtLfTuw
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Am 07.03.2014 11:18, schrieb Sujith Manoharan:
> Oleksij Rempel wrote:
>> Last response was about initvals, my patch set affect only beacon code=
=2E
>> Since i don't plan to rewrite ath9k_htc from scratch, i would assume i=
t
>> will be better to continue this periodic clean work.
>=20
> I didn't review the patches, but someone else needs to make sure that
> nothing is broken in ath9k.

I use this code one week ind STA mode. But if you need more directed
alternate testing, who is good candidate for this work?

--=20
Regards,
Oleksij


--Jl97I2O5Kkm2lEXciI8EsU5M9uqtLfTuw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlMd1Y0ACgkQHwImuRkmbWmGKAEAjXJgBPSaDoA6jc7PvSbo9iO5
3FJN5OD73EbaJav21gIA/A+yi11EdRXEeB6DSv/+ZyahO0Gr4t+DRMHPRdcEiWlJ
=3WrD
-----END PGP SIGNATURE-----

--Jl97I2O5Kkm2lEXciI8EsU5M9uqtLfTuw--
