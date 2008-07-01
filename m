Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56381 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753711AbYGAKYh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Jul 2008 06:24:37 -0400
Subject: Re: [PATCH/RFC v3] b43: remove input device usage for rfkill
From: Johannes Berg <johannes@sipsolutions.net>
To: Adel Gadllah <adel.gadllah@gmail.com>
Cc: linux-wireless@vger.kernel.org, Michael Buesch <mb@bu3sch.de>,
	stefano.brivio@polimi.it, Larry Finger <larry.finger@lwfinger.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	Ivo van Doorn <ivdoorn@gmail.com>
In-Reply-To: <6cf6b73e0807010319x88f3624x83465cc314d8962f@mail.gmail.com> (sfid-20080701_121936_702983_AF90F1DA)
References: <6cf6b73e0807010255x1f2d8a21m8ed3e712012ea757@mail.gmail.com>
	 <1214906304.7763.34.camel@johannes.berg>
	 <6cf6b73e0807010305ne1c4b3bwb083c25953292f9d@mail.gmail.com>
	 <1214906908.7763.36.camel@johannes.berg>
	 <6cf6b73e0807010319x88f3624x83465cc314d8962f@mail.gmail.com>
	 (sfid-20080701_121936_702983_AF90F1DA)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-41JEzOcju7PQSeILKJOL"
Date: Tue, 01 Jul 2008 12:23:53 +0200
Message-Id: <1214907833.7763.38.camel@johannes.berg> (sfid-20080701_122439_805313_12866532)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-41JEzOcju7PQSeILKJOL
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> +	rfk->poll_timer->expires +=3D round_jiffies(B43_RFKILL_POLL_DELAY);

Umm, no. Can you please read the docs for round_jiffies?

johannes

--=-41JEzOcju7PQSeILKJOL
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIagW1AAoJEKVg1VMiehFYBhQP/3iMFMQTazQkV5OvHBacCnbw
gB7WCHii+K+1gy/WyPr91nLRBdwhho9xccs0MgpZIgmrOXhVyWL7UvcslhW0sS9O
ty6OZ6HFhkoKa0jRTpEM2sCCkdkg6sw84edYyzcZJeABa+9p7NsNv93iKAObphYa
SOYAObPowKkogfOlwJYkmXFQ4EL5NAAQ63IOYaeu/swE1g3d1sbwKBUBm5cP+/eM
Bcq8Z8CstKJVCaJ2jBA61NCiuYKbC9IaUglL1ecqP0tgvFAU6FykkEXXXbAf1zMT
EtSKNqt5fSAfXfpLU+Kax//XPkSD7UC/pdSs7KUr2/JGMC7OPDOETaYrPbXJ0oP+
j8R1eYofpOWzpWAKDwIHWCw/jP7+RTuCl6lujryKt9uwu/V1d4u2vsTZmjgaoH1h
wv2bMUEKbHEnngVGko2iIaLqxt1ktZ3WPDoBLLLH2JozD6HVYFRe9M5A5nfacqR5
gJMJgB/9SYNFuJjPbeUe0WdG4Z4nCSEmJHcXSNyqalzVE9q4hNxh3abBgGIvJyie
NMNPPZ1114mCDytpzrjf6fszF2HjqdpMe0TSDLm5eHGHZnQpjaUrXPOpzPl7VLoU
oAnpZiXuvlcbpnWX8hM8+HbDFqhrS62JqvlAutf57vjMSvXu4/6MHbVDic0IDIlv
p4tKXhy0z2qUrA2btZr4
=v1i0
-----END PGP SIGNATURE-----

--=-41JEzOcju7PQSeILKJOL--

