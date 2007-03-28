Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:51897 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753637AbXC1K0J (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Mar 2007 06:26:09 -0400
Subject: Re: WPA/RSN information in cfg80211?
From: Johannes Berg <johannes@sipsolutions.net>
To: Mark Powell <Mark.Powell@csr.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Jouni Malinen <j@w1.fi>
In-Reply-To: <460A3DC6.8030604@csr.com>
References: <1175034846.5151.20.camel@johannes.berg>
	 <460A3665.5090906@csr.com> <1175075263.5151.31.camel@johannes.berg>
	 <460A3DC6.8030604@csr.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-XdJhJ7410Q/1Rc9CmCoD"
Date: Wed, 28 Mar 2007 12:24:52 +0200
Message-Id: <1175077492.5151.46.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-XdJhJ7410Q/1Rc9CmCoD
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-03-28 at 11:04 +0100, Mark Powell wrote:

> > Putting the IE there has the advantage that you can easily play with ne=
w
> > things for cards that use the IE by sticking a few more IEs into the
> > attribute.=20

> I agree. Forming the MLME requests, including the IE, is really the role
> of the userland app (the SME in IEEE802.11 speak).

Right.

> > But it has the disadvantage that cards behave differently if
> > you give them contradictory settings. Maybe we need a way to ask a card
> > which one it wants.

> Is that just a case of garbage-in-garbage-out?

Yes, but I can just see it coming that the developer has a fullmac card
that accepts having no IE and then some users with a halfmac card that
needs the IE present is going to crap out. It'd be nice if we could
avoid that, but I think we probably can't without much overhead that we
don't want.

johannes

--=-XdJhJ7410Q/1Rc9CmCoD
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGCkJ0/ETPhpq3jKURAuJJAJ4s8Ot7X/i0Ak1ErDLj9GtwBDAUdACbBbaw
mNOAmV6sr0KV8pgBxTztRW8=
=vzQd
-----END PGP SIGNATURE-----

--=-XdJhJ7410Q/1Rc9CmCoD--

