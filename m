Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:48291 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757233AbYLLPur (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Dec 2008 10:50:47 -0500
Subject: Re: [PATCH 3/3] mac80211: Add HT rates into radiotap
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: Stefanik =?ISO-8859-1?Q?G=E1bor?= <netrolller.3d@gmail.com>,
	Jouni Malinen <jouni.malinen@atheros.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Thomas d'Otreppe <tdotreppe@aircrack-ng.org>
In-Reply-To: <20081212151619.GA16981@jm.kir.nu>
References: <20081212123832.506588839@atheros.com>
	 <20081212123918.723191687@atheros.com>
	 <69e28c910812120647l69b317daxfdbeb914d61ba7e3@mail.gmail.com>
	 <1229093327.3600.12.camel@johannes.berg> <20081212151619.GA16981@jm.kir.nu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-/L1pwJzQbO8aq32t/GO5"
Date: Fri, 12 Dec 2008 16:50:40 +0100
Message-Id: <1229097040.3600.21.camel@johannes.berg> (sfid-20081212_165050_331374_66DCE1F5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-/L1pwJzQbO8aq32t/GO5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-12-12 at 17:16 +0200, Jouni Malinen wrote:
> On Fri, Dec 12, 2008 at 03:48:47PM +0100, Johannes Berg wrote:
> > On Fri, 2008-12-12 at 15:47 +0100, Stefanik G=C3=A1bor wrote:
> >=20
> > > Thanks for the heads up, mail forwarded to Thomas d'Otreppe, as this
> > > will need changes in airodump-ng.
> >=20
> > Guys! This format is brain-dead, it means we don't know 40MHz or SGI,
> > let's define something proper in radiotap instead!
>=20
> While I'm not against defining something more officially for radiotap,
> I do not agree with the part about this format being that brain-dead.
> Both 40 MHz and short GI are indicated (IEEE80211_CHAN_TURBO and
> IEEE80211_RADIOTAP_F_SHORTGI) and shown in the current wireshark
> release.

Oh, right, I noticed. Well, as I just said, it's still pretty bogus
because we reuse turbo and confuse older dissectors with the 0x80 for HT
bit.

johannes

--=-/L1pwJzQbO8aq32t/GO5
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJQohNAAoJEKVg1VMiehFY8/8QAJZ/topIGv6zN0AzO8Q5diYJ
yeIUYra/LWsuUlvjpSM+I5fK1qWl1dzSFjwawCkD2OTUApV202ZuqPZEawx5+Cdz
bAqkk/5rjRpplLH0mY5IVPNtJmSHMUzzTLaYka88fxfnr7Kx8CtsaLo5MeSmVrTm
0o9V3WASzpR3Zl1DkDauIWLQquVDW7k984vG1hImFhcvkh1WaVlwnPIDBx9zKjCh
4pxZEDR43Smw0KXXz7ZtY7nZ8k+AHSeViJ7GvqStIIzmPTiq2cdnfn9NOQnfr8uo
kANNd94PUfxn8yWoE7HNFva4R0fjl6fpuMl5sK1MCS/Oi0gkSHggKgkXtKHOZlkY
rnbSGa3Fa5C07zHZnLVrLy0vBXqgxbl9odml7+p3Jrr3Lc3ir8BZZticTn+41DSn
8/PCnhGl82/otrFxvxnwU8SJbf6lKT8gcgqU9T9jUHlTSDOSAUL9IMzd3KtfSAij
x8rWkQaq+rPi/J5ckeYS40zNOaZmftqyoWk6y8OFj9+HCAzN5qyrh2bRiZqCuyQU
uTEuFkZHePA043lWM06M/ixT1zt39fEIiG8EWtY+h3l/wqzFh8fw1fb2Yv2Poq3k
J6/4ftsBKKKPIYduwVS5mXpgpM+QoiJxePhQ9xWrvZWu+k+DkZ+26jLZ15EF3sZW
Iw0mthQK7u3m9K3x4jrX
=7IhB
-----END PGP SIGNATURE-----

--=-/L1pwJzQbO8aq32t/GO5--

