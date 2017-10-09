Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:44990 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753921AbdJIQq5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 9 Oct 2017 12:46:57 -0400
Message-ID: <1507567607.2677.124.camel@decadent.org.uk> (sfid-20171009_184709_371020_E98D9D48)
Subject: Re: [PATCH 0/3] linux-firmware: ath10k update 20170918
From: Ben Hutchings <ben@decadent.org.uk>
To: Kalle Valo <kvalo@qca.qualcomm.com>, linux-firmware@kernel.org
Cc: linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Date: Mon, 09 Oct 2017 17:46:47 +0100
In-Reply-To: <1505746857-31938-1-git-send-email-kvalo@qca.qualcomm.com>
References: <1505746857-31938-1-git-send-email-kvalo@qca.qualcomm.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-asNaL9aoDF0/embyOfOG"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-asNaL9aoDF0/embyOfOG
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2017-09-18 at 18:00 +0300, Kalle Valo wrote:
> Few firmware fixes to user reported issues for ath10k, but the other "fix=
"
> being a revert back to older firmware. Also a small board-2.bin update.

I've applied this series, thanks.

Ben.

> Kalle Valo (3):
>   ath10k: QCA6174 hw3.0: update firmware-6.bin to
>     WLAN.RM.4.4.1-00051-QCARMSWP-1
>   ath10k: QCA6174 hw3.0: update board-2.bin
>   Revert "ath10k: QCA988X hw2.0: update firmware to 10.2.4.70.63-2"
>=20
>  WHENCE                                            |   4 +-
>  ath10k/QCA6174/hw3.0/board-2.bin                  | Bin 477060 -> 501748=
 bytes
>  ath10k/QCA6174/hw3.0/firmware-6.bin               | Bin 711408 -> 727776=
 bytes
>  ath10k/QCA6174/hw3.0/notice_ath10k_firmware-6.txt |  97 +++++-----------=
------
>  ath10k/QCA988X/hw2.0/firmware-5.bin               | Bin 249384 -> 248188=
 bytes
>  5 files changed, 25 insertions(+), 76 deletions(-)
>=20
--=20
Ben Hutchings
Humour is the best antidote to reality.


--=-asNaL9aoDF0/embyOfOG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAlnbp/cACgkQ57/I7JWG
EQkmOxAAzmuueUAcOszYNZ0GSkvOsnKDJ9PF0f9P3Cahi9mwCe4kCyjbiCDaji33
I0nDqzTvnZBqFHvWhFwKviIQP81cHIq7ESKVmZSYMqV098k9pcHvLNu50cjgkvB5
gLjbr8pQQ+Iz68P6KSBbF3boDabdJQ6s84DeH4zYx7eb2y7MvDC1idEDTArGcEKU
zFnIOumW9n/Hc0JtO1S6k5lHT8rgJ1z98oV3j3VAC0N7PA4/OwMImOv+urr3ifPz
9M/V9j07IVKJhB93i9Ws39IFQbElg/r/L2IXoLTDblpRk2C9Ts1FwBijbzwnv9yZ
0Q9E7M1FBoDuyhGcUYgJqE42NSsimjOnEvwz59mHoukX13Rsc9BJFyEFyDLQ9CTV
6jEJpXarUwHkleOqamefGoZNjkhWiZob9dgcUs3HBt/0PlouY8GdZbU9wfy8Dwhr
gf0qnEt3BZgYodG7IaupuU/xoq5iznzWP16PfFEClgZXpvw87Ht+ZjsHrUeq0Te1
KKdMnIfXIAmxk194tiiLITnQmPaPOQ1pfYq6LZlc8jalfHHo+NNAuNb1ZBw3CbUq
5yolsSGryfoMIfyS1ZmItti2SzeHYa27PywW6SkPXk9jcuhNEWjfPXvsQevAmf7b
4RgZsCKFHYONLpgy8lLw0CxfUvsne7fxKfFer+6wBUpWyAZAsCs=
=FmEp
-----END PGP SIGNATURE-----

--=-asNaL9aoDF0/embyOfOG--
