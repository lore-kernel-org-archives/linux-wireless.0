Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:57365 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750720AbaKLGo3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Nov 2014 01:44:29 -0500
Message-ID: <546301C5.6010705@rempel-privat.de> (sfid-20141112_074433_218537_9F21D48E)
Date: Wed, 12 Nov 2014 07:44:21 +0100
From: Oleksij Rempel <linux@rempel-privat.de>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath9k_htc: remove return of value in empty definintion
 of ath9k_htc_deinit_debug
References: <1415744629-6946-1-git-send-email-linville@tuxdriver.com>
In-Reply-To: <1415744629-6946-1-git-send-email-linville@tuxdriver.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="SPuQKdWfig6RwJGRqfljUf62mNeRFROR6"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--SPuQKdWfig6RwJGRqfljUf62mNeRFROR6
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Am 11.11.2014 um 23:23 schrieb John W. Linville:
> Cc: Oleksij Rempel <linux@rempel-privat.de>
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> ---
>  drivers/net/wireless/ath/ath9k/htc.h | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireles=
s/ath/ath9k/htc.h
> index b34acdeb1f21..9dde265d3f84 100644
> --- a/drivers/net/wireless/ath/ath9k/htc.h
> +++ b/drivers/net/wireless/ath/ath9k/htc.h
> @@ -629,7 +629,9 @@ int ath9k_htc_init_debug(struct ath_hw *ah);
>  void ath9k_htc_deinit_debug(struct ath9k_htc_priv *priv);
>  #else
>  static inline int ath9k_htc_init_debug(struct ath_hw *ah) { return 0; =
};
> -static inline void ath9k_htc_deinit_debug(struct ath9k_htc_priv *priv)=
 { return 0; };
> +static inline void ath9k_htc_deinit_debug(struct ath9k_htc_priv *priv)=

> +{
> +}
>  #endif /* CONFIG_ATH9K_HTC_DEBUGFS */
> =20
>  #endif /* HTC_H */
>=20

Thank you.

--=20
Regards,
Oleksij


--SPuQKdWfig6RwJGRqfljUf62mNeRFROR6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iF4EAREIAAYFAlRjAcUACgkQHwImuRkmbWlaaQD/chmDKjqE4iq7UvfIrmcI0Mf6
KEjfln7ONRPTdyHnLbQA/1ul+P5rp8wvk+RFQUs41ZXn8FM3O6847jn/PTduVw8T
=Wr8T
-----END PGP SIGNATURE-----

--SPuQKdWfig6RwJGRqfljUf62mNeRFROR6--
