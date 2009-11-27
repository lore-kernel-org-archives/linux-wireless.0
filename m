Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44040 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754198AbZK0Jni (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Nov 2009 04:43:38 -0500
Subject: Re: [question] ath9k: 11n monitor mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Ming Lei <tom.leiming@gmail.com>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	=?ISO-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>,
	ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org,
	Matteo Croce <matteo@openwrt.org>
In-Reply-To: <d82e647a0911261737j2bb9d07fj453e7d43a8f2e2dd@mail.gmail.com>
References: <d82e647a0911260557l5cf33449pe41f8902b6889891@mail.gmail.com>
	 <69e28c910911260902p5385cd33wa0d5e00199235dd1@mail.gmail.com>
	 <43e72e890911261348g32edb851obbba8e265ad22e95@mail.gmail.com>
	 <d82e647a0911261737j2bb9d07fj453e7d43a8f2e2dd@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-hzweFrJ5GCc3yKws2g+3"
Date: Fri, 27 Nov 2009 10:43:20 +0100
Message-ID: <1259315000.5428.14.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-hzweFrJ5GCc3yKws2g+3
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-11-27 at 09:37 +0800, Ming Lei wrote:
> 2009/11/27 Luis R. Rodriguez <lrodriguez@atheros.com>:
> > 2009/11/26 G=C3=A1bor Stefanik <netrolller.3d@gmail.com>:
> >> I don't know exactly, but a while ago there was a discussion about how
> >> to represent HT rates in Radiotap. AFAIK mac80211 refuses to forward
> >> HT packets to monitor interfaces as they don't have a valid CCK or
> >> OFDM rate.
> >
> > Matteo added a suggested field for radiotap for MCS rates:
> >
> > http://www.radiotap.org/suggested-fields/MCS
>=20
> Oh, I see.
>=20
> Is there any patch which may let mac80211 forward HT packets to
> monitor interface now?
> If there is, where could I find it?

It will forward all frame that it gets from the driver, just not tell
you it was an HT frame in radiotap since there's no way to -- you'll see
a frame without rate information.

johannes

--=-hzweFrJ5GCc3yKws2g+3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLD580AAoJEODzc/N7+QmaTzgQAJiEk0fPxJc3U2t7ajRjxF3q
rhbdHwqQS4yFI26vWPM6gOvbLhzu16jQSMyPoJnfrWq5bWHlX/UVtIJkz59VtGug
kjnjOv+VsT7+CvORZ2Uj700ya0XOiTq2+6tq+KkuZB2Doy+jYTwliZiU3OGUKJX+
M88gb1ri/d6I1kT5yxP2OkyjVR1AyJx/PbJJMipzP1GKHJ/WcVrgpM05xv4c7OqS
s28qWq1159199CqkmKXnu5SnqLjjgGWLRo8uSobXLhBG0blVJMtcLBUVcnsKl/1p
RzHT0F+Tv56o+jhCw1CYVyw76jipmdyj84HDagQn096h9wIePORa/WWi3eswp2rv
P4exLOlDkrFGButVI9AZDM/6LEghOpwJgyqVvzoZnHG+iBdMC/F9M81PMjXXLo5T
mw3z1IbZEZa9YViQ+hswUhaHn5tf7BGDsL+mjcU+lS/GG6T62qRpVqDUREvTpH6L
QcwtDJy4TOITg4qXGk8Nsyn2UyiERR8Y+3R1FUzpc4+sv2sEGejpdjIk7FtEWV6q
xCH6bb+wG3lsQSmh+dO30EREMASODzalW01e5ppJNA4ny4tiFuyon2al5iuR+oLZ
RU9CmC8cCxhovIcnETst3jP6uGeuh36TzNw9krkV2KWBCHsb4ANXJDDz3+e0lXVm
XdHtnsTcMcGVMBNk+40d
=VV9V
-----END PGP SIGNATURE-----

--=-hzweFrJ5GCc3yKws2g+3--

