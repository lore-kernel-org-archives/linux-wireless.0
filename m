Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 162-17-110-37-static.hfc.comcastbusiness.net ([162.17.110.37]:60791
	"EHLO stuffed.shaftnet.org" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755467Ab3FAMCv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Jun 2013 08:02:51 -0400
Date: Sat, 1 Jun 2013 08:02:45 -0400
From: Solomon Peachy <pizza@shaftnet.org>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: linville@tuxdriver.com, yongjun_wei@trendmicro.com.cn,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH -next] cw1200: remove unused including <linux/version.h>
Message-ID: <20130601120244.GE20362@shaftnet.org> (sfid-20130601_140254_055382_A3CFB98F)
References: <CAPgLHd8NLmToy54gYtB-LKX9aKx59BnLBbH-Y6hp_6z-EQwq+A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HeFlAV5LIbMFYYuh"
In-Reply-To: <CAPgLHd8NLmToy54gYtB-LKX9aKx59BnLBbH-Y6hp_6z-EQwq+A@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--HeFlAV5LIbMFYYuh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 30, 2013 at 07:43:13PM +0800, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>=20
> Remove including <linux/version.h> that don't need it.
>=20
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Acked-by: Solomon Peachy <pizza@shaftnet.org>

> ---
>  drivers/net/wireless/cw1200/cw1200_spi.c  | 1 -
>  drivers/net/wireless/cw1200/cw1200_sdio.c | 1 -
>  drivers/net/wireless/cw1200/cw1200.h      | 1 -
>  3 files changed, 3 deletions(-)
>=20
> diff --git a/drivers/net/wireless/cw1200/cw1200_spi.c b/drivers/net/wirel=
ess/cw1200/cw1200_spi.c
> index 04af685..ab7a2d5 100644
> --- a/drivers/net/wireless/cw1200/cw1200_spi.c
> +++ b/drivers/net/wireless/cw1200/cw1200_spi.c
> @@ -13,7 +13,6 @@
>   * published by the Free Software Foundation.
>   */
> =20
> -#include <linux/version.h>
>  #include <linux/module.h>
>  #include <linux/gpio.h>
>  #include <linux/delay.h>
>=20
> diff --git a/drivers/net/wireless/cw1200/cw1200_sdio.c b/drivers/net/wire=
less/cw1200/cw1200_sdio.c
> index f6e2219..c658f1b 100644
> --- a/drivers/net/wireless/cw1200/cw1200_sdio.c
> +++ b/drivers/net/wireless/cw1200/cw1200_sdio.c
> @@ -9,7 +9,6 @@
>   * published by the Free Software Foundation.
>   */
> =20
> -#include <linux/version.h>
>  #include <linux/module.h>
>  #include <linux/gpio.h>
>  #include <linux/delay.h>
>=20
> diff --git a/drivers/net/wireless/cw1200/cw1200.h b/drivers/net/wireless/=
cw1200/cw1200.h
> index 2aa17ca..e9424e6 100644
> --- a/drivers/net/wireless/cw1200/cw1200.h
> +++ b/drivers/net/wireless/cw1200/cw1200.h
> @@ -19,7 +19,6 @@
>  #define CW1200_H
> =20
>  #include <linux/wait.h>
> -#include <linux/version.h>
>  #include <linux/mutex.h>
>  #include <linux/workqueue.h>
>  #include <net/mac80211.h>
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=20
Solomon Peachy        		       pizza at shaftnet dot org	=20
Delray Beach, FL                          ^^ (mail/jabber) ^^
Quidquid latine dictum sit, altum viditur.

--HeFlAV5LIbMFYYuh
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iD8DBQFRqeLkPuLgii2759ARAr8LAJ9nACFjpT3HH7NM7yM20KOxKOEjUACcDCLd
eWhp7BYTdKwM+ZdmBA9TWRI=
=E5WU
-----END PGP SIGNATURE-----

--HeFlAV5LIbMFYYuh--
