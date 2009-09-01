Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35680 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754399AbZIAPcI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Sep 2009 11:32:08 -0400
Subject: Re: [PATCH 2/7] wireless: update wireless kconfig description
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1251818566-9264-3-git-send-email-lrodriguez@atheros.com>
References: <1251818566-9264-1-git-send-email-lrodriguez@atheros.com>
	 <1251818566-9264-3-git-send-email-lrodriguez@atheros.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-zBGM6uBjNR3w+UEhn5f3"
Date: Tue, 01 Sep 2009 17:31:36 +0200
Message-Id: <1251819096.22442.17.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-zBGM6uBjNR3w+UEhn5f3
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-09-01 at 08:22 -0700, Luis R. Rodriguez wrote:
> "Wireless" is a misnomer 802.11 as there are plently
> of other wireless technologies. Be more specific and refer
> people to our good hearty wireless wiki for documentation.
>=20
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> ---
>  net/Kconfig |    8 +++++++-
>  1 files changed, 7 insertions(+), 1 deletions(-)
>=20
> diff --git a/net/Kconfig b/net/Kconfig
> index 041c35e..31c208d 100644
> --- a/net/Kconfig
> +++ b/net/Kconfig
> @@ -260,9 +260,15 @@ config FIB_RULES
>  	bool
> =20
>  menuconfig WIRELESS
> -	bool "Wireless"
> +	bool "IEEE 802.11 - Wireless LAN"

But this also has WEXT under it which supports pre-802.11 technologies,
no? Might not matter at this point though.

johannes

--=-zBGM6uBjNR3w+UEhn5f3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKnT5VAAoJEODzc/N7+QmawlgP/Rw3OytbD8NAlyR+U2Bibnkf
wibZ/W+SrGonA0WBoRTPQKbZOEdgFg1qxSU4KqyrbUeShruOR5L6bq1qXZTsqdC4
G0WepRtyG35FidB9gZgGGWSKlfCvW8J31JXu+BE6AfQrIfKPeDCm4ao+Iy7borQ+
MfZ6rtDTAMAupzJ0UnM8HuGMeQdD/ZejtXOTcR7Y9Yk9I107voZLVL62ji1ZnlJ/
gYTW8jlxln2FFwmF3o2kMHqmWQ+f/7Pu2bFKgawGRQACrVTofcZzwm5/2v7lNaIa
HtN4EHDgtWbxba3fwo70GXnvyFA/bg7cRTC1wp2e5TaYsMbY4/Qy3cnntUpfd4TX
To+9vY+rz8bCajdFCS5GlXemZD4a8A2aKfqRP4VUIyROelcz1cxVR2Qpgj0KmGv5
8l8ulrp4ZUKXl2c2eWrzmnvbYpcAZQBNNcRr2wVsa3KozuBZAjLmv2LKy/NKgqVe
JFSc9iMcpVG9CkhfcKfR/Veo4SfDVw/soL0BfJz8bfzJOpImffX6H7y4GfKNNW3P
3D0LLMiqTqzkfFftecPfA3SkLTA1oQD6EIZEZrI3tnYu9MERZN1jIDHIVFxzG+Wt
TmfiAW5HO+r9FgUHZDrVdJ8L0PbuTpKKSpvgvhLU9553so5H1W2h3l28g93y+/ta
rU4U3pbPEZRPNfPs+dGN
=4b5x
-----END PGP SIGNATURE-----

--=-zBGM6uBjNR3w+UEhn5f3--

