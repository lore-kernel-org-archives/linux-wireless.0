Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:45219 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933188AbZHVS4H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Aug 2009 14:56:07 -0400
Subject: Re: Broadcom BCM43XG Master mode?
From: Johannes Berg <johannes@sipsolutions.net>
To: Nathan Kennedy <nathan@flidais.net>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <4A903BEB.4030606@flidais.net>
References: <4A903BEB.4030606@flidais.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-CMqvItRwkVgdw6LXAqEw"
Date: Sat, 22 Aug 2009 20:56:06 +0200
Message-Id: <1250967366.23605.23.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-CMqvItRwkVgdw6LXAqEw
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-08-22 at 11:41 -0700, Nathan Kennedy wrote:
> I recently purchased a Linksys WMP300N that has teh BCM43XG chipset. =20
> The only driver that I've gotten to work well with it is the wl driver=20
> from Broadcom, however when I try to set the wireless mode to master I=20
> get an error that the operation is not permitted.  Is there a different=20
> way to get this card into master mode?

If you're using wl, then we don't know, and you have to ask Broadcom.

If you're using b43, you start hostapd.

johannes

--=-CMqvItRwkVgdw6LXAqEw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKkD9DAAoJEODzc/N7+Qma9iwQANA0+tt5XsceUor6ovrr+haJ
xO81MZvh2Xgf49JfIzv3YK9nn1pvf+18zYvwqnJFN/DmwrHD0PEfsgV2i6JEZ/QK
vFpVz8KrOr6qq+4ZRzSIIvU0RIbb1DAzJxMXi1O8PWWoCq67XKN615mbU6NF6s36
Zl0t+W3y60YHxZpy3WXGI8GYOpZ2cI/JGSI6mv9fUEYnPnw3mbTie3tz0pd9b22R
0/YR9x0pb7JG7exOMLsHZXkHcWFshx4mOSm8D+1sPuNml20aqDh9XJ/ErYb6PrU+
W9ByA7ugkGz1c9VBaxarOt6QkISSAWpzwB/ahXshPLhtbFLAuGbfBaSnxbQjVusi
4MaY6ZGVWFkfb4ZFi4N+QUCkNE6atBjfVuIuC+7VlfC7JmIkT4NBCS9tYWCr30WH
swdgJRuePIpnwctyeLFetJ8ZyrapdAg7wxoqh5wAqAoy7cQ/lmTeItv9YcWtjA6K
xlG7LulsmKM7ZtTGZqeJ8s3Hzn85yNk0Ffz9dZqjo6m/WVX1Pk2x0aSD0lpHFhsm
/JQb1JiOp1/3RLaOr1/a/SzkNgWprrSnEJkIGTLqmSqisRnX5hWj8LZOq+i073cd
rObJfQb9XzVNcBuDal6rzlJsDLLJLMgHwf05Bi6bZu5nPp7W1RPWW1Y8DWNQZXEs
spbKGFZ3cCCOncmoOgP5
=MoEK
-----END PGP SIGNATURE-----

--=-CMqvItRwkVgdw6LXAqEw--

