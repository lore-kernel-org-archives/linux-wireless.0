Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41904 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754160AbZGWLuB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jul 2009 07:50:01 -0400
Subject: Re: [PATCH] mac80211: fix autoloading of crypto modules for WEP
From: Johannes Berg <johannes@sipsolutions.net>
To: Andreas Oberritter <obi@linuxtv.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-wireless@vger.kernel.org
In-Reply-To: <4A684BF4.9080802@linuxtv.org>
References: <4A677126.3040907@linuxtv.org>
	 <1248294007.19121.9.camel@johannes.local>
	 <20090723004046.GA8201@gondor.apana.org.au>  <4A684BF4.9080802@linuxtv.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-KI7Ietvo35LM9GuKHHlr"
Date: Thu, 23 Jul 2009 13:49:22 +0200
Message-Id: <1248349762.15647.3.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-KI7Ietvo35LM9GuKHHlr
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-07-23 at 13:39 +0200, Andreas Oberritter wrote:

> Right now, I cannot access the actual error message, but I can quote
> it from the web:
>=20
> From https://bugzilla.redhat.com/show_bug.cgi?id=3D443545#c11
>=20
>   ath5k_pci 0000:01:0a.0: registered as 'phy0'
>   phy0: Selected rate control algorithm 'pid'
>   phy0: Failed to initialize wep: -2
>   ath5k phy0: can't register ieee80211 hw
>   ath5k_pci: 0000:01:0a.0: PCI Int A disabled
>   ath5k_pci: probe of 0000:01:0a.0 failed with error -2

99.9% of the time that's because the module isn't present (like in the
linked bug report) or because people have disabled module autoloading,
by setting /proc/sys/kernel/modprobe to something bad.

FWIW, I have arc4 as a module and it always autoloads.

johannes

--=-KI7Ietvo35LM9GuKHHlr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKaE4/AAoJEODzc/N7+Qma0bUQAJzJnjfOPEBrlFCa/vgNJxs/
QjcAxw/PbgdfTglgjG/y/I2XUJ3DHbqi+v8Lb1mJwWPN3kG3/xFkOXaX3w13mSZb
M5WRErysGL16HATjiPJVsxIc3w1gJ90kkVhqLkETgWYF5Y+3bRpl/47myjr5PBnJ
g2m9QyGcK9dQQwseChwjX5/0lZi1AAWGi+znz5vmzWZIqZe/tq7L4+7AVXD+64C5
pPrh5xj4C4F/Dy+MP6CeqyDwGY4ap9843qLcMGLzd5MVXFefdXqMOJ2qfUNSBgxp
ZZt+EJEj+VKjHSYKKNCFtjDfCo3zitiFyk2AM+vFKYuJO33ENak5WdFf2IfSc0CI
gKbje4rlxqdmL0F1oWHq2S00OfIyTRnmP+T1yJSoUcF2fsD5M+7om0yCckUh0Erx
Dfd0v3/O22igBEyn06HJcBK0HBrH+/9cjrKUa+qWKkE0cA5b1ciVLgCGOEmFE5Vf
T1iLKlaTTpH4pXRB/R7qp8gi99AU8mhDK3GoeHHsOQOl40PgW7jNyKL+R+CrA/Nn
s6Frmb/n2DZgS/HcUTw1S+htGWAAUSegIC0TFtIvQgJ0aCsTI4LvieURWg/Kkn4Y
kd66kj1NBD8vzeM+Cdnu9IWqxMJTv+X9tnG8FJZ4KzjOCyQLMIANoR/O2QERh6s/
D0SQClrQvBG1aECMCsG7
=9JJJ
-----END PGP SIGNATURE-----

--=-KI7Ietvo35LM9GuKHHlr--

