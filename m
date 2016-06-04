Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:49142 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751175AbcFDLuc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Jun 2016 07:50:32 -0400
Date: Sat, 4 Jun 2016 13:50:10 +0200
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: Hugh =?UTF-8?B?U2lwacOocmU=?= <hgsipiere@gmail.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers: ssb: Fix comments to suit coding style
Message-ID: <20160604135010.4066a7a6@wiggum> (sfid-20160604_135037_461848_6F0A6218)
In-Reply-To: <1465039933-3984-1-git-send-email-hgsipiere@gmail.com>
References: <1465039933-3984-1-git-send-email-hgsipiere@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/5L6kmpIXHnFj3pDdgIIjjZQ"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Sig_/5L6kmpIXHnFj3pDdgIIjjZQ
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Sat,  4 Jun 2016 12:32:13 +0100
Hugh Sipi=C3=A8re <hgsipiere@gmail.com> wrote:

> I changed it so that these two comments do not end on a line with text.
>=20
> Signed-off-by: Hugh Sipi=C3=A8re <hgsipiere@gmail.com>
> ---
>  drivers/ssb/driver_gpio.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/ssb/driver_gpio.c b/drivers/ssb/driver_gpio.c
> index 180e027..f2435f3 100644
> --- a/drivers/ssb/driver_gpio.c
> +++ b/drivers/ssb/driver_gpio.c
> @@ -231,7 +231,8 @@ static int ssb_gpio_chipco_init(struct ssb_bus *bus)
>  	chip->ngpio		=3D 16;
>  	/* There is just one SoC in one device and its GPIO addresses should be
>  	 * deterministic to address them more easily. The other buses could get
> -	 * a random base number. */
> +	 * a random base number.
> +	 */
>  	if (bus->bustype =3D=3D SSB_BUSTYPE_SSB)
>  		chip->base		=3D 0;
>  	else
> @@ -424,7 +425,8 @@ static int ssb_gpio_extif_init(struct ssb_bus *bus)
>  	chip->ngpio		=3D 5;
>  	/* There is just one SoC in one device and its GPIO addresses should be
>  	 * deterministic to address them more easily. The other buses could get
> -	 * a random base number. */
> +	 * a random base number.
> +	 */
>  	if (bus->bustype =3D=3D SSB_BUSTYPE_SSB)
>  		chip->base		=3D 0;
>  	else


What's the benefit from this change?
Will the next person submit a patch to remove wasted lines that just
contain a */?


--=20
Michael

--Sig_/5L6kmpIXHnFj3pDdgIIjjZQ
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJXUsByAAoJEPUyvh2QjYsOzzEQAJa3Y/n7vs2MFR7sPoWzVCJM
Iu4pfkD8aT3JlmQo1ebNevhjVSt6z2NKwesOGHlhaSbYGX9O2o/8nIqjE/QKSBat
jwVZV1MhkE9yuXho9p3mpzrA6YCa/ehP8OwEGEhJXOzeSEVicxMNGSzf/ld2oMnE
mOOEvkeT7Bolbt1UcBwSaaUE3e4cq8FPROiqEZ7O/fJtKcAh23tBfDb8vtur6x54
UngnQmLEvPGBvMvcdwoXvYZ4LE6VnLV78M1PmzMTJa+1RJCtDMiD6lkW+6YWERja
HJzQD+YG4yCc51mq/pFxDCZiaua2MGwxrRMmiZP0fne8ofDTYczoAQG3Wn9g61lE
4IRPcNsd44vM93nS9jZpmFyzCvU4+Z2ksDcKZYDGQ6tJJeXtPqmOq1qRdF8bNKgN
nFkS6ogbfzk26F1UclV1Zc7CMUcQ4xGO63oi/JjHClzxuVgK5ARQHFBBOyKRKY/j
6XIyGMnP8MnF/aLM8t68YPB353uWOC6IxFZW0YsDf8BuXHaNh8di8TA+GIJjTx0N
uEM0ThVGkL/gXTku/PGt6MIzE3RnvFfVz+SHKq9U2UIaR5hOephfZDo3HgAIv7+8
HSqbqzm3f73S96Ex33sPCmmjS8leoO130BK3xEJeKpFhd9ox4UOcqFbMG4vv255v
tpAZ5ohv5TGM3/rVDKzY
=Vitr
-----END PGP SIGNATURE-----

--Sig_/5L6kmpIXHnFj3pDdgIIjjZQ--
