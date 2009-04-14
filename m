Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:34054 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752561AbZDNSYT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Apr 2009 14:24:19 -0400
Subject: Re: [PATCH] rtl8187: Disable TX retries if IEEE80211_TX_CTL_NO_ACK
 is set
From: Johannes Berg <johannes@sipsolutions.net>
To: =?ISO-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	Hin-Tak Leung <htl10@users.sourceforge.net>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Hin-Tak Leung <hintak.leung@gmail.com>
In-Reply-To: <69e28c910904141109n4aa5cf20k39d1e75e33907977@mail.gmail.com> (sfid-20090414_201034_301771_08F469F4)
References: <69e28c910904141109n4aa5cf20k39d1e75e33907977@mail.gmail.com>
	 (sfid-20090414_201034_301771_08F469F4)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-kuU9GiOSr1WyH7QdoWms"
Date: Tue, 14 Apr 2009 20:23:32 +0200
Message-Id: <1239733412.24771.13.camel@johannes.local> (sfid-20090414_202422_927560_7873E35C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-kuU9GiOSr1WyH7QdoWms
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-04-14 at 20:09 +0200, G=C3=A1bor Stefanik wrote:

> +		if (!info->flags & IEEE80211_TX_CTL_NO_ACK))
> +			hdr->retry =3D cpu_to_le32((info->control.rates[0].count - 1) << 8);
> +		else
> +			hdr->retry =3D 0;

Umm. You obviously didn't even _COMPILE_ that patch. Let alone test it
properly.

johannes

--=-kuU9GiOSr1WyH7QdoWms
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ5NShAAoJEKVg1VMiehFYcCMP/1XjuEphtjVYF7+5PNI5Gf/x
TKTu4ALwE2DjMGKAiYHLBtXpKwgRKD6chKDqH3g2LCmNsvgsH+KkuDC+ohyRJbgg
n4lBJHDjZ2JdiLeiQOr80CJ4LwTRGvY9UiW2YtZoNErGscFS91r8X6/ittClR7W1
l3/K/Rx5hmin1Ly3CZzlH3803B+Qyd82qekiZn66cbJZQ3jQkHBxF7VlzpseTdcU
PLNJDKLWa/r9DOfVdlpmIuyjOuROqaFeLuJVqRhunbHYAXeZrEBZSVzTTspbJZ0v
O4lZ0a0w4QQxgfkP46T2w2dc4IxYs19NBrDAcF9pYzt1cW0UyrNHNLRqTEuwBOC8
SpWt/3owNMyibE83lIt6k83kd5x9D3PgA2p95yp7f2SiOfZWJc3ovGNBdtwPlqxF
7JOR+igNKTlQMw1+PTkOb1rB33lHsUVEXFKvALWx0vaxTqHSCwCSPx0rhLqjsc5h
2a3kk/w0FKYLwJSZrXxwmmvpCzjBYAl3lFmMLKNrZ1089oAyz+kbesKEW8ARisZP
XKkoQFgGQMrGJJwqOlIW+rPc+RYa/V/sfcNQ2NUAhuWYnZhsC9Vd4zj0DuYUUgmy
UKYepflOsF1VXh1LY1pCSRFSVY6Xk+OpdIHcwK4FOVr/QC4MI7GFrI3ScuPmnkMf
Ypcrt5nepVrJqeVaeKp0
=SkKw
-----END PGP SIGNATURE-----

--=-kuU9GiOSr1WyH7QdoWms--

