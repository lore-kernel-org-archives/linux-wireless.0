Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:57356 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756384AbZKRKyS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Nov 2009 05:54:18 -0500
Subject: Re:
From: Johannes Berg <johannes@sipsolutions.net>
To: Janakiram Sistla <janakiram.sistla@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1258509054-10901-1-git-send-email-janakiram.sistla@gmail.com>
References: <>
	 <1258509054-10901-1-git-send-email-janakiram.sistla@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-qfhkY+0N93M2BxvxvFxm"
Date: Wed, 18 Nov 2009 11:53:51 +0100
Message-ID: <1258541631.30511.7.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-qfhkY+0N93M2BxvxvFxm
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-11-18 at 07:20 +0530, Janakiram Sistla wrote:

> ---
>  include/linux/rfkill.h |    2 ++
>  net/rfkill/core.c      |    2 ++
>  2 files changed, 4 insertions(+), 0 deletions(-)
>=20
> diff --git a/include/linux/rfkill.h b/include/linux/rfkill.h
> index 3392c59..7ae75ef 100644
> --- a/include/linux/rfkill.h
> +++ b/include/linux/rfkill.h
> @@ -35,6 +35,7 @@
>   * @RFKILL_TYPE_UWB: switch is on a ultra wideband device.
>   * @RFKILL_TYPE_WIMAX: switch is on a WiMAX device.
>   * @RFKILL_TYPE_WWAN: switch is on a wireless WAN device.
> + * @RFKILL_TYPE_FM: switch is on a wireless FM device.
>   * @NUM_RFKILL_TYPES: number of defined rfkill types
>   */
>  enum rfkill_type {
> @@ -44,6 +45,7 @@ enum rfkill_type {
>  	RFKILL_TYPE_UWB,
>  	RFKILL_TYPE_WIMAX,
>  	RFKILL_TYPE_WWAN,
> +	RFKILL_TYPE_FM,
>  	RFKILL_TYPE_GPS,
>  	NUM_RFKILL_TYPES,
>  };

Nice try, but no fly. This struct is ABI, you cannot add in the middle.

johannes

--=-qfhkY+0N93M2BxvxvFxm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLA9I8AAoJEODzc/N7+QmaGGgP/jc/gsH6rdgkw5oSfbzIyc/k
AoIyqt01ZsTsZ7MKVlgRym0gGBjgstFHrF4NgjJHZsxbRUO8+I/RUu9ztU+kRQ45
5GThpQtUwboCdvT8l6xUyDhP3pV8Gd86YGdlHgFDaHK8aLC7eCUBdMRLM1DmlaEd
cvDohIUmYAYaQSJEsUapZQtihbC0yGiyS2D95XpXKUDoOs0WhmRhoYuZ2CbNFBXr
qmZZeTzIKYhsa6RwpYbhV1Fi06/MK2fIv5qR5ZB9BaVhBVqHlteHJnM2VAsanaPt
A9Oo/1Ti3/k9DVa7lC4ObAVwtF6TOxd6oD+M48CWirrhre4jqths9v0drqyqI7np
33A1wl0FireQ/tUJb1U0X3hU0sDinkjTPkhhbDo4auMwJgGS9wXH65WmeeS7x+FF
sO3JWDZCaw+g3C3t6uYwUi04KQ8/Ovt0pU8JxttCF5/iSQZBeA4XzyYBTAZDiYAr
MteZuNK2lNnxmW4lag5w26Mw/se2NFk3Y2iKO7NoCAfbY2tGjoWxo7PDXjBCGfns
S/Rf3xPkz0+apu6X9ViYvLyT9tVugkLsnjisXxyfqRlDHijc83ZJc4EXqtK4IGfS
MsE3NQs3TzlGRSZdnkHnwEKTwzm8mC/UFun3Mq2H+sIXDIfjYS9K3pnIP/KuxhRr
Vi8EZvDcz28tTLZfdS/K
=o6Z5
-----END PGP SIGNATURE-----

--=-qfhkY+0N93M2BxvxvFxm--

