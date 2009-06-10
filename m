Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:42216 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752091AbZFJPv0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Jun 2009 11:51:26 -0400
Subject: Re: Testing AP mode with WLAN-USB-Stick: How to obtain?
From: Johannes Berg <johannes@sipsolutions.net>
To: =?ISO-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>
Cc: Hin-Tak Leung <hintak.leung@gmail.com>,
	Stefan Steuerwald <salsasepp@googlemail.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1244648968.4178.5.camel@johannes.local>
References: <f76a32050906081007q19e9361w8c1fad6fc73c47e7@mail.gmail.com>
	 <f76a32050906081011o589474f2geba321c58c0872c2@mail.gmail.com>
	 <3ace41890906081659o23cb9ee1sd82ca4fc28a3793d@mail.gmail.com>
	 <69e28c910906090426l4c383665rdc4bffc501085661@mail.gmail.com>
	 <3ace41890906092018o76b0ee62n91819779a8ccd6db@mail.gmail.com>
	 <1244619027.18481.55.camel@johannes.local>
	 <3ace41890906100639gb800904td06d86efef90e656@mail.gmail.com>
	 <69e28c910906100822q6eae8b29p2381220b23b4f4b1@mail.gmail.com>
	 <1244648968.4178.5.camel@johannes.local>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-FrIlsUa5pzjmwF5Pch+b"
Date: Wed, 10 Jun 2009 17:51:24 +0200
Message-Id: <1244649084.4178.7.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-FrIlsUa5pzjmwF5Pch+b
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-06-10 at 17:49 +0200, Johannes Berg wrote:

> Now, it may or may not be possible to work around this in software by
> sending out the multicast frames on a high-priority queue right after
> the beacon, or something like that, but frankly I'm not interested in
> working on zd1211rw myself, so that will have to be somebody who is (a)
> familiar with 802.11 powersaving and multicast buffering, (b) wants
> zd1211rw to work, and finally (c) has a lot of time to play with the
> device.

And also, until the work has been done to determine whether an
acceptable solution in software is possible, I do not want to see any of
the upper-layer work to support this "BROKEN_AP" mode you've been
advocating. IOW, I think we should look into adding that only after we
have determined for sure that we actually need it.

johannes

--=-FrIlsUa5pzjmwF5Pch+b
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKL9Z5AAoJEODzc/N7+Qmae/QP+QG4zC0T5Re5b17q+2WUyuh+
e8TDV3z64HqpGcJD6jVwvFjLYOuD5IjaJLJlG1vTeNzdV6z2Eki+nVSa/zswv89i
nI1OUra/kGGFlBsSXfNLDlnLhjHSqp3P7HdDhTGV/IhgmBWNS0I8rWvC04XydcrR
aZwegF+TN7tZChU1YV4LblD8EyYOrNoMiRDyj4MOvK8ehCbQoVP2PS1LChOQpEKh
+Y6dosjoCCnBcS8+qboCIJkcOI14bEqGJf1ywpeSIikklKFyRIR5e7VYVmQ4d266
4P2Fbvw0PrL5zY7iddTL1Obzk3z569S2rcmK58Nv1WMNwamvulmCvmHOLaUTmhAs
bbJnU0sPwCDWydKqF5dvXb+6X65QaVJwLikP4PIWDMwku9IZZQ1HxM9KfEQpzXRG
c+pAizEZz7VtWQiAI54brrOuv74A9VAj08fJQZGCxeuUps1Hrdwo01WYsSoLrfDW
oZpvdU6PfIQ7WL1fpYkMhetNqpClrAytTWn/5vWPX9affszcT00IqJWsR8mY1KuW
s7z5xmFgysIOe1LxCkcxG8T7st/w4hIv1elo3Knr52GmX93C1H8XT1E9+0LtgNLj
FFgLaVp4IC/fNLGRsmVfiSD2g2IzpGSCgTAyuJhjUbTNYTlzr7sK68bJyl4nnku0
ml13ywq6qlBiroW6WeyQ
=YHdg
-----END PGP SIGNATURE-----

--=-FrIlsUa5pzjmwF5Pch+b--

