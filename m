Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56848 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751844AbYKOACh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Nov 2008 19:02:37 -0500
Subject: Re: [PATCH 3/4] p54: protect against sudden firmware file changes
From: Johannes Berg <johannes@sipsolutions.net>
To: Christian Lamparter <chunkeey@web.de>
Cc: linux-wireless@vger.kernel.org,
	John W Linville <linville@tuxdriver.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Pavel Roskin <proski@gnu.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
In-Reply-To: <200811150054.30113.chunkeey@web.de>
References: <200811141941.56752.chunkeey@web.de>
	 <1226700028.4120.28.camel@johannes.berg>
	 <200811150054.30113.chunkeey@web.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Brm1RO7UWgTcRsXpNTjh"
Date: Sat, 15 Nov 2008 01:02:30 +0100
Message-Id: <1226707350.4120.34.camel@johannes.berg> (sfid-20081115_010241_205438_1ABD0D93)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Brm1RO7UWgTcRsXpNTjh
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2008-11-15 at 00:54 +0100, Christian Lamparter wrote:
> On Friday 14 November 2008 23:00:28 Johannes Berg wrote:
> > On Fri, 2008-11-14 at 19:41 +0100, Christian Lamparter wrote:
> > > Thanks to "p54: introduce new names for device firmwares"
> > > (325ca16910a380c...) people are now migrating away from the buggy fir=
mwares.=20
> > > Of course this is a very good idea, but no one told them to unload th=
e driver first.
> >=20
> > that seems weird. Doesn't the driver pretty much have to cache the
> > firmware anyway for suspend/resume?
>=20
> well, that's odd. No one complained about this bug yet?!
> Even better, this bug/quirk is even present in the initial p54pci version=
 that made it
> into the kernel. In fact it looks like its even present in the fullmac dr=
iver! Luis?
>=20
> I guess, I have to leave it that way to provide "bug-to-bug" compatibilit=
y! ;-)

Maybe it doesn't upload the firmware at resume? But that'd be odd.

johannes

--=-Brm1RO7UWgTcRsXpNTjh
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJHhGTAAoJEKVg1VMiehFYt2wP/3ljSWvBEqYhjtc5cWbCrjx4
/rXrSbzbj48+SALk1+y3CU55/izvShEt/ZyytvjkVdzWpft+KlxKxlGYTcSH9BoD
mIs0Ebo7vNHWJZLXsh6SqUykzUsm4Iw/IZgYjyMP+FWKuhkhpFGOcTQDbPI1mVh9
bm4Om34pRXJhnKIuN2iJdYNXz/InJFPihufy5RtDxbOuMSx1kqrp9QDAq0Bu/zzo
dSemljo2whCNIeCwArw0iPSpstYOwTENK4y4Xdj9Sr63Gs1pJdWzVu84PnZU+X2v
3mKlkLR2ap9ynTau0kVvkn9CzeM8TpDTUcqPHIcrrRon2N99uVEmzlDxlZrT71I9
AuPIn+PpP2myYXJDZ6C/dTBJOH1pkpa3l7nkSlF3r7EDO8OHPGk7E18+oURlYkP9
4QhHA2mk71UrEKSjvnvGRToGnN51lNHV0Fz/Q/GSSQZBdJRb6Zju5eF9ESrRFwIr
oxEtfkBxlSZagYiJY8iwFxn0JxJaEhaIqhE1KhEQFoMO5NyJ3IQsGB37yTproxh8
4/vh8LOlDW9suOie/c8VFotiIsxK7jzzoxVdCLzljFtmbwGaaaRzUXylkAvs8YJ7
YS9BsC2IeLfTqJgV9BrMKZRkRaca8TEyGTTB1kM8Yruqjn178SqXefFoRV7ds6qd
e5jLT/AwGHyCWDZ03X5o
=/m3+
-----END PGP SIGNATURE-----

--=-Brm1RO7UWgTcRsXpNTjh--

