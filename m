Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:56080 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759925AbXINVMa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Sep 2007 17:12:30 -0400
Subject: Re: [PATCH 00/05] orinoco: Agere/Lucent firmware download
From: Johannes Berg <johannes@sipsolutions.net>
To: Dave <kilroyd@googlemail.com>
Cc: Pavel Roskin <proski@gnu.org>, linux-wireless@vger.kernel.org
In-Reply-To: <46EAF698.8030604@gmail.com>
References: <46E8557F.2080401@gmail.com> <1189746312.26312.39.camel@dv>
	 <46EACAA5.2050706@gmail.com>  <46EAD760.9020102@gmail.com>
	 <1189796807.3974.53.camel@johannes.berg>  <46EAF698.8030604@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Qtu5ngvtbzIi6bKM4cA2"
Date: Fri, 14 Sep 2007 23:13:48 +0200
Message-Id: <1189804428.3974.55.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Qtu5ngvtbzIi6bKM4cA2
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-09-14 at 22:01 +0100, Dave wrote:
> Johannes Berg wrote:
> > On Fri, 2007-09-14 at 19:48 +0100, Dave wrote:
> >> Either that was painless, or I did it wrong. Using sparse 3.0 the only
> >> warnings were in orinoco.c, related to the use of ARRAY_SIZE. Errors
> >> are false positives.
> >=20
> > They're errors tho so sparse aborts and stops parsing the file at that
> > point. A new git sparse can actually parse ARRAY_SIZE though, I can onl=
y
> > recommend getting that.
>=20
> Repeated with latest sparse from git. No warnings.

:)

johannes

--=-Qtu5ngvtbzIi6bKM4cA2
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG6vmM/ETPhpq3jKURAq/cAKChHbcU/oX+VcwhXXul05rt+FL89gCeJiVT
MXpS1qIuP2cSE5n6ZKfhTj0=
=ymTc
-----END PGP SIGNATURE-----

--=-Qtu5ngvtbzIi6bKM4cA2--

