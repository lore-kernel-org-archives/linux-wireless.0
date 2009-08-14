Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:60880 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754804AbZHNVJR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Aug 2009 17:09:17 -0400
Subject: Re: [PATCH v4 30/34] wireless: update WIRELESS_EXT kconfig entry
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Larry.Finger@lwfinger.net
In-Reply-To: <1250281559-13041-31-git-send-email-lrodriguez@atheros.com>
References: <1250281559-13041-1-git-send-email-lrodriguez@atheros.com>
	 <1250281559-13041-31-git-send-email-lrodriguez@atheros.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-EOXhcESbB92P4B+MUPmi"
Date: Fri, 14 Aug 2009 23:09:15 +0200
Message-Id: <1250284155.4411.2.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-EOXhcESbB92P4B+MUPmi
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-08-14 at 16:25 -0400, Luis R. Rodriguez wrote:
> Provide more documentation as to why its being deprecated.
>=20
> Cc: Johannes Berg <johannes@sipsolutions.net>
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> ---
>  net/wireless/Kconfig |   12 ++++++++++--
>  1 files changed, 10 insertions(+), 2 deletions(-)
>=20
> diff --git a/net/wireless/Kconfig b/net/wireless/Kconfig
> index 60dd09e..b07ed2c 100644
> --- a/net/wireless/Kconfig
> +++ b/net/wireless/Kconfig
> @@ -86,8 +86,16 @@ config WIRELESS_EXT
>  	bool "Wireless extensions"
>  	default y
>  	---help---
> -	  This option enables the legacy wireless extensions
> -	  (wireless network interface configuration via ioctls.)
> +	  This option enables the legacy wireless extensions.
> +	  Wireless extensions was the first 802.11 wireless configuration
> +	  API used by the networking subsystem. You will not need this unless
> +	  you have old userspace utilities or old wireless devices which
> +	  have not yet been ported to cfg80211.

I cannot agree with this wording -- all current tools still use wext
unless you go really experimental.

johannes

--=-EOXhcESbB92P4B+MUPmi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKhdJ3AAoJEODzc/N7+QmasvkQAM6mXJxwNAIxCpUFnFvL4sqV
GdIfKHI/AHVImy188r+opAMwrKR5mqSvqpFhxextXX26RBrdtxpn1RyRncmcnMB0
B78IaAXA+ub9Vw/T+F1Q/JFcpgK28dNl/0Qu1KIsQVGlXv339jGBqi6rrSMkGv6+
Se1GaKicjCZ/MJXQ+WWJfRs8KwIMbyf+h94yA3aeJA3fT//zATyWaqBfCPbG/sAS
ARdivwjGbJ0Ju/vEGkmFumPgWykdQhQljDHq0nj9N8irjw57AsUM8RfdX5l4R/el
AJtrz7aQlKvjQIBwpPHUMUycVCtSWSdPMiVV3luS8OyGo/yzuDGGbGhLAp8QEABb
Ni3bT87bIH8m9NNIGWkGH62/hQV793iEV67AreplH2ha3rd/xXmT6UMea2CPcohi
wKiMbHtOPHaGkmC9t0Q6HiWabIlvPmMmrmolgN64FcpeCQxNjlot+PasbD+pNkJW
nDdKZTEShApUamK7UEd4Dl5GXsDs+U1U6OVqMMJUspbE+Q+TCgHuEhCvWNvQpSgd
TP8W7v08Gjnr8o7QmEVB+LXckSVP95k+vZdyy/+kaPbJ5KC8INqv5JcyNQ0A6Hjs
Ifu3eF98nFZ/k3x5MGnNCutkxg6W223rMMN8Fe4k+1/c/BD6dRsjCv+wvU0PEizd
RHfGYMKgY3YQNcFPlKTp
=YdjQ
-----END PGP SIGNATURE-----

--=-EOXhcESbB92P4B+MUPmi--

