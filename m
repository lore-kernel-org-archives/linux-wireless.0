Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:33340 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932902AbbIUQlc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Sep 2015 12:41:32 -0400
Date: Mon, 21 Sep 2015 18:11:19 +0200
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: Re: [PATCH] ssb: make ssb_pcmcia_switch_core static
Message-ID: <20150921181119.18e76933@wiggum> (sfid-20150921_184144_183477_497989DA)
In-Reply-To: <1442822126-23372-1-git-send-email-zajec5@gmail.com>
References: <1442822126-23372-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/67ehC5D_.+tGDJ3hJD9Hrgs"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Sig_/67ehC5D_.+tGDJ3hJD9Hrgs
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, 21 Sep 2015 09:55:26 +0200
Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com> wrote:

> Signed-off-by: Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com>
> ---
>  drivers/ssb/pcmcia.c      | 3 +--
>  drivers/ssb/ssb_private.h | 7 -------
>  2 files changed, 1 insertion(+), 9 deletions(-)
>=20
> diff --git a/drivers/ssb/pcmcia.c b/drivers/ssb/pcmcia.c
> index b413e01..f03422b 100644
> --- a/drivers/ssb/pcmcia.c
> +++ b/drivers/ssb/pcmcia.c
> @@ -147,8 +147,7 @@ error:
>  	return err;
>  }
> =20
> -int ssb_pcmcia_switch_core(struct ssb_bus *bus,
> -			   struct ssb_device *dev)
> +static int ssb_pcmcia_switch_core(struct ssb_bus *bus, struct ssb_device=
 *dev)
>  {
>  	int err;
> =20
> diff --git a/drivers/ssb/ssb_private.h b/drivers/ssb/ssb_private.h
> index 426c805..8a2ebc8 100644
> --- a/drivers/ssb/ssb_private.h
> +++ b/drivers/ssb/ssb_private.h
> @@ -85,8 +85,6 @@ static inline int ssb_pci_init(struct ssb_bus *bus)
> =20
>  /* pcmcia.c */
>  #ifdef CONFIG_SSB_PCMCIAHOST
> -extern int ssb_pcmcia_switch_core(struct ssb_bus *bus,
> -				  struct ssb_device *dev);
>  extern int ssb_pcmcia_switch_coreidx(struct ssb_bus *bus,
>  				     u8 coreidx);
>  extern int ssb_pcmcia_switch_segment(struct ssb_bus *bus,
> @@ -98,11 +96,6 @@ extern void ssb_pcmcia_exit(struct ssb_bus *bus);
>  extern int ssb_pcmcia_init(struct ssb_bus *bus);
>  extern const struct ssb_bus_ops ssb_pcmcia_ops;
>  #else /* CONFIG_SSB_PCMCIAHOST */
> -static inline int ssb_pcmcia_switch_core(struct ssb_bus *bus,
> -					 struct ssb_device *dev)
> -{
> -	return 0;
> -}
>  static inline int ssb_pcmcia_switch_coreidx(struct ssb_bus *bus,
>  					    u8 coreidx)
>  {


Acked-by: Michael Buesch <m@bues.ch>


--=20
Michael

--Sig_/67ehC5D_.+tGDJ3hJD9Hrgs
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWACwnAAoJEPUyvh2QjYsOwdYP+gIWHbCHjEetRea9nSvnGToq
8NCvvDEIJf0ZyHwNz1EorYOhfNV16WjaPR7a52s4yynSe5M0vxBrbIaVeBZ7PCpp
5KykmGNEUy2rHbBqoeRGNGfsFmswzyPUsFmcGI+ivzS/zf6t890f2zPFh9TjYiN+
GwKeHGTY0XyhM7+E1NJJF3Oislo2x/dAmgOaKe2dO56NNMEJhe/e4ep0kW4Gv+Pa
FXDaprSeGRRMvt9j0KwpZNn+SwTzrpifA7NRnWh8Kwq/pADjf7p90PFMKn2eHyqD
DahThoDZUDLYSVEf2C3dkNk/tozs8qJVsGZEWTTd5lCagzbu/5iIrAOLG67jmhl+
lAlTaBbcdaFHxLDuT7lYhME1OaYVyjSdxEJ1lnJa4pN8jxChv3g4HyMIOJRjH/Zg
sT7uu3fZMRT9MepvyVvmZfLnw+vZCamp8vpg33EA0t1fFBxiMuTuxY7PoQYcjLY0
cqsBOGwXU+xeXenfGgmJPnFIxNYKFYPU+vk90/YcISjMfET8e1zh85OsLZXfyYBD
Ao8ZNNtw3F80iThszzCJKkTwUps3LaaOT9NeICWEnqnjdqETqicQ9vWULbbALRx+
/ywzVTCbnM5YTcJI7zJryOmj3FfRweaB2b4K9F7imyz7ppq/lyWhmdaRGaPcI4GF
stH7tOToZkx4oiTMK1T8
=+Bvx
-----END PGP SIGNATURE-----

--Sig_/67ehC5D_.+tGDJ3hJD9Hrgs--
