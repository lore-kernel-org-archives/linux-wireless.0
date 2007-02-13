Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:43825 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751774AbXBMTW5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Feb 2007 14:22:57 -0500
Subject: Re: [PATCH] prism54: correct assignment of DOT1XENABLE in WE-19   codepaths
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Williams <dcbw@redhat.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <1171394306.5329.24.camel@localhost.localdomain>
References: <1171393222.5329.11.camel@localhost.localdomain>
	 <1171393331.10344.106.camel@johannes.berg>
	 <1171394306.5329.24.camel@localhost.localdomain>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-7a1VHPyZ75OeGQj1TN7t"
Date: Tue, 13 Feb 2007 20:20:27 +0100
Message-Id: <1171394427.10344.112.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-7a1VHPyZ75OeGQj1TN7t
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2007-02-13 at 14:18 -0500, Dan Williams wrote:
> On Tue, 2007-02-13 at 20:02 +0100, Johannes Berg wrote:
> > On Tue, 2007-02-13 at 14:00 -0500, Dan Williams wrote:
> > > Correct assignment of DOT1XENABLE in WE-19 codepaths.
> > > RX_UNENCRYPTED_EAPOL =3D 1 really means setting DOT1XENABLE _off_, an=
d
> > > vice versa.  The original WE-19 patch erroneously reversed that.  Thi=
s
> > > patch fixes association with unencrypted and WEP networks when using
> > > wpa_supplicant.
> > >=20
> > > It also adds two missing break statements that, left out, could resul=
t
> > > in incorrect card configuration.
> > >=20
> > > Please commit to both development and stable branches.
>=20
>                                           ^^^^^
>=20
> Right; applicable to anything after _and_ including 2.6.19, which is
> when I think the WE-19 patch landed.

But I think John will take it to mean to apply it to wireless-dev and
wireless-2.6 so you should send it to stable@kernel.org

johannes

--=-7a1VHPyZ75OeGQj1TN7t
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBF0g97/ETPhpq3jKURAghhAJ9YPuLevxV+pnkfQ68QUdN1O59f/ACfV32N
OunymXdj/j8wyGfnEA6eIAA=
=XXeG
-----END PGP SIGNATURE-----

--=-7a1VHPyZ75OeGQj1TN7t--

