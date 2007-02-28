Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:60423 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932291AbXB1Sxu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Feb 2007 13:53:50 -0500
Subject: Re: [PATCH] rt2x00: split RT2X00 option
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200702281945.28426.IvDoorn@gmail.com>
References: <200702281926.38820.IvDoorn@gmail.com>
	 <1172687756.5015.65.camel@johannes.berg>
	 <200702281945.28426.IvDoorn@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-W6spkEvio+StSjrSeeJW"
Date: Wed, 28 Feb 2007 19:53:22 +0100
Message-Id: <1172688802.5015.70.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-W6spkEvio+StSjrSeeJW
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-02-28 at 19:45 +0100, Ivo van Doorn wrote:

> Actually it doesn't fix that problem. :( It remains possible to
> compile all drivers into the kernel but keeping rt2x00debug.ko as
> module. But the solution really would be:

True, I was thinking the other way around somehow.

> > But couldn't you just =20
> > link the debugfs module into the lib module instead of making it an own
> > module? I don't see any point in having it separate since there will be
> > a dependency anyway.
>=20
> My words exactly. ;)
>=20
> Merging those 2 modules has been placed on my todo list,
> I'll try to have this done as soon as possible.

Yeah, the patch won't be hard to do but needs some file renames so the
make system copes, and the initialisation hooks. I suppose most people
actually build either cfg80211 or mac80211 as modules it isn't really a
big issue right now.

Btw. Feel free to track things like this on linuxwireless.org somewhere
around the todo list, maybe someone else picks it up.

johannes

--=-W6spkEvio+StSjrSeeJW
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBF5c+h/ETPhpq3jKURAvUoAJ4kZhMHeLaIDf6m+Dm6bhoJFqWo9QCdHovB
B4IZiTEwlmUp9kuKjTe2lic=
=Pfi3
-----END PGP SIGNATURE-----

--=-W6spkEvio+StSjrSeeJW--

