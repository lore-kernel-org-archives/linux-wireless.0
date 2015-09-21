Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:33344 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932902AbbIUQlg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Sep 2015 12:41:36 -0400
Date: Mon, 21 Sep 2015 18:11:10 +0200
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: Re: [PATCH 3/3] ssb: drop declaration of non existing
 ssb_sdio_hardware_setup
Message-ID: <20150921181110.3102e687@wiggum> (sfid-20150921_184149_181441_2F0438F7)
In-Reply-To: <1442821640-14582-3-git-send-email-zajec5@gmail.com>
References: <1442821640-14582-1-git-send-email-zajec5@gmail.com>
	<1442821640-14582-3-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/tEn54WEatTMhDh.tELBDtXm"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Sig_/tEn54WEatTMhDh.tELBDtXm
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, 21 Sep 2015 09:47:20 +0200
Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com> wrote:

> Signed-off-by: Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com>
> ---
>  drivers/ssb/ssb_private.h | 5 -----
>  1 file changed, 5 deletions(-)
>=20
> diff --git a/drivers/ssb/ssb_private.h b/drivers/ssb/ssb_private.h
> index 1d2256e..426c805 100644
> --- a/drivers/ssb/ssb_private.h
> +++ b/drivers/ssb/ssb_private.h
> @@ -133,7 +133,6 @@ extern int ssb_sdio_get_invariants(struct ssb_bus *bu=
s,
> =20
>  extern u32 ssb_sdio_scan_read32(struct ssb_bus *bus, u16 offset);
>  extern int ssb_sdio_scan_switch_coreidx(struct ssb_bus *bus, u8 coreidx);
> -extern int ssb_sdio_hardware_setup(struct ssb_bus *bus);
>  extern void ssb_sdio_exit(struct ssb_bus *bus);
>  extern int ssb_sdio_init(struct ssb_bus *bus);
> =20
> @@ -147,10 +146,6 @@ static inline int ssb_sdio_scan_switch_coreidx(struc=
t ssb_bus *bus, u8 coreidx)
>  {
>  	return 0;
>  }
> -static inline int ssb_sdio_hardware_setup(struct ssb_bus *bus)
> -{
> -	return 0;
> -}
>  static inline void ssb_sdio_exit(struct ssb_bus *bus)
>  {
>  }


Acked-by: Michael Buesch <m@bues.ch>


--=20
Michael

--Sig_/tEn54WEatTMhDh.tELBDtXm
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWACweAAoJEPUyvh2QjYsO1/4QANE376EIOnM0AaIjUbIUA23W
eBloqMKX/gnG4mGe7O+YFImKM4F1obOoVKmtgX9MkpXJz1dYQIfvZlBFPqncYlIM
9afx2pJPGD05FJlEk82QBy4/m0p0tbxrInW9oMsnFKpcQaLOtI9B5Mvh12ueoFIp
8W/aYX6zJib55FN+efvkPcF4AL4Y3sKgx7UGBLOgblqxpk7Xb21/fy9c+arV8+5p
gpGLJHSjVMqTYItBcETV9j62QPdCtGcbRwH4mEpv3KyAcsb6G3iY/aCu4WehJDFx
tqYSDI9/M+z94tUEhcxMgZ/2TpuqbsyNc/warGhN7AOHMjBzSqOcdMAw1m6d9rEx
jFqrJPupfRFBqmByJdeEie0/XHXctqtPaUOXJp5jp38G/kSXlxjsTR/uNT/ERUtp
j2yhESpt7S8/Ok5v+8H8rYZq2h3SqMxCHRA5BjrehXloXbb1R7dn7Mg3mmODwhXo
tzC4KRATok+ibSNdJ4OqPyb8kPAwR2BnKCv+SKxdTB7JmLZMDyu672oTn2wZaeEv
ilhmj90XNTeQtUjk6q84yQ7coqepm7YDkTMzePxnN5m8mqnuaSZUC12GM2BdPHUb
lRpWl+6N7JmEb10bmVfVzFT+o1zE8+G3X0jidU8GRyP1P3QgvzHyTtEUGUEbZaCy
WbowDzOkfJHH+tU/7/zU
=1JUb
-----END PGP SIGNATURE-----

--Sig_/tEn54WEatTMhDh.tELBDtXm--
