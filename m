Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:48256 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752054AbZD3XAI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Apr 2009 19:00:08 -0400
Subject: Re: [PATCH] mac80211: fix PS vs. scan race
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Kalle Valo <kalle.valo@iki.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20090430223025.GF9323@tuxdriver.com>
References: <1240434171.30082.21.camel@johannes.local>
	 <1241126864.12388.0.camel@johannes.local>
	 <20090430223025.GF9323@tuxdriver.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-ilDBV1SPOfGTuGooCFQY"
Date: Fri, 01 May 2009 00:59:30 +0200
Message-Id: <1241132370.29245.0.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ilDBV1SPOfGTuGooCFQY
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-04-30 at 18:30 -0400, John W. Linville wrote:

> Looks like this one (on wireless-testing#master)?
>=20
> commit da6cbb045d04706157d3117153b275ed9126bd1d
> Author: Johannes Berg <johannes@sipsolutions.net>
> Date:   Wed Apr 22 23:02:51 2009 +0200
>=20
>     mac80211: fix PS vs. scan race

Sorry, looks like I never learn... The patch still applied (probably
with some fuzz) so I figured it wasn't in.

johannes

--=-ilDBV1SPOfGTuGooCFQY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ+i1OAAoJEKVg1VMiehFYWfEP/j5WP/Q5Zj+REl2Cu9NFMa6+
9OZQIts2m+ZS556LFiJQhesyz4RCuzkwNdu73AfV3VlvcTgv1cjXeYb8XOOGoDXE
xo7Xqf3/+K4rG4SWZSRJlXI5sd3h3IQk0d+jkf6oFyiwEZv6KafiR7SYNY3PBsJ/
UwLqq6/pJQRPzZ5N2FwJijKxAQo6AdrA6PqN9HVG7iVsV/chFfMOW+8mhn83+wl/
rBFeTJwVmS9SgsjZdabukNOTedLP/8+EEEUsR+lwTwnyv265lqfhUvStWpUtlqeh
ecfMNoK6CuWXte97Ax2TvwAqxLYRUQQ1jkBlJsJxzx18IZE+aZmwrnMJpQppZs15
eEww/bOQLR1Fsfg3WI8rmxz9vj9JE+6dwov4O0REH8jshMccnTidcUuJ6wwx8gio
SOZMorfeQsxAcV9MehUcoVvablDPCD3hZEKfz4LHYvfW3G8PBEYz6l7+9QDFKIdr
JkzIj6384YODb/sZnAds3H4HuzTLXqjlICZhPSUdPqdm9Az4I78tTndh+f3K5CcG
kL0JbZ7j+kcQMi9fU+aRGSc/3a6LgJggenuFRHA67rNMC3Irfvp8xrtkjXehTC12
Qt+SfVU22xkgmx/kq8UjfLs3Hxpol8+hNr2TgDWE+aqEnpq/vNyc3K+yRo+Ts1ZJ
IREcFG9JmYZORqDW0BbQ
=aOJF
-----END PGP SIGNATURE-----

--=-ilDBV1SPOfGTuGooCFQY--

