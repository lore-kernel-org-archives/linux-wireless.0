Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35218 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217AbZK3Lv7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Nov 2009 06:51:59 -0500
Subject: Re: [RFC] API for setting ACK timeout
From: Johannes Berg <johannes@sipsolutions.net>
To: Joerg Pommnitz <pommnitz@yahoo.com>
Cc: nbd@openwrt.org, linux-wireless@vger.kernel.org
In-Reply-To: <559043.79161.qm@web51405.mail.re2.yahoo.com>
References: <559043.79161.qm@web51405.mail.re2.yahoo.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-Jd28ZPZKEK/JnQbfQKCF"
Date: Mon, 30 Nov 2009 11:04:22 +0100
Message-ID: <1259575462.32171.6.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Jd28ZPZKEK/JnQbfQKCF
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-11-30 at 00:39 -0800, Joerg Pommnitz wrote:
> Felix Fietkau wrote:
> > At some point, I will try to come up with an implementation for=20
> > ath9k which doesn't involve such voodoo, but instead compares=20
> > the tx timestamp of some data packets against the rx timestamp=20
> > of ack packets.=20
>=20
> Would this mean, that we could get per station ACK timeouts?
> If so, this would be very useful in an IBSS network. In such an
> environment one might talk to nodes whose distance to the sender
> vary over a broad range.=20

Not likely that _any_ hardware supports that, it'd have to modify the
timers all the time. I suppose some firmware _could_ support it, but
it's a huge complexity for extremely little gain. In any case, setting
it to the max would be sufficient for this case, give it a thought :)

johannes

--=-Jd28ZPZKEK/JnQbfQKCF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLE5ijAAoJEODzc/N7+Qma4ZgQAIqula/IrlTeZALF+FWqaG9J
Kt2hPkj4o8ltomq54Y6A0iK87wD+R524xAu2+gKB03V358A2RMg9rKAny0bI+xS1
AAZLWH6YRXLIJ87ROcCpTFjByOaTrJ0RRJOblowbHZ4jU+EoD4mLwRbjt3WuxTUX
J5DVTSlMkyQYJves+s5M1lt4OxcSydjbgWfzgEVZrdqR1iI4oGeIa3uhP7bSKXHg
dcDPp/fy8M2KOiT6/jXO2GOTUhDg+qnMlCMgVGXXm8KJ5aooY6zNgbAu43DZjeeU
rfjWNpi1WXYKTFSn7vz2UFkapcYAw134ycqRnnT5GBfGrziP7KHp7g3WyW7mj0gD
y5WaHKTw19Qd+4l9xyyQf+RvbhIOxv3s5kZOT1XrrovIlnX+OLpsgiKvPiA3fGBF
i24s/4zgsB9/WOxK02kGIdNW+W1NaBbKCZcsWEKy1E8PhSHsiaxSfOl1/KjUIH6A
8xOlPmzOYNNGfNfzdndWuq92DrSksCRpfD6dKFvAjMNono0j4YUtQAWzY8sx3Hyq
3xDvo+ReWjWgt7ld2aqysEkKidN7+EEfNZfU8nbjWPk2vuBTdxWOVfYAg3gt3kDt
HxiPSUQN9Y5I97B7suy3+/mjpKNQMsFrqQ+bHOPgR6QOpWNQLm1P9P9gXfYo6pBx
Kbj7rHShJPMvSIMWEyze
=V6J+
-----END PGP SIGNATURE-----

--=-Jd28ZPZKEK/JnQbfQKCF--

