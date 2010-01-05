Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:34562 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888Ab0AEKYQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jan 2010 05:24:16 -0500
Subject: Re: [PATCH 4/9] mac80211: create Probe Request template
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <874on0x3gb.fsf@purkki.valot.fi>
References: <20100103210552.29287.20384.stgit@tikku>
	 <20100103210749.29287.96141.stgit@tikku>
	 <1262683265.20098.7.camel@johannes.local>  <874on0x3gb.fsf@purkki.valot.fi>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-M4ftGG0t8dReBx/AQc0o"
Date: Tue, 05 Jan 2010 11:23:09 +0100
Message-ID: <1262686989.23910.6.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-M4ftGG0t8dReBx/AQc0o
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2010-01-05 at 12:15 +0200, Kalle Valo wrote:

> > However, there already is ieee80211_send_probe_req and
> > ieee80211_build_preq_ies -- shouldn't this use some of the new code?
>=20
> Yes, patch 5 does this.

*rubs eyes*

Indeed, sorry!

johannes


--=-M4ftGG0t8dReBx/AQc0o
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLQxMJAAoJEODzc/N7+QmasQcQAJwjevodwIAc7DZHqiYsKyNZ
xzXFpwamLEUjThTvn/6lkTsnwresEw1svb33uoB2QSVRjjEhfI16WpgsOtiLBez2
uiW84AIGNgdvJ3fs6IC8a0McPGOk1XweQmH3MYIhGwUY31SAH8op7UCK9UJhRwyB
oQkbpeOAbCQHh8Kmq5qqthb8uNYkMjnflHeKDrELEtFJ3njFTJMKUOT0J+oKwkyn
vnmxflQDoSBjILpDC5C4h19P0/cAXmbm8UT7Sx5Mtdd01zXwVhqkRcNJ0+2yIHsi
7DrRE9h1V7RrJUaSRFmi9BCaSN88Qqhxa5ZhQaOgygaXpRbjTLiUMB+4FhtTZhZ6
Cd6bHdGJBLaWag8mZ9Pk2H/9Zcd/WX2yi1ScU4RVQzIky7hiUsX2COFJ9o3YxyrD
dZfUoih8155eVxi5Mk32AbNmqEiMrXUiwnftlGTmj6H+5S2rw/5I2v1LGfjJ0Rxw
goBzwBjLBQT9xWNQtdTYnVnqsqxQiG1hIgP2WOjPx8HGCjx0oi7bPhY57gmWN067
HuYdYfg9MPYqko1DNwo2eWZX5413ctMfs2CKyOgR3p7F8XDKJ6ZayFT8GEWHoLMr
/NyHPDb6FZ7xffkiUGw4D+YG+n9mx2VnXBDajWgb5c8LqSffTxP0XA6amTholZqS
objjDuLo8lXq1YrZ/ErY
=BHlh
-----END PGP SIGNATURE-----

--=-M4ftGG0t8dReBx/AQc0o--

