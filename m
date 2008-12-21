Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:37377 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751652AbYLUKhG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Dec 2008 05:37:06 -0500
Subject: Re: [PATCH 8/15] rt2x00: Implement WDS support
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	rt2400-devel@lists.sourceforge.net
In-Reply-To: <200812201057.02583.IvDoorn@gmail.com> (sfid-20081220_110214_294570_9C2013C2)
References: <200812201052.00655.IvDoorn@gmail.com>
	 <200812201055.58126.IvDoorn@gmail.com>
	 <200812201056.36218.IvDoorn@gmail.com>
	 <200812201057.02583.IvDoorn@gmail.com>
	 (sfid-20081220_110214_294570_9C2013C2)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-kKoTAaj1XqV3si/xKXIJ"
Date: Sun, 21 Dec 2008 11:37:04 +0100
Message-Id: <1229855824.4953.10.camel@johannes> (sfid-20081221_113712_311439_73FCD061)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-kKoTAaj1XqV3si/xKXIJ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2008-12-20 at 10:57 +0100, Ivo van Doorn wrote:
> WDS support should be very easy to handle, mac80211 handles
> everything for us, so all that is needed is to set the
> support flags and handle it in the add_interface() callback.

Cool, you're the first, have you tested?

johannes

--=-kKoTAaj1XqV3si/xKXIJ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJThxNAAoJEKVg1VMiehFYU/kP/jL9r3dTbxwnB7eOQ7t0uu2p
+48eMlpKHLr6DZY4c7Vyp9GDUBlQWz0FrA7mKORu86aKMxkAIAOM49c9OCJ5cmja
Q3I1QLFufNKOevmPr6dsyEhCDz4sF7Npn5RXz9CYuNCFg1gAzVkIp6rAqgTztNpc
2jijQaUAHneF8Ql200MS9Ghxfux/WzdDE+CrRvuwAkfn7aqOxTbwziznIcdkmAXn
gb063cky6Q8fJYgFZL16u7/JUQQteuf677QBj9OW5RIgHahayJUqGv756yf1c1un
nYSl+BfGBicEF8hZV/VzDEQizWmV6z3/dYQPr1ylvY5pB6BxqgEzmS19x/vywF6G
EigXdzXFvoQtpFZmTQeG7EZWI+cIUBseBOMtUhH0uiipqvVTG9DqAt47IYhHI+B0
ei2j9oCf8t27v5Lv9sAj6UhcRTrvQEGJhiZnRtvGwdBUOFfth+QVWj9GLfNXrkJT
vRr7Wb/k0vq+PiPq12E4hnt/WaLDBBorWIzS2vFngOssI1t+KTMUiFYmVqVRvsgb
1EiHpcTL6W+eFGcUPUI6f4y2m26CJQikIau031L9jeCAH2Vw4rcTqx4ACLN8HOQy
NTsgjQzEpxQQLPysTTtyCYsqj+bVsXgihziE3aQwywd1JZgWscHvAG9rkfWxcO94
mMGrHfe5CF9u9ZwkDGOt
=CaHJ
-----END PGP SIGNATURE-----

--=-kKoTAaj1XqV3si/xKXIJ--

