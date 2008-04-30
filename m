Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:52922 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753748AbYD3OJK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Apr 2008 10:09:10 -0400
Subject: Re: rt61pci current wireless testing git gives kernel oops
From: Johannes Berg <johannes@sipsolutions.net>
To: Bas Hulsken <bhulsken@hotmail.com>
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
	rt2400-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
In-Reply-To: <1209548733.5814.3.camel@Bas>
References: <1209147056.2955.7.camel@Bas>
	 <200804252031.56605.IvDoorn@gmail.com>
	 (sfid-20080425_203116_969250_F59BCB3A)  <1209406716.29025.18.camel@johannes.berg>
	 <1209548733.5814.3.camel@Bas>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-DF9PWS1cG06+r2bBLVTy"
Date: Wed, 30 Apr 2008 16:08:08 +0200
Message-Id: <1209564488.18659.7.camel@johannes.berg> (sfid-20080430_160902_422823_F721F6DF)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-DF9PWS1cG06+r2bBLVTy
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-04-30 at 11:45 +0200, Bas Hulsken wrote:
> Hi,
>=20
> On Mon, 2008-04-28 at 20:18 +0200, Johannes Berg wrote:
> > > > the interface goes up well, but I get an oops as soon as I run host=
apd,
> > > > seems something with debugfs. This shows up in dmesg, let me know i=
f you
> > > > need any more info.
> >=20
> > Bas, can you reproduce this issue? Could you try the patch below?
> >=20
> > johannes
>=20
> with your patch applied I can no longer reproduce this issue, and I've
> tried running hostapd at least 5 times. Without your patch, I could
> reproduce it two out of two times.

Thanks for testing. That patch causes another problem but now I know
where to look.

johannes

--=-DF9PWS1cG06+r2bBLVTy
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASBh9R6Vg1VMiehFYAQLaCRAAtiItQxlv2e2aNtaLkoNPfooUeIRuIYZW
fn1oomzSgy+EQf5V1NuAbdID37X+yFQia5R7gJee9qqFTk2FxzSwKcE5SFl6u1GM
dTxvnG6/KG7s6K7GKSx+Gc61Z7xyI1VjteYe8OOQKKTCrhXcyQLXEGW8TmF/a+3Y
gpZ0FR+UbCKOmCahFkcCyJiNuMOSeufrSoO23px0/MsOQkl7CCtuKfHFeM5Nibi2
NoETCOGuuLJhZYGqQ2ol2Ur6rylOmzWrSMPFjkc+tS1OuhLZ4pBoKkwiuJ7MpPDx
Ef4uPY7Zfg5ZH9Kj5wr1yeP3dj2cTrN7oGWe1mdp7zTKrJXyZ/NA5EtvlxguVBJD
8zbiOQPg/Sz4RLx3peo+Uf9IDHoLIWZxPt9JRDFrJC/vcK2QBospfvSwe2QhYwO+
A/U1UyGhd7L3rt3HxLpGoXqpP93Rb01XIrmiEe44D7LzKeMrGsa5yQUjYciymWuf
NK5Pmhz9BlvV02mzT6XOxUOvv7EKbHwtK3BHokHzWezDG7/EbMp/Mj8Bvy5wSUjX
niD4uv6GPb42DkfYZ0dadvDa+gkIFRq8/lXMcgj9TUu95yU4slEJry6GlIHN+1e5
f8Sz32zLQethfA5Uuml+s7/EjZYE2C8350ooZilmkWIpt3WgQ8s3Xw1Bt1P5V8AH
7KKjpHut0uo=
=2LfX
-----END PGP SIGNATURE-----

--=-DF9PWS1cG06+r2bBLVTy--

