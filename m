Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59058 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751084AbZIXJxw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Sep 2009 05:53:52 -0400
Subject: Re: [PATCH]: nl80211: report age of scan results
From: Johannes Berg <johannes@sipsolutions.net>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <200909241055.51604.hs4233@mail.mn-solutions.de>
References: <200909241055.51604.hs4233@mail.mn-solutions.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-sWpfF6uHaobrSBCtBlEA"
Date: Thu, 24 Sep 2009 11:53:54 +0200
Message-Id: <1253786034.3868.18.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-sWpfF6uHaobrSBCtBlEA
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-09-24 at 10:55 +0200, Holger Schurig wrote:

> + * @NL80211_BSS_AGE_MS: age of this BSS entry in ms

I'm not sure "age" is appropriate -- the BSS entry might be older but
have been touched in a new scan etc.

Maybe "last seen"? Although that kinda implies an absolute time while
"age" implies a relative time ... hmm ...

johannes

--=-sWpfF6uHaobrSBCtBlEA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKu0GuAAoJEODzc/N7+QmaOZEQAJQ5yfDJd/He3amuDw8iVyzO
JqSBtnrgK/psfzADXH9LQicKz+PVXj7vggcNWk/WfXklwyeoc4kfu4X6thMySSOv
TthFwKdV0v7utattR045qWGXdohoOFbV1G28mKWB4M5hzfW1+qUSkb07C1vevm2u
iqtm0aKJkTC5XjdRtMtd0SMDWkC3IW7QRlEBLV1U846xOkoRQjRQeuYTiYpZD7h6
SnBN1y+eZk0Rwh51PL4T5s0TiAThcXGLqBhvFCCi3EWODoXcNkHm2+8H+JzMYyJl
0w7EByczHFLMpIhOodYQTeRlwwf3NQ7+iqCtOa0qEBsXW9YCsbYo19ZeR6QbcKOi
KY4WS1gQyPk3AYLojGWLSyzcU5N0wrrpMZZUl8ZYjOsE198VbQBy0yINMgnsxG18
8eq+gcHXMin5qJsuiezLnCO6GnY+bTzhoSPjH14Yr3BaLMLDrQPZlUqTn+ktfksB
E9RT30qpw21EjbPAdGrUE+kfipMFhB6uyF60RLEGgURQINrz29gcVrlkJLqk/vwR
WgBWbxQMVW97ONl6FJZQpykqsUUmpgxfJmB/OUtTuXeYuPFWcdoEIs5V2L8HbiVr
2DfNLP6GTscU7VNFBsYYdKhaALkI18nUFV2LYhnKnZw7NOiRFLJXzR1HsHpj8Q2S
IBgRiqpwfrM6IdlimJ2K
=SmjS
-----END PGP SIGNATURE-----

--=-sWpfF6uHaobrSBCtBlEA--

