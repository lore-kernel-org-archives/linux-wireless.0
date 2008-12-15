Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:38693 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752198AbYLOKOT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Dec 2008 05:14:19 -0500
Subject: Re: [PATCH v2 0/3] mac80211 suspend/resume
From: Johannes Berg <johannes@sipsolutions.net>
To: Bob Copeland <me@bobcopeland.com>
Cc: linux-wireless@vger.kernel.org, mabbaswireless@gmail.com
In-Reply-To: <1229313039-5544-1-git-send-email-me@bobcopeland.com>
References: <1229313039-5544-1-git-send-email-me@bobcopeland.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-qj4q6aZ2yYsMqLKNPAfC"
Date: Mon, 15 Dec 2008 11:14:17 +0100
Message-Id: <1229336057.4471.9.camel@johannes.berg> (sfid-20081215_111422_286755_7A784378)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-qj4q6aZ2yYsMqLKNPAfC
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Sorry, heh, was reading mail in the wrong order I guess.

>  - the call to ieee80211_sta_tear_down_BA_sessions was locking up so=20
>    I just dropped it for now in the interest of getting a stable base

Probably due to transmitting again? We'll have to look and add it, but I
agree that we can work on that later.

> I also tracked down the disappearing interface problem.. turns out this=20
> was just gnome-power-manager or HAL.  (I do not have 'network_sleep' set=20
> in gconf, but I didn't bother pinning it down otherwise...)  Using=20
> 'echo mem > /sys/power/state' to suspend keeps the interface up across
> suspend.

Oh ok, that explains things.

johannes

--=-qj4q6aZ2yYsMqLKNPAfC
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJRi30AAoJEKVg1VMiehFY2H4QAI5nMAgCgSQzdBXEpkcClg55
v6jHk08cqSEf9/N8AXBn8BERoDJ1F5rObH/wl1WNs98wC3qOmepShGmzEN7uszcu
Xx9oG4FW3m0GbipA3z+b5Q5M9S5Vd/ULrcIXPBJeiYZ8hzXPdp0quXvdCQhcFCo6
/5aSPlu0BX3rIIuVlhY5FJvXqBPjiGj/xDlXqMXznQtuKtBpFDc9XHpwd4wGuSCM
5Lk9UigUpW7tB0Ar3fciLZr4uAjExn05G+s90TsHn+8ShIuUv0Y5B+XnEiEH6+LR
OEazUy+VFA0cdqwCN65nRP9SEOq9pcFxA6M06LEh1ycOOkx3GnKN4t9k9FX8x6xb
7kexGO9LyGsopjFjw1uHgt4xY/uSPQryStyzG1uDmsjezcq5cjjxHDte0LrgCv06
cVO1cTKjIGsK40QTyGUoDoCkZTHEZuIqa15ER7bLduRLHN48OFlCD1C3p5FPG344
KUqgVI18j8RxU1yY1+TRi4OOiMO5kaniRxheuT4QRBUgt77VGo2ksZ3UXW/cFiBA
3fhKjIe1Csn2xmdtGglHWOlxxeaSeY97EahFk47wMWwLbc5Yeacgb5DayYEKXK62
hsUTaWprqi7bi5tvxbQHlmi+CFdUVF03Mlg38c6Im7V53GJBRP1KQFA3yOCbr8QJ
ruMa/3N52WGEDXilfPjV
=W8bH
-----END PGP SIGNATURE-----

--=-qj4q6aZ2yYsMqLKNPAfC--

