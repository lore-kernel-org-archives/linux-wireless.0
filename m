Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:42236 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767AbYGBIBG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jul 2008 04:01:06 -0400
Subject: Re: [PATCH 1/1] mac80211: remove MAC80211_DEBUG from
	net/mac80211/Kconfig.
From: Johannes Berg <johannes@sipsolutions.net>
To: Rami Rosen <ramirose@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <eb3ff54b0807020053h1b34a8e9p476f7cb149fd6805@mail.gmail.com> (sfid-20080702_095400_027604_47BF358E)
References: <eb3ff54b0807020053h1b34a8e9p476f7cb149fd6805@mail.gmail.com>
	 (sfid-20080702_095400_027604_47BF358E)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Brv/i0D+nI5BnSDv77i4"
Date: Wed, 02 Jul 2008 10:00:19 +0200
Message-Id: <1214985619.13270.4.camel@johannes.berg> (sfid-20080702_100110_181296_E1152327)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Brv/i0D+nI5BnSDv77i4
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-07-02 at 10:53 +0300, Rami Rosen wrote:
> Hi,
> This patch removes MAC80211_DEBUG from /net/mac80211/Kconfig
> (in MAC80211_DEBUG_COUNTERS config entry), and replaces
> MAC80211_DEBUG_MENU instead of MAC80211_DEBUG
> (in MAC80211_VERBOSE_SPECT_MGMT_DEBUG config entry).
>=20
> (for wireless-next-2.6 tree)

Oops, thanks.

> Regards,
> Rami Rosen
>=20
> Signed-off-by: Rami Rosen <ramirose@gmail.com>

Acked-by: Johannes Berg <johannes@sipsolutions.net>

> =EF=BB=BFdiff --git a/net/mac80211/Kconfig b/net/mac80211/Kconfig
> index 11a1e7f..40f1add 100644
> --- a/net/mac80211/Kconfig
> +++ b/net/mac80211/Kconfig
> @@ -207,7 +207,6 @@ config MAC80211_LOWTX_FRAME_DUMP
> =20
>  config MAC80211_DEBUG_COUNTERS
>         bool "Extra statistics for TX/RX debugging"
> -       depends on MAC80211_DEBUG
>         depends on MAC80211_DEBUG_MENU
>         depends on MAC80211_DEBUGFS
>         ---help---
> @@ -219,7 +218,7 @@ config MAC80211_DEBUG_COUNTERS
> =20
>  config MAC80211_VERBOSE_SPECT_MGMT_DEBUG
>         bool "Verbose Spectrum Management (IEEE 802.11h)debugging"
> -       depends on MAC80211_DEBUG
> +       depends on MAC80211_DEBUG_MENU
>         ---help---
>           Say Y here to print out verbose Spectrum Management (IEEE 802.1=
1h)
>           debug messages.

--=-Brv/i0D+nI5BnSDv77i4
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIazWPAAoJEKVg1VMiehFYi20P/jeLq1kxQ23Q4AQ+mqxvH8u2
K30iEW03NUc5r8hxzZv9nKvVqkDJJ4CPPS/qRb6Jrz8O96EHcT1iyKWtAEREbCVD
9fvjKU051WjlFFGeEBas3GwNlnRWaYf0TlNHfAV5yHaLeBvIf8JVGVV1DFoZ+zs3
vnnPrdG4pSW7zRsaRnxVVboWVJWG5tWr0q99EFp1yqWOL80BIb+2K4zAcFAztjKO
kWZn1nEdC9fjUSVhntvUImpdgrfcAk0FqQIe31HMiJuxTt1YEwBxiStsTh2qYuYm
un39zBAEN5hrVkLxQLQuN1wKHB/PAiTO7hEGsM93tRhlWOI3R28ijSoF/4z+93el
GUVLCalbLmkYk4EjopumLR91LlBEH2pNY5pZsdJq8yqxgWwFNImbIdGRCmnAgoil
2aWvhsHAhzvdXL84R04t2w7Zj9mrmIanXmswphnF2UKLmFSKegRdIGxB2joUtCNt
Goef+CFjqp0zBLZTukkUeGYp8pT01D1xSEfUEgjj9eoi6FlGKKaCZZMSLxjKqSxV
P1DZPtiIfot97Rb/GIpAxYn1VALrOK5BXEus/We5nJ+y5/deWSv0/+j5xjDGFIC6
Frh2GPiJfAIZKicP0bZFWnZOilzIZdybftvau1Sb/w/1J4EYL7tXiTImecC/oISw
h/djhHQAo+mGXr/+fgk0
=Lbq4
-----END PGP SIGNATURE-----

--=-Brv/i0D+nI5BnSDv77i4--

