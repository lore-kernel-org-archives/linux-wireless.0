Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 162-17-110-37-static.hfc.comcastbusiness.net ([162.17.110.37]:60746
	"EHLO stuffed.shaftnet.org" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751971Ab3FAMCU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Jun 2013 08:02:20 -0400
Date: Sat, 1 Jun 2013 08:02:02 -0400
From: Solomon Peachy <pizza@shaftnet.org>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: linville@tuxdriver.com, yongjun_wei@trendmicro.com.cn,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH -next] cw1200: remove duplicated include from wsm.c
Message-ID: <20130601120201.GB20362@shaftnet.org> (sfid-20130601_140235_997205_1F9678F5)
References: <CAPgLHd_=MWYEYniddEJNBJGDBJyoDC1S2HV+Pnn1GugwM+PQgg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hQiwHBbRI9kgIhsi"
In-Reply-To: <CAPgLHd_=MWYEYniddEJNBJGDBJyoDC1S2HV+Pnn1GugwM+PQgg@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--hQiwHBbRI9kgIhsi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 30, 2013 at 07:41:11PM +0800, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>=20
> Remove duplicated include.
>=20
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Acked-by: Solomon Peachy <pizza@shaftnet.org>

> ---
>  drivers/net/wireless/cw1200/wsm.c | 1 -
>  1 file changed, 1 deletion(-)
>=20
> diff --git a/drivers/net/wireless/cw1200/wsm.c b/drivers/net/wireless/cw1=
200/wsm.c
> index 4db6cc1..f3fd9b2 100644
> --- a/drivers/net/wireless/cw1200/wsm.c
> +++ b/drivers/net/wireless/cw1200/wsm.c
> @@ -12,7 +12,6 @@
> =20
>  #include <linux/skbuff.h>
>  #include <linux/wait.h>
> -#include <linux/skbuff.h>
>  #include <linux/delay.h>
>  #include <linux/sched.h>
>  #include <linux/random.h>
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

--hQiwHBbRI9kgIhsi
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iD8DBQFRqeK5PuLgii2759ARAlHIAKDmkSpedB4t8OQ9xs79ol7XXZ8oTACg41rg
J1u02WZjIDObstjsUNRcIMY=
=/Yb3
-----END PGP SIGNATURE-----

--hQiwHBbRI9kgIhsi--
