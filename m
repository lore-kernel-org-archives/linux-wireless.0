Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:48735 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752851AbZEDMLc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 May 2009 08:11:32 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <johannes@sipsolutions.net>)
	id 1M0x19-0004An-E1
	for linux-wireless@vger.kernel.org; Mon, 04 May 2009 14:11:31 +0200
Subject: new iw scan abilities
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-K+3ccXMK9Z9kiAILMB/x"
Date: Mon, 04 May 2009 14:11:00 +0200
Message-Id: <1241439060.8683.41.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-K+3ccXMK9Z9kiAILMB/x
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi all,

Just FYI, I just committed the ability to say:

iw dev wlan0 scan ssid "" test1 test2 test3
iw dev wlan0 scan ssid -u test1
iw dev wlan0 scan passive
(which is the same as "iw dev wlan0 scan ssid" since that gives none)
iw dev wlan0 scan freq 2432 2452 5785
iw dev wlan0 scan freq 5785 5200 ssid test1

etc.

I should mention that the freq parameter is ineffective for iwlwifi
right now since that only looks at the SSIDs currently.

johannes

--=-K+3ccXMK9Z9kiAILMB/x
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ/ttRAAoJEKVg1VMiehFYxXUP/RgUR1EXo764B9yDwj/yiibg
jHXXRRGgw5jAYTBTa6f5ZDzGEn6D9vurm7LKAFKAK54Jj5VOgpi7HRf/uug6oqEQ
hm3wlha63zsYqN5KzNvQft4Nq1TSfCBdEXswc95cdJtYEGlob6QSy6TwrMoOl6fK
qu4qTfPmUc+mx+kbRV4XHSQYKnDW6uemte2saXrybzBH9HYYrq2J2g3bwn5r/XYg
GWPxglrJHnkLVQ/4o/0/WusovJ6/XcBEBZsKusjdtM+qU+Vnh5QN1+WeqInXdHGF
+R/By7gNsjsxWUHWnqMvQuTbZcR0rk7V4vOP7saYknXw0876MPqyH6FLjqziVuRS
cXgh2BgM0RKYQdo9dJqLVa4NOr/Em3yT70M9v4H0/MKUTXNLgkEXaKc7yjcQMOns
wdB3G2br5BIE86Q0TuE4VvBEhzDum/s+U2CTekuYHFgjLZA2lWLzSvLhx52rxJLZ
l1F0usfTK2g3dcQlp+gwE1EBowSlGrWiyb/UZnUp9WGstwy86B9MQr6+CvM19Zpw
9iCjI/DyzmbDp/htKkdKKDYQyaz6HqKvjDHbSyrE/5oKCp38x5U41Tx9Z2ZrwHON
ugp9aSnrlgLJtKHLOg2DPoCa7BI17Hh/DPZwkQFoHbwaLLWP617nX/VfAGrxdZH4
9pn496ESKAbJe2ioIEJx
=jTwR
-----END PGP SIGNATURE-----

--=-K+3ccXMK9Z9kiAILMB/x--

