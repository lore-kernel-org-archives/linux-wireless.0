Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:50007 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759997AbXHYH4P (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Aug 2007 03:56:15 -0400
Subject: port of my recent patches to net-2.6.24
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-UiRHJLJCBUV9tkf9/MsF"
Date: Sat, 25 Aug 2007 09:37:50 +0200
Message-Id: <1188027470.9529.5.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-UiRHJLJCBUV9tkf9/MsF
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Because everybody has already seen these patches I won't be sending them
to the list again, uploaded here:

http://johannes.sipsolutions.net/patches/net-2.6.24/

That contains ports of my and Jiri Slaby's recently merged patches to
the net-2.6.24 tree minus those that don't apply because they delete
ioctls that aren't in that tree (patches 0..23) plus some other patches
I cherry-picked that I think should go in (024, 025), some whitespace
and comment cleanups to make it more like wireless-dev (026, 027). Then
there's your multicast fix (028) and those parts of the series I posted
yesterday that don't depend on nl80211 (029..035).

I've merged the event.c copyright patch (that I accidentally forgot to
copy to the list but it only added 6 lines copyright statement) into the
relevant cleanup patch (015).

johannes

--=-UiRHJLJCBUV9tkf9/MsF
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGz9xN/ETPhpq3jKURAhG3AJ96lMLM17W9QSrpwkTatnwDjbyjkwCgiX+D
hJC8ocW73JyX/RYR7BTRBlc=
=tq3H
-----END PGP SIGNATURE-----

--=-UiRHJLJCBUV9tkf9/MsF--

