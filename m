Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:51380 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760137AbXHFJPm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Aug 2007 05:15:42 -0400
Subject: Re: suspend/resume support in mac80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: Mattias Nissler <mattias.nissler@gmx.de>,
	linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
In-Reply-To: <200708052344.12673.mb@bu3sch.de>
References: <1186343417.8459.23.camel@localhost>
	 <200708052344.12673.mb@bu3sch.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-2rX8q1cqc85WAMUFrICq"
Date: Mon, 06 Aug 2007 11:17:42 +0200
Message-Id: <1186391862.28655.28.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-2rX8q1cqc85WAMUFrICq
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2007-08-05 at 23:44 +0200, Michael Buesch wrote:

> I think we should have a API call to mac80211 that suspends the stack
> (saves the state etc..) and a call the resumes (reassociates, re-handshak=
es...).
> But that's probably not that easy to implement, as parts of this
> does happen in userspace.

At the minimum it should be resetting the keys. Reassocation etc. could
probably be done as well if using the in-kernel MLME.

johannes

--=-2rX8q1cqc85WAMUFrICq
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGtuc2/ETPhpq3jKURAlJRAJ9xktcCVl3ZUxJ+0pi+t1MI7RN4PwCghg8P
vXgJyj3C+yBcVExtOtoI6UQ=
=L81D
-----END PGP SIGNATURE-----

--=-2rX8q1cqc85WAMUFrICq--

