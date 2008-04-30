Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:38758 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759914AbYD3UGs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Apr 2008 16:06:48 -0400
Subject: Re: [PATCH 3/3] mac80211: QoS related cleanups
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200804301929.21347.IvDoorn@gmail.com> (sfid-20080430_192528_226096_53B6E431)
References: <20080429151858.253229000@sipsolutions.net>
	 <20080429152042.544902000@sipsolutions.net>
	 <200804301929.21347.IvDoorn@gmail.com>
	 (sfid-20080430_192528_226096_53B6E431)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-O1YtEyJI9wGGFlJujUAP"
Date: Wed, 30 Apr 2008 22:05:56 +0200
Message-Id: <1209585957.18659.90.camel@johannes.berg> (sfid-20080430_220640_852323_5463A26F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-O1YtEyJI9wGGFlJujUAP
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> >  	if (unlikely(queue < 0)) {
> >  			kfree_skb(skb);
> >  			err =3D NET_XMIT_DROP;
>=20
> With queue now unsigned, the above check will always be false:
> net/mac80211/wme.c: In function 'wme_qdiscop_enqueue':
> net/mac80211/wme.c:219: warning: comparison is always false due to limite=
d range of data type

Odd, I wonder why I never got that, good catch though.

johannes

--=-O1YtEyJI9wGGFlJujUAP
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASBjRI6Vg1VMiehFYAQKznA//TSFn08o5YaIOkTmWNlZen0yj2w8gJFsw
pdb2VXdxrhlm3UD8vdU0eSgZ6QegAHzv2wrHv8JarfMaSP0LPMmy/o+7GNwV+pCA
ZHX83OtZaXLfrnZ3egawgxYOGzmwYBS5m2CO7UC7YOB7jdew2+1D2OjqBehQ4m/F
dNBPckAtZU9ICiPsvDK7GH9qn5wI1KLs+1VkluOyH3vkZ7/vc1jPXWL+QnQbrfZC
s1cb6NqrTuRRnhi3jtqAboY5rho2gCwZv1iLzjcAP4dlUM9C6v9YWMog7iAaKsew
7gcfLRkKvAj44erCfo6wSjTCRRhNUC3e7Xvynv7i7PjgXUckdxbEUtxN/27cOHcw
Cl2VC0Hh3OSm0HaUE4ro7LLWGISWsxEIhyGnfVaA5jfQyRh4YCEYDVsr0OFa3pVI
StT5dzqCe1CO8LsSDjLyEzAe2oyVDMC44Tb8AKsoVMPdKlppUsbe0Jm8w0xCyylW
OYJ9ILNdcwcgFubj2TPADIPb+s3rqVr53tNAexK5X8g+PYgGD94Lz6DX0FwNlKPm
IxkyjHvlJMIkXlhFM7F/TkKHbsOA6UCrqYZIN2ql40wqKi7mJfHHjbb+bmaL+prL
4vYIJ2LcdseT5he4jmdle3DzM5YKsUyibSpV6JvpffMEre05y3uUTVd3NahyF5Cz
/pdMCTcXsZI=
=SB1u
-----END PGP SIGNATURE-----

--=-O1YtEyJI9wGGFlJujUAP--

