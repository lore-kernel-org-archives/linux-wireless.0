Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53055 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752431AbZDSQyE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Apr 2009 12:54:04 -0400
Subject: Re: [RFC/RFT] cfg80211/nl80211: add IBSS API
From: Johannes Berg <johannes@sipsolutions.net>
To: Alina Friedrichsen <x-alina@gmx.net>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20090419163204.158820@gmx.net> (sfid-20090419_183237_340935_6640098A)
References: <1240094996.21583.1.camel@johannes.local>
	 (sfid-20090419_005015_625875_1781AFCD) <1240147370.898.0.camel@johannes.local>
	 <20090419143337.158810@gmx.net>  <20090419163204.158820@gmx.net>
	 (sfid-20090419_183237_340935_6640098A)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-mYojkowM4QNwljT0Pl6y"
Date: Sun, 19 Apr 2009 18:54:01 +0200
Message-Id: <1240160041.28138.0.camel@johannes.local> (sfid-20090419_185409_872580_468BC191)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-mYojkowM4QNwljT0Pl6y
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2009-04-19 at 18:32 +0200, Alina Friedrichsen wrote:
> > In cfg80211 an indication for channel auto select is needed for IBSS an=
d
> > _STA_ mode, to implement with it the old wext interface. If not set the
> > channel shouldn't be changed. If you not want store this flag in cfg802=
11, you
> > must store it in the channel functions of wext to have the same behavio=
r
> > like now.
>=20
> I looked in the Source:
>=20
> > @chan: The channel to use or %NULL if not specified
> > (auto-select based on scan results)
>=20
> I think this is enough for this purpose.

I don't think so -- how would I express "use channel 5 if you can't find
anything" in a single nl80211 command?

johannes

--=-mYojkowM4QNwljT0Pl6y
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ61cmAAoJEKVg1VMiehFYt9MQAK7ThzNPwdcRGEaJ1UQLjK++
VyE1sFQd/A+Il6gQRfrE6I22DqUQ0vJQi5hGfE18LkXiX3p+TRZu6i0qLQE0KAMA
h4wxr+D1YTEaj/YyrZvYOGwGzUiibGQTu0hawnUjXeXWG+Ownkor8xdPmM3Bgpau
os/kzISzfNCNy7WE2FE02AqLBMvr5OYnqHDLUP9E/MGH8fpIA5vnkGS/bcJMeyXs
LDi0kplkrlO21bLPDjOyjlFSdCBCO2kqi6jmKaLy4FGFXBSUkhtdmt2Sk3io2Lwd
xxu5IESmbxfN/Yu83zo9j8Ixs7BkmYwAQkuMYu/JS5di2hCrzQddFQjwlTvibOHU
T6IjA2K+qo7x06IvEvbWb03ki3+/H6/UK/eYxrwR0TbFurOC6B60hJowuxIVAGi1
6PMTA0AK7RKQ8q+9FipkfJv1eXH2BYka0HJeMbENmLKQVpSshPzrx+SqcZOusJ+v
OuxvP0PFIgSM6aP+7Jrxegptzk1du5qTGro5kNPQLJ9JJaA+aYvscHYbkCBCmqgP
EmSPqbNvcQ2cfpWvG5dv6zsbVx4ny+36V0w8uJqbAMQR04epC7dOnBwtv1ncT7eS
QZzwHWHS2Sgl5O/MJ4hwMP8y5AX8YOVdipScBNsWC1f23XTonKVhU9xV/9FPaWwb
ztr2smdsOe6lfysl1Vvi
=Arqn
-----END PGP SIGNATURE-----

--=-mYojkowM4QNwljT0Pl6y--

