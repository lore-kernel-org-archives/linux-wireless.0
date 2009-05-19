Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:57957 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751882AbZESWGX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 May 2009 18:06:23 -0400
Subject: Re: [PATCH 1/3] ath9k: fix custom regulatory call position
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1242769787-29467-1-git-send-email-lrodriguez@atheros.com>
References: <1242769787-29467-1-git-send-email-lrodriguez@atheros.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-oCoyE9QH8zUeiqyaJM5m"
Date: Wed, 20 May 2009 00:05:52 +0200
Message-Id: <1242770752.31350.2.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-oCoyE9QH8zUeiqyaJM5m
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-05-19 at 17:49 -0400, Luis R. Rodriguez wrote:

>  	ath_set_hw_capab(sc, hw);
> =20
> +        error =3D ath_regd_init(&sc->sc_ah->regulatory, sc->hw->wiphy,
> +			      ath9k_reg_notifier);
> +	if (error)

that looks like a whitespace problem

johannes

--=-oCoyE9QH8zUeiqyaJM5m
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKEy08AAoJEODzc/N7+QmaBMYP/35cI2qMNHu0Yj2Ebdafcd2q
UVp3/DVzmL+I5bcXU7xo/Om3CoqDDlAA/PTJWxhG1RR8dJNm1Bd//tp2tMbPHc3/
/s4ANxQRpQ5xZZ/QsZ4yLeUUqFPEyZHuYzVb89fn2pWkQ8kDaamKeX22jFUvfpJd
/LZyevymEMHPFMUtQzE8XOB7rCRjtXFl0gmyl0/7yYTjnT5dzYWsskxSsPbiXG7q
SOzObGjo4eTzBVlsynWaeQ8S/ET7Gt5tltANQZ7FuJXQarM0RX+7VAAQmrxuWf/b
Jh+WrzvQHPT6M0KnL2ALQPdckkuQdn34Wkaz5sGS64OlMUZyF3PEa2B19wHz/GL6
WRPHyqjyXusEdV3yMlAR86x7XCFcRgRK2aNtMnTk/0Axb+TERJK+QSRlnQ9kFVho
Yk2nRStIF6chdx34fPJRTmjUmGtG+b0Wc55J4H3KtXJkKJm5c13xoUzHyfyJC1Hf
6cB70TedunZEKDN38RbuUBo6Kaqyt5skDXKDXWhyZPUaOmgZKDKY35ot91iK51al
tbgfltDUkMpt2kRYT45zicKF5d8Bc1b9A4xDcU2pqGIWVtbTTlFnVCYk5V2lelOS
4VlZtkTQI3sty0R18W2LmaFFzGV9a+X8aP6HBb2ABjw/nAkJye3giGC9qLMKWJTg
j56gOOTqnUGnxT/xb7d4
=mkPR
-----END PGP SIGNATURE-----

--=-oCoyE9QH8zUeiqyaJM5m--

