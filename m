Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:50962 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890AbZDVRZn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Apr 2009 13:25:43 -0400
Subject: Re: Using wpa_supplicant in D-Bus mode with nl80211 driver
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: Marcel Holtmann <marcel@holtmann.org>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20090422170852.GA7298@jm.kir.nu> (sfid-20090422_190902_787643_D1BB9D20)
References: <1240419177.12282.3.camel@localhost.localdomain>
	 <20090422170852.GA7298@jm.kir.nu> (sfid-20090422_190902_787643_D1BB9D20)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-tFwgXuxbsXG429aYLg/M"
Date: Wed, 22 Apr 2009 19:25:08 +0200
Message-Id: <1240421108.30082.8.camel@johannes.local> (sfid-20090422_192546_778496_CDA2628E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-tFwgXuxbsXG429aYLg/M
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-04-22 at 20:08 +0300, Jouni Malinen wrote:

> > Can we fix this somehow? I really wanna get rid of using WEXT.
>=20
> There still one remaining WEXT operation even with driver_nl80211.c in
> wpa_supplicant, so we are not yet there, but there is work going on in
> getting that added to nl80211 after which point -Dnl80211 (or
> -Dnl80211,wext for more likely distro use) should allow this goal to be
> met.

We also need that message when we abort authentication after three tries
because otherwise wpa-supplicant just hangs there doing nothing and
mac80211 does so too :)

johannes

--=-tFwgXuxbsXG429aYLg/M
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ71LyAAoJEKVg1VMiehFYex4P/0vB3z72IBBvNcTkrDX5lfRu
4kwT2bSzQySm0tWjWfwn9zPNA0GBIoWtYxkAANTRQ6RDbf3pGxfYVohKAcDWUQ3I
UM3VIw5mMF9aTR8CWuT0BI0GXTTJXOhZWF4p0sXEinQPV6wrDmT73bAdeLmFofJW
7dK3hy/LHo5uYDqu+o3gvwUf8JouHhEzZ0Z69nrlA10dc6SPUmNji3qT4/hBCInl
wmVlDqtUQyEbFp1dQ6N24hI0DZJolwNezCHkppiQbA4pLVXMOj+8lERku9y1Fl0P
pN3ZyS+1y5YPxGurOb/NyGTeK3GmWgbGnfirW3bvZAjVPq9syijYeI6rVk5ceZT+
UM86SZvKDhPYQH75nNU921WF3ZbpvYra7IJ3ax1OOwtsFXVb907+Y3BT8F7OHl3L
sqU2VB1SXLwmjEkEN4hTXUpnVGMi5a58md6PR9zC4UQlmkcYhz5LXE+tK0MLaOzo
NkF5fYBoCV3of9bevu2xOBHpS2XLfBrbeuF/MrASNwYGBIqR56NGiytWPVPEX+uA
NQ3kzetvuZiV5kNoKL52AXr4S3g0xwV+DlS7b5tBMmI0e6Fj2odlXgYts5yqXl1g
Hy0XQPs1XTk2nGETWxza/ZiH47Tg1PiipGtasOKp7YGr8f/67ex5uYML/K21YFRd
VReZIxQiDuYpT0Nceuys
=fv8p
-----END PGP SIGNATURE-----

--=-tFwgXuxbsXG429aYLg/M--

