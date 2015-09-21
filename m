Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:33343 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932904AbbIUQlf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Sep 2015 12:41:35 -0400
Date: Mon, 21 Sep 2015 18:10:59 +0200
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: Re: [PATCH 2/3] ssb: make ssb_sdio_switch_core static
Message-ID: <20150921181059.680dc5b5@wiggum> (sfid-20150921_184144_791415_2C34146C)
In-Reply-To: <1442821640-14582-2-git-send-email-zajec5@gmail.com>
References: <1442821640-14582-1-git-send-email-zajec5@gmail.com>
	<1442821640-14582-2-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/oaIzX7me03Af6hH6BfzbSpq"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Sig_/oaIzX7me03Af6hH6BfzbSpq
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, 21 Sep 2015 09:47:19 +0200
Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com> wrote:

> It's used locally only.
>=20
> Signed-off-by: Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com>
> ---
>  drivers/ssb/sdio.c        | 2 +-
>  drivers/ssb/ssb_private.h | 6 ------
>  2 files changed, 1 insertion(+), 7 deletions(-)
>=20
> diff --git a/drivers/ssb/sdio.c b/drivers/ssb/sdio.c
> index b2d36f7..2278e43 100644
> --- a/drivers/ssb/sdio.c
> +++ b/drivers/ssb/sdio.c
> @@ -200,7 +200,7 @@ out:
>  }
> =20
>  /* host must be already claimed */
> -int ssb_sdio_switch_core(struct ssb_bus *bus, struct ssb_device *dev)
> +static int ssb_sdio_switch_core(struct ssb_bus *bus, struct ssb_device *=
dev)
>  {
>  	u8 coreidx =3D dev->core_index;
>  	u32 sbaddr;
> diff --git a/drivers/ssb/ssb_private.h b/drivers/ssb/ssb_private.h
> index eb507a5..1d2256e 100644
> --- a/drivers/ssb/ssb_private.h
> +++ b/drivers/ssb/ssb_private.h
> @@ -132,7 +132,6 @@ extern int ssb_sdio_get_invariants(struct ssb_bus *bu=
s,
>  				     struct ssb_init_invariants *iv);
> =20
>  extern u32 ssb_sdio_scan_read32(struct ssb_bus *bus, u16 offset);
> -extern int ssb_sdio_switch_core(struct ssb_bus *bus, struct ssb_device *=
dev);
>  extern int ssb_sdio_scan_switch_coreidx(struct ssb_bus *bus, u8 coreidx);
>  extern int ssb_sdio_hardware_setup(struct ssb_bus *bus);
>  extern void ssb_sdio_exit(struct ssb_bus *bus);
> @@ -144,11 +143,6 @@ static inline u32 ssb_sdio_scan_read32(struct ssb_bu=
s *bus, u16 offset)
>  {
>  	return 0;
>  }
> -static inline int ssb_sdio_switch_core(struct ssb_bus *bus,
> -					 struct ssb_device *dev)
> -{
> -	return 0;
> -}
>  static inline int ssb_sdio_scan_switch_coreidx(struct ssb_bus *bus, u8 c=
oreidx)
>  {
>  	return 0;


Acked-by: Michael Buesch <m@bues.ch>


--=20
Michael

--Sig_/oaIzX7me03Af6hH6BfzbSpq
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWACwTAAoJEPUyvh2QjYsO+DMP/0j70Z9uHiORZFOWuNsMahsf
Ya0xCj1LrsJPlaGEVKanaF3FAeo879qpBDBCdmqRb7XXVkATWmCcKZTojcTVe6oL
24t1MXJx/hKRfPUJs1F3zCVqgBnncfolk9lIbM2WOhLjunO8UIWpSrnRngXlkgeO
POQVSID+sW43ApGNG+RoL0Ke1+kzdzfWMIBP1RdDfz7ejnQXvyDQvO4MuS1B327q
7tIb3BoxpeK/QsMZIY5TuyVFq8qLRQboXM6PXchFAar1p3ngSPljLYwp3KZhNFNx
sxmUO7o6gkqMM89OIelmIg6poMH+/u9vkWpCVsYBC8ohUdBK69ewpKNwhB5JEEYU
MRmNtDL2l2kqItefHxx46ZRKMTdstN32LYNn5AaZ8fjG9IsrzZAGucvLJaEa/PEz
zO3ZkmYO5A6CPTjNI5hgV9zaylBi8MHmXp8ka39CG/Ic4PfVG2AADbQs6RwrevE8
YKylp5Q2RR50ThzUJ0k+kuReIZZu5CtC9dVW7g32OMgdqvnF3lXSB5TS0kaU/yM6
UA8HffSlHYwwoc52M97Xo66XLfTldkkBMrS5CvtrjzW8sL6pOc+TafHW/LnCFxrR
dOi6dYokh0QHq2AYC1lMn2YE0fnmO8xNQwpDg1Skt4wXqxfz3MS7iiEzo74wxe+j
ldFowZsKey8fYIfxp2G/
=sqCh
-----END PGP SIGNATURE-----

--Sig_/oaIzX7me03Af6hH6BfzbSpq--
