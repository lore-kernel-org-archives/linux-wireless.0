Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:46878 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753387AbZKPR1d (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Nov 2009 12:27:33 -0500
Subject: Re: compat-wireless and minstrel
From: Johannes Berg <johannes@sipsolutions.net>
To: Adam Wozniak <awozniak@irobot.com>
Cc: Christian Lamparter <chunkeey@googlemail.com>,
	Derek Smithies <derek@indranet.co.nz>,
	linux-wireless@vger.kernel.org, nbd@openwrt.org
In-Reply-To: <4B018B26.2070008@irobot.com>
References: <4AF0D54D.4090303@irobot.com>
	 <alpine.DEB.2.00.0911111508391.6214@kauri.acheron.indranet.co.nz>
	 <4AFC655A.5020706@irobot.com> <200911122103.27455.chunkeey@googlemail.com>
	 <4AFC8E4F.5090307@irobot.com>  <4AFC8F0D.5020700@irobot.com>
	 <1258097352.3899.75.camel@johannes.local>  <4AFDDF19.8060202@irobot.com>
	 <1258191039.6167.40.camel@johannes.local>  <4B018B26.2070008@irobot.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-H9hQxmqOENztikwOSc4D"
Date: Mon, 16 Nov 2009 18:27:33 +0100
Message-ID: <1258392453.32159.28.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-H9hQxmqOENztikwOSc4D
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-11-16 at 09:25 -0800, Adam Wozniak wrote:
> If we have only three stations in an ad-hoc network, where all three can=20
> hear the other two, only one of them should be beaconing, correct? =20

No, if they all behave correctly beaconing will be distributed.

johannes

--=-H9hQxmqOENztikwOSc4D
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLAYuBAAoJEODzc/N7+QmaBb0P/jGZ0mIBsN696nO4TmF2lTIu
McB2nGQfYfOqQ7c4eTBtXv80Ci+qsTFSMP2xvbZaFU26PDcc0x1mSDXpTN6M3oFv
fHPxF5WuY+hTaSQUtPRnap6neu89ssGAXBB4MAKT7OWktvzvvbGbyt+iO+Inpaoc
ua1o4W7mb7yhRkl4SKSdMNd+Rjie9Ew2WCgk1soZJ3g8WzbqBTrEmzoIE6uFynXb
YhPAP+oopQsqDqkPrW7bM7vIoB3u/xIZWXtdIZjmamhShA2v7ldswVD+d5tLlpvU
3M9cP5pU+M1mbVDJoChuD8X5gblBWRcuZ3TpoGSPgAyD2tuIg9RDxfwjCyqGx9BM
loEYpSpP3v6Y++G0vRF2iI+BaJeydCs/1INE4GxBanZuLb6waTakwpqc/2UkxMo1
u5Apz29wKJMh7osWBkI8UlLnl0yHsUGdwjiEphQIXqKNb57oi4hMiswqZ97Epgw3
I57psY9RWwh70wlYdxsHgowgeq3a/ZHdrl9vyZ5Oigu3zdXpe0KY7T0T/qGIi4Xp
A+NlVkMpsQe3XVaLe5zQ+fh6iAfAvibTc3u3ZeJUBSkfFFxOcmDVnOKawtq7tByd
LJL5E04usBQKssDfK+/7YTLflnCe0pqtan02H3zvSsGEcINV0wXxkhM3VXdqWzcp
L1hlBy35U1SnWeYLKGye
=bWdq
-----END PGP SIGNATURE-----

--=-H9hQxmqOENztikwOSc4D--

