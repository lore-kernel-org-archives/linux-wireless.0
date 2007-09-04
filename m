Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:44430 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754250AbXIDOyC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Sep 2007 10:54:02 -0400
Subject: Re: [PATCH] hostapd: use nl80211 instead of prism ioctls to create  interfaces
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Thomas Graf <tgraf@suug.ch>
In-Reply-To: <1188913335.9942.16.camel@johannes.berg>
References: <1187987850.24933.29.camel@johannes.berg>
	 <20070904011648.GX1835@jm.kir.nu>  <1188913335.9942.16.camel@johannes.berg>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-sp8y1V7oqcfYIsCxmLn4"
Date: Tue, 04 Sep 2007 16:55:16 +0200
Message-Id: <1188917716.9942.37.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-sp8y1V7oqcfYIsCxmLn4
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2007-09-04 at 15:42 +0200, Johannes Berg wrote:

> > This is making it a bit difficult to build driver_devicescape.c and sam=
e
> > goes for the requirement for svn trunk version of libnl.. Any idea how
> > much code from libnl is needed here? Would it be major effort to do the
> > needed calls without having to rely on libnl at or (or at least not on
> > an unreleased svn trunk version)?
>=20
> There's a whole bunch of code in libnl I use, all the generic netlink
> family resolving etc. Maybe Thomas can prerelease a libnl with generic
> netlink support?

Also, since this affects git trees only... To use this you actually have
to have hostap git, wireless-dev git so what's the big deal with
requiring libnl svn? :)

johannes

--=-sp8y1V7oqcfYIsCxmLn4
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG3XHU/ETPhpq3jKURAl5IAKCGjA2o3DH05VJ+vFFx4bgouvflbwCfSESF
wHZlIp7V3/Dtz0YJ69n16yc=
=HuNS
-----END PGP SIGNATURE-----

--=-sp8y1V7oqcfYIsCxmLn4--

