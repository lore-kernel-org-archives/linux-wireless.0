Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:57960 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752909AbXKPOjx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Nov 2007 09:39:53 -0500
Subject: Re: Suspend/Resume support
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <Kalle.Valo@nokia.com>
Cc: Li YanBo <dreamfly281@gmail.com>, Ben Gamari <ben@mw0.ath.cx>,
	linux-wireless@vger.kernel.org,
	Jose Ignacio Naranjo Hernandez
	<joseignacio.naranjo@gmail.com>,
	Michael Wu <flamingice@sourmilk.net>, Jouni Malinen <j@w1.fi>,
	Stefano Brivio <stefano.brivio@polimi.it>
In-Reply-To: <87ir42z5kq.fsf@nokia.com>
References: <1195087905.3814.11.camel@mercury>
	 <1197ff4c0711141937gc7bb1f8w499cd9d8634fa232@mail.gmail.com>
	 <1195171869.8147.79.camel@johannes.berg>  <87ir42z5kq.fsf@nokia.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ubtYh+m5WIZhBu/uUgAW"
Date: Fri, 16 Nov 2007 15:41:07 +0100
Message-Id: <1195224067.8147.122.camel@johannes.berg> (sfid-20071116_144002_576293_95DB90B8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ubtYh+m5WIZhBu/uUgAW
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-11-16 at 15:24 +0200, Kalle Valo wrote:
> I think that at least most (if not all) of the APs do send a deauth
> frame in that case. I have seen this happening when debugging some
> bugs. But I don't know if the standard specifies that.

mac80211 has a comment that NULL frames are just for PS control
operation and otherwise ignored. So no idea.

johannes

--=-ubtYh+m5WIZhBu/uUgAW
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARz2sAqVg1VMiehFYAQKvwBAAvigxa4ZWJNv+UZpgqmm/gvmUdAVDbJv6
pMdwh+PcBnQNAUHjQu7kLWoHVJ0r7wX0ZJoA+uOVy1fi6+DiJM7jwxUqXTVDetey
2w02Wqi3cCAbsL8KuyL95TeZCLIXhRiY3NUVYvQpY/Z6oV6Kv3sfvftjlv9KayeF
I65ju8tEW3+8mC0GPeMpSyD+Mg+2gRZoluYckr+HJvxUH9Jm/ZUneH1It0HO12BU
TsHLrrFjnMa0f8ie4pMx2zbn2GUkmu1PuWoc9E+uHUIquQ8IRXa08643fSGzL5mh
spTGOb3Wk5WeCeJN4r2rAkF9A6xpNuRhahe5mFpSaF2f05ucum2B0Gq7Em1nY+iq
BK6tKrWjBd7Ejvi8q15EaRBk5vWC6ydMSM+z8qwckRE0iHANQOvySrSLVgpBWt5V
EW/Q2vLaqlL2igjqH3270BzALThDI4KjMb8f8TEvJvHhrazs/ZLCRrTx5gbJus+1
sUJpp3CHfVtDHZqPa+r7P27TNyGbMN4mq1mzDQVDAz9og7QFLElwhIiIX3bI8Wnp
0hx+H5deAHxaceJ1rOdv+2MT4KNp6pY5bRVeAYh80JtTzTf7T6OFd4LuIPdYMTqh
LnBFFC6GOt9VCaploen+XNUgumBoIiAKUUmwcxfJ9gId6y0EOK3un2HiQe5fDHgZ
2ElPBO9KNu8=
=dmp0
-----END PGP SIGNATURE-----

--=-ubtYh+m5WIZhBu/uUgAW--

