Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39302 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751822AbbJTPCu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Oct 2015 11:02:50 -0400
Message-ID: <1445353351.2561.19.camel@decadent.org.uk> (sfid-20151020_170255_532774_1C61EFB9)
Subject: Re: [PATCH] ath10k: add notice.txt references to WHENCE
From: Ben Hutchings <ben@decadent.org.uk>
To: Kalle Valo <kvalo@qca.qualcomm.com>, linux-firmware@kernel.org
Cc: linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Date: Tue, 20 Oct 2015 16:02:31 +0100
In-Reply-To: <1445352802-18789-1-git-send-email-kvalo@qca.qualcomm.com>
References: <1445352802-18789-1-git-send-email-kvalo@qca.qualcomm.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-QHO6M1Iu4VBkzdKCbTc0"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-QHO6M1Iu4VBkzdKCbTc0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2015-10-20 at 17:53 +0300, Kalle Valo wrote:
> This is to make sure that the notice files get automatically included.
>=20
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

While it isn't actually specified here, I expect the File: lines to
refer to the firmware itself. =C2=A0Please put these references underneath
the Licence: fields.

Ben.

> ---
> =C2=A0WHENCE |=C2=A0=C2=A0=C2=A0=C2=A05 +++++
> =C2=A01 file changed, 5 insertions(+)
>=20
> diff --git a/WHENCE b/WHENCE
> index 9b7e8e8526aa..5cc01414e915 100755
> --- a/WHENCE
> +++ b/WHENCE
> @@ -2393,17 +2393,22 @@ Driver: ath10k - Qualcomm Atheros support for QCA=
988x family of chips
> =C2=A0File: ath10k/QCA988X/hw2.0/board.bin
> =C2=A0File: ath10k/QCA988X/hw2.0/firmware-4.bin
> =C2=A0Version: 10.2.4.45
> +File: ath10k/QCA988X/hw2.0/notice_ath10k_firmware-4.txt
> =C2=A0File: ath10k/QCA988X/hw2.0/firmware-5.bin
> =C2=A0Version: 10.2.4.70.9-2
> +File: ath10k/QCA988X/hw2.0/notice_ath10k_firmware-5.txt
> =C2=A0File: ath10k/QCA6174/hw2.1/board.bin
> =C2=A0File: ath10k/QCA6174/hw2.1/firmware-5.bin
> =C2=A0Version: WLAN.RM.1.1-00141
> +File: ath10k/QCA6174/hw2.1/notice_ath10k_firmware-5.txt
> =C2=A0File: ath10k/QCA6174/hw3.0/board.bin
> =C2=A0File: ath10k/QCA6174/hw3.0/firmware-4.bin
> =C2=A0Version: WLAN.RM.2.0-00180-QCARMSWPZ-1
> +File: ath10k/QCA6174/hw3.0/notice_ath10k_firmware-4.txt
> =C2=A0File: ath10k/QCA99X0/hw2.0/board.bin
> =C2=A0File: ath10k/QCA99X0/hw2.0/firmware-5.bin
> =C2=A0Version: 10.4.1.00030-1
> +File: ath10k/QCA99X0/hw2.0/notice_ath10k_firmware-5.txt
> =C2=A0
> =C2=A0Licence: Redistributable. See LICENSE.QualcommAtheros_ath10k for de=
tails
> =C2=A0
--=20
Ben Hutchings
The first rule of tautology club is the first rule of tautology club.
--=-QHO6M1Iu4VBkzdKCbTc0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUAViZXh+e/yOyVhhEJAQo64hAAtSqSxpHDo5hQSeb1SeS4Msy3FTIUyA8m
u9GLLd6FgLgTJPe0gOV2jkvtCRZJR4hutYWnv07FmqeGyLUPudGYtKnDj8gXu8pr
sZ9CqyeSvZaJfEUGguCuWZ6zBcs2dA83/o1xt7XNj+63ZMYrdSIF/lNTEcGWtTPj
4lZlZgKoEVKosb9WNYftP3BCU4J2ZYPKsSTRLwxkDqJPD0ukVFayeJHZOg96WSpn
VDkrDhhfKZhF6ezLmYh4u7CefhI8gc2zfP5z01ydw/bqkYRJE++WCxZvQHYT8noy
nNjy1w1h8V9Aa+TdtREDGg7wsZAJbsULjuqAmpHU/OQrhOFpaB8AsKv+eN+UTO+E
T6X6GgOydW0Sg3+NNJlj6G2yZVf2w+FZBp6icyyL3m0oBwZDboTHlIxtaH+dXH53
2l1BFMZV2OPg69CtVPsESXLpvy3+PDwtejNvCI2o/ZAW7BNAX/P0nPFWeRoECaCt
mXSroQ4sz6X8I5I44P6ePTVZd/9BEkSQ77OWYBhzBDUhLKpz+WmEFsgQj7KR9ePi
4t0rGwU+wTmBmBJtDlS7QMNhlFEPy7w9b5kkR9FSdIigtb/EvfiiS6OuzpgZmerF
EEI6sxqP8U0lgctvh71VvwSOL91PoCX7qlBLwyMoFePWOTg7AFZDO8evEQzbtFCM
VBT2Uu6xVNs=
=dS/O
-----END PGP SIGNATURE-----

--=-QHO6M1Iu4VBkzdKCbTc0--
