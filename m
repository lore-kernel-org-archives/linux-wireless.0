Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:43928 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754816AbXKWMPu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Nov 2007 07:15:50 -0500
Subject: Re: timeout problems with certain APs and b43
From: Johannes Berg <johannes@sipsolutions.net>
To: "John H." <mistamaila@gmail.com>
Cc: Michael Buesch <mb@bu3sch.de>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de,
	Larry Finger <Larry.Finger@lwfinger.net>
In-Reply-To: <5b9417770711211135p65eab873leef65cd0e71452aa@mail.gmail.com> (sfid-20071121_193550_720363_FAED080D)
References: <5b9417770711211135p65eab873leef65cd0e71452aa@mail.gmail.com>
	 (sfid-20071121_193550_720363_FAED080D)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-j6HI7Aq+SRL/BtgjgzFN"
Date: Fri, 23 Nov 2007 11:05:10 +0100
Message-Id: <1195812310.4149.73.camel@johannes.berg> (sfid-20071123_121553_033956_9FBFD355)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-j6HI7Aq+SRL/BtgjgzFN
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> on certain APs, the internet works for a long time then stops, and I
> get authentication time outs, why?  It usually works again if I reset
> the AP itself, which i should not have to do and don't have to if in
> XP....

> wlan0: Initial auth_alg=3D0
> wlan0: authenticate with AP 00:0f:66:53:3e:24
> wlan0: authenticate with AP 00:0f:66:53:3e:24
> wlan0: authenticate with AP 00:0f:66:53:3e:24
> wlan0: authentication with AP 00:0f:66:53:3e:24 timed out

Does it help to reload the b43 module? I think I have seen this problem
before but always associated it with suspend/resume rather than a long
time elapsing, I also thought it was due to bad power recalibration.

johannes

--=-j6HI7Aq+SRL/BtgjgzFN
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR0al1aVg1VMiehFYAQLXsQ//c6ORyDla2+wVzM2sV0UB6rqsqCFq0TEI
6lqpEQW+qNXIT31NcNQgKjdKOWl7AacpoKAYpi6ZBkkOqAfZh+66uiIJoz9AfSGu
CVOMMMu855XS5ZHR0n7UAFWIwWF5XR1JlUmSIFqBb0RhUUvWXPfTJTJsqOC2BI9b
3K71n+CMUWeo+R7tnEzfEWpvHoxu7jXJiq7sGf9EpviCh0H/Xzs1qcOZcnhY+24J
FtM/Chq0sDMy88G0HKWQnWYGKenwBTaLERD5arHZ/BwnwzlLrsPppcH+8wjjXIOv
lpZ9sJBcorZBI/RbfXfXTxOu4AXGuhcSHHFb/lFhKkct1wTTfw6zuv8XsM1D6Pcw
1SycXfUvMu7raMDANsh2uHx07USdMwrgij0k7sBFHJWTpB8xTXbt0qSVW1kXcjw+
ok3+bvjFMsKxJXWS8d9NYE4eULbNZS0Asi9mZLfq0zyfVHuDObXoRnrxyAyJvgUY
38LcdqOOifNYjVkw7cl/q72dsAT3L5EUxGycpHwcLsaApqMEAkNcwNOHmk/rlbV3
Nvalu7SB5aiTAlOoaz9Nf6c2DMODVJMF1mPaehVVhJsRxIwaiNSNb91rfKeLQ6Ob
p0vWp/g+UTZJNRF0GdZHi7KtV31e7Kmey9494Y0r2ipGrIgyDO4iOAriQ5kmgfEk
td4PbOoHupg=
=Mh2o
-----END PGP SIGNATURE-----

--=-j6HI7Aq+SRL/BtgjgzFN--

