Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:51478 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750764AbaESWAj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 May 2014 18:00:39 -0400
Message-ID: <537A7EEA.7040009@rempel-privat.de> (sfid-20140520_000042_823903_1969F9B8)
Date: Tue, 20 May 2014 00:00:10 +0200
From: Oleksij Rempel <linux@rempel-privat.de>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net,
	QCA ath9k Development <ath9k-devel@qca.qualcomm.com>
Subject: Re: [ath9k-devel] [PATCH] ath9k_htc: use 'struct ath_htc_rx_status
 *' in call to ath9k_htc_err_stat_rx
References: <1400533670-23340-1-git-send-email-linville@tuxdriver.com> <537A778A.5050205@rempel-privat.de> <20140519214146.GM7650@tuxdriver.com>
In-Reply-To: <20140519214146.GM7650@tuxdriver.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="cqqnh2exuEJ6W2aKT8RimLi1Hd4fVRbrH"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--cqqnh2exuEJ6W2aKT8RimLi1Hd4fVRbrH
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Am 19.05.2014 23:41, schrieb John W. Linville:
> On Mon, May 19, 2014 at 11:28:42PM +0200, Oleksij Rempel wrote:
>> Am 19.05.2014 23:07, schrieb John W. Linville:
>>>   CC [M]  drivers/net/wireless/ath/ath9k/htc_drv_txrx.o
>>> drivers/net/wireless/ath/ath9k/htc_drv_txrx.c: In function =E2=80=98a=
th9k_rx_prepare=E2=80=99:
>>> drivers/net/wireless/ath/ath9k/htc_drv_txrx.c:1006:2: warning: passin=
g argument 2 of =E2=80=98ath9k_htc_err_stat_rx=E2=80=99 from incompatible=
 pointer type [enabled by default]
>>>   ath9k_htc_err_stat_rx(priv, &rx_stats);
>>>   ^
>>> In file included from drivers/net/wireless/ath/ath9k/htc_drv_txrx.c:1=
7:0:
>>> drivers/net/wireless/ath/ath9k/htc.h:380:20: note: expected =E2=80=98=
struct ath_htc_rx_status *=E2=80=99 but argument is of type =E2=80=98stru=
ct ath_rx_status *=E2=80=99
>>>  static inline void ath9k_htc_err_stat_rx(struct ath9k_htc_priv *priv=
,
>>>
>>> Signed-off-by: John W. Linville <linville@tuxdriver.com>
>>> ---
>>> Compile-test only...seems reasonable?
>>
>> Hm... that is incorrect. Some missing patch?
>> "[PATCH 06/10] ath9k & ath9k_htc: move ath_rx_stats to cmn" did correc=
t
>> change.
>> your patch will brake it.
>=20
> The patch you mention is in wireless-next and wireless-testing.
> The warning only shows-up in my wireless-testing build, although the
> configs are slightly different.
>=20
> Would you be interested in tracking down the problem?

Ok, thank you for the tip, i found it. Will send patch ASAP.


--=20
Regards,
Oleksij


--cqqnh2exuEJ6W2aKT8RimLi1Hd4fVRbrH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlN6fvAACgkQHwImuRkmbWnB7AD/YMQz/xRuCfN/KTPxEKimRA45
Pfvt7FWrir5YKroc0m0A/iV0QcMcXBGPgHOJr65j+zDsdbKAPwWLgobv3T8mn+HM
=+nDY
-----END PGP SIGNATURE-----

--cqqnh2exuEJ6W2aKT8RimLi1Hd4fVRbrH--
