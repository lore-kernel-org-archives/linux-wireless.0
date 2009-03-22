Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:33649 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755320AbZCVUPk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Mar 2009 16:15:40 -0400
Subject: Re: [PATCH v4 0/5] mac80211: beacon filtering
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Jouni Malinen <j@w1.fi>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20090322195619.26460.48292.stgit@tikku>
References: <20090322195619.26460.48292.stgit@tikku>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-uzBkWNWMvYM+s6/FJZGx"
Date: Sun, 22 Mar 2009 21:15:30 +0100
Message-Id: <1237752930.19647.5.camel@johannes.local> (sfid-20090322_211542_595774_430FB52B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-uzBkWNWMvYM+s6/FJZGx
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2009-03-22 at 21:56 +0200, Kalle Valo wrote:
> Here's my proposal how to implement beacon filtering in mac80211. The
> basic idea is simple, the driver enables filtering whenever mac80211
> enables power save and the driver calls ieee80211_beacon_loss()
> whenever hardware informs about beacon loss.
>=20
> I have tested this with stlc45xx (with beacon filtering) and iwl3945
> (without beacon filtering) and based on simple tests this seems to
> work. For reference I'll send the stlc45xx patch as a followup.

I'm getting bored saying this again and again ;) Looks good to me.

johannes

--=-uzBkWNWMvYM+s6/FJZGx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJxpxdAAoJEKVg1VMiehFYUkUP/1+F5y/Pxwv/JpOTln/xOzoV
uMSB7QDD/LtiJse+e3aIJU11DVS+HQjXs7dWI+5GVfpSOaq6wrfyI23WbOcva0ow
mHWGQ02d9pxI9aCTjZyaxQn/thyd9nC94ydInJyExYlYRqmFPt4MGPUdgMGZdJrE
wDqYu2W9eVDZVbNPNPv9yjdg2xW/UNBZaz+nvkM7gC4qNLo6mkBBolHdsMbKiV/R
SetTzXTptQYgGK/Y+Cm0+jJJh3i3mizqF2g5mXQddSN6dc5YHRuh7j+qlKPwybnQ
aEYk81w96e8+Dvt96QOWxGzIk7+rGYJlL2z2lsn7Lrrc9eJcJas+r9AUWJirhaps
ARJbJJm2mf+eF2coAiUiFjCY3XKdkVLgZniGInSxfe2Jh3LtcTHqe+cCQlrOYBAC
6r5B0lV/8JDvypXAnEC/eQGUKhUUfWFEKV6/cXRKD8SfX5Hqh8SPpeB2LIkVD9hR
GR5bqCgqQQzhxWkrDHzI9uUeHAGq1GoK3sQUAIrLKLGia4Zova92sp3sa9fBYG7i
6nvFUsuVRg6/sWAIBupWW5CxJZPl54A91qt/rN5NHZJ82aWy9s/TVit8bGkxDRe/
b+tb6up1L+2IfuzZ4KGBudepbciMIg3yhDLzsj8kO/ZDUiCgvwrZtXhmlNPz9eCh
D6D48O4sDL5w1k0Q0bY/
=rtKb
-----END PGP SIGNATURE-----

--=-uzBkWNWMvYM+s6/FJZGx--

