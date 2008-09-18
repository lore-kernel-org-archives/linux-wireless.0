Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:51606 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754593AbYIRTVw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Sep 2008 15:21:52 -0400
Subject: Re: temorarily out of range -> no TCP?
From: Johannes Berg <johannes@sipsolutions.net>
To: Anders Eriksson <aeriksson@fastmail.fm>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20080918191633.C8BAB93CCA7@tippex.mynet.homeunix.org>
References: <20080918141955.0119E93CCA7@tippex.mynet.homeunix.org>
	 (sfid-20080918_162007_153222_33378A12) <1221762748.20772.7.camel@johannes.berg>
	 <20080918191633.C8BAB93CCA7@tippex.mynet.homeunix.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-B+QvlQUtUyh03VGa80F0"
Date: Thu, 18 Sep 2008 21:21:16 +0200
Message-Id: <1221765676.20772.31.camel@johannes.berg> (sfid-20080918_212154_496325_210F4B8A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-B+QvlQUtUyh03VGa80F0
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-09-18 at 21:16 +0200, Anders Eriksson wrote:
> johannes@sipsolutions.net said:
> > Oh and that works just fine for me, I do it all the time. ssh can take =
a long
> > time to recover though, for some reason, so I tend to kill it (I do
> > everything in screen anyway).=20
>=20
> Hmmm, alright, I'll try to sit one out and see what happens.=20
>=20
> How do I best trigger an out of range condition? Power cycle the AP?

Not really. That would kill the AP's NAT table too which is probably a
bad idea. Though it might work. Take off the antenna ;)

> PS I assume the IP stack signals the tcp queue that there is an operation=
al=20
> and suitable link out of the machine when the driver is happy again, righ=
t?

I'd guess so.

> Howcome I needs to rmmod/modprobe it?

No idea. I just tried rmmod/modprobe with an open ssh connection without
problems. Even wpa_supplicant picked up the new wlan0 device
automatically.

Oh if you get iw you can remove the AP STA... That would do it :)

johannes

--=-B+QvlQUtUyh03VGa80F0
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI0qopAAoJEKVg1VMiehFYPNIQAI9v/4Ab3qUQrKoeluvunudC
VO1opXYHRo+QHPicWff+yVq8wMvmmntuJDBqeNndtEE5ugOpSnZ3wQYoqpvm6RgG
q4x+vt8L3Psnwmr0oyRKm6ppt6xhEy/6aP808v8oAnHn7IEg4khDixsOp3hbUN4H
yMOKaJRko1SP05olhCJoTMFQr2DoKytiRibRrPIWyVl92gxcZvl5VA37clotYTPg
+8QAOGGdy7ijUh7O9BixfysGwQOVu62A26qssd29qGuT2g62R4UtSI8zRQphwoE6
lhxPQTkAJKd7+Q/u6uXYHeM/s8FonMOxA6q2hBrJ8OT4UJ8ZvwNjM3A9hEhSnisw
wSJaXF3CjadwSrF53arP66suqol/V00DEd7Mxv5s0bDBXycDEiYy34wqAnUX1R6l
WwrBIqY0/z1ui/UJ6MlbW5OGDWx8xqSmXTHVShufrc7eeSUqKa7WZHcBkOY9iNey
FmADwiITKiqoNC3szfgOt1UQAA5phsplxgZem2LMtH0b5pXbjWWyHJdwE5TDgENk
I7CpIiXRnJVt+EDugP1B00TETqSD1rrPtA3l6dWMRcxtzINdB8ccsz9/nwbYjaTE
quq8ivs0sK7ZhAjzZ6hlAJXtXZ9eaIgSOhry9jp74o9gplxrEPEXcyVzhHYAK6Hu
756Oj+cr7shGMusbAix8
=3IiZ
-----END PGP SIGNATURE-----

--=-B+QvlQUtUyh03VGa80F0--

