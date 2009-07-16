Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:55812 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933308AbZGPVRi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jul 2009 17:17:38 -0400
Subject: Re: [RFC/RFT 5/5] mac80211: implement basic background scanning
From: Johannes Berg <johannes@sipsolutions.net>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <200907162252.09504.helmut.schaa@gmail.com>
References: <200907161104.41975.helmut.schaa@gmail.com>
	 <200907161150.54237.helmut.schaa@gmail.com>
	 <1247739394.29762.9.camel@johannes.local>
	 <200907162252.09504.helmut.schaa@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-wy1IjDcgsSTVIjoXLzTX"
Date: Thu, 16 Jul 2009 23:17:07 +0200
Message-Id: <1247779027.30529.45.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-wy1IjDcgsSTVIjoXLzTX
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-07-16 at 22:52 +0200, Helmut Schaa wrote:
> Am Donnerstag, 16. Juli 2009 schrieb Johannes Berg:
> > On Thu, 2009-07-16 at 11:50 +0200, Helmut Schaa wrote:
> > > I didn't do much performance testing, just a single wget and the perf=
ormance
> > > dropped to about 50%. I still have to run some iperf tests (both RX a=
nd TX) to
> > > see how it behaves.
> >=20
> > I'd be more interested in the rtt stats that ping -f prints after you
> > abort it:
> >=20
> > rtt min/avg/max/mdev =3D 0.021/0.028/1.726/0.051 ms
>=20
> JFI, here's the result:
>=20
> 30851 packets transmitted, 30796 received, 0% packet loss, time 80592ms
> rtt min/avg/max/mdev =3D 1.512/8.235/251.145/32.479 ms, pipe 12, ipg/ewma=
 2.612/1.709 ms

Nice. Much better than the multiple seconds I had :)

johannes

--=-wy1IjDcgsSTVIjoXLzTX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKX5jOAAoJEODzc/N7+QmaA0cP/iqgBWw+PoyuubcFavVI3+QS
YSKZoiof1v97E948nKVJsucq0jkWtoPzZdFuXfE+//VyCHWnH8AFqHZYR53l8uQM
oiwCQp/DIhn5PEjoSZYw2X6+AKlxFRM3wO0xNRolLiLdKFv9r7Z7JcY/mi8/vApd
ozv/mdWu+MAlGbN3immD82MNhygaAsL+Bs2IIwejXmHMkrc4n3yAa89icFTgx4E9
X2gEuSyapc/gKuO4CL0t9T0ufRhHfdDljDmK+FQAUYhjK6xvknmA/a6Cb49PbaOZ
YFwuW48kFWretUA98hXrsrgLnxGfGh19cPxovAxDrQEtq03tn2D8dghAYhXomjg+
CGfCyGF8pzmfAQ0ZeefwOJbHA2GPy/ddJz6uNpduLjnSYLPxs9/UKWvdY3wyyuYr
t3i2XuEHvqClF+p8v7soUSg5xAMBFThqgvqMOMigLMafO/sKybgGnZsRvSbNwW4d
sAiSP8NnQN+D8ZRqM6OjF4h9iyVU8Klg8wm3DZjSRzmZT60Fnxnmpfdf8NMolbRz
gyihFGzohsd+kXyEGOgcni/CFiua4C1lXhTWBVbJqYwwcveMFFuXnOQ2JvqEAa+3
PAQoxK88coDVcRUjCBZ+nfQfN5GQj6mRWkvLoJU5lmsN4Zmd22LO7KFztDl/qE3g
329GVFiNmuhF6fYfKiqy
=0Grg
-----END PGP SIGNATURE-----

--=-wy1IjDcgsSTVIjoXLzTX--

