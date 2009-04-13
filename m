Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:58176 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754748AbZDMJv6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Apr 2009 05:51:58 -0400
Subject: Re: [RFT/RFC] rtl8187: Remove some magic numbers
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Hin-Tak Leung <htl10@users.sourceforge.net>,
	linux-wireless@vger.kernel.org
In-Reply-To: <49e28a0e.w2E55OwYOA9yeg+w%Larry.Finger@lwfinger.net> (sfid-20090413_024115_059324_BFAA839F)
References: <49e28a0e.w2E55OwYOA9yeg+w%Larry.Finger@lwfinger.net>
	 (sfid-20090413_024115_059324_BFAA839F)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-ylUroZCRd2Mpn0VKI4ly"
Date: Mon, 13 Apr 2009 11:51:44 +0200
Message-Id: <1239616304.8243.0.camel@johannes.local> (sfid-20090413_115202_012162_3A79FED8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ylUroZCRd2Mpn0VKI4ly
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2009-04-12 at 19:40 -0500, Larry Finger wrote:

> -	rtl818x_iowrite16(priv, (__le16 *)0xFFF4, 0xFFFF);
> +	rtl818x_iowrite16(priv, &priv->map->FEMR, 0xFFFF);

That looks strange -- I can tell it works because priv->map is set to
0xFF00, but wouldn't actual constants make more sense?

johannes

--=-ylUroZCRd2Mpn0VKI4ly
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ4wstAAoJEKVg1VMiehFY8VIP/j/hrKJwFdsMQ0/ZaVJZufFR
B7/gt7WWN/YBhITD8aR4udffk0rH9ANdN6sBQR6hOGU0B1EdaMZikN4KdnIQNr4K
bAVrnNjQhTico4mjatnWOFEdpBxL1grMrfQJJxlM2jzZ33yzdH+3FXPISZ34gGmX
2dDWI5+FCO4v/88VgODqjiNRiigK0/n52V22KwkQ3D28n/LWzAi9f1DYNzKkCM/c
O/SMuvf7b+174yMDN9qML3WwgFaMYOS03cpuf4MiLnmNbEeG4idLgrJZ8tNJDCFJ
czE3i/oe9D82ps1lmKnyy6T/0ZlmREv0h5PJvBdKp/hqntrxxMDcRLU7bcG2Vtxk
759W1nMdU/h/J54PXS3hqh3HhunqoTCsWCgY2O+zQYHIO3Nn3vv0V4hO9C6aCQDo
Nhim+E4rCKdYMHAQslMVsAgjtYjvMVP6ItXpKFCHaAa4jIQZ3aTX58in2wLYOPku
6WH53B/UssltLLxgMIgCFkAp6t25XuQXUikvn6FyoZqtn/tPcrxYoxpzIyml1BQK
UTUYVwnkk5jD9volthxzyNe0yhO4vuMuoSms3UnbzU9RdSFzbmMiuS0Bni30hGEh
aaZVSlYhPQjGievCStQS/ji2Y96O11UoGmALQIVVtvxAFBpvIgYTunmxX1MKUBuz
75bjOJKx59pU7ZPS+Ae3
=u+gv
-----END PGP SIGNATURE-----

--=-ylUroZCRd2Mpn0VKI4ly--

