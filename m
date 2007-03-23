Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:55842 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753418AbXCWUcb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Mar 2007 16:32:31 -0400
Subject: Re: [stable] [PATCH] fix information leak in wireless extensions  on 64-bit platforms
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: jt@hpl.hp.com, Chris Wright <chrisw@sous-sol.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>, stable@kernel.org
In-Reply-To: <200703232127.17790.mb@bu3sch.de>
References: <1174640787.3588.65.camel@johannes.berg>
	 <20070323193643.GY10574@sequoia.sous-sol.org>
	 <20070323200037.GA5165@bougret.hpl.hp.com>
	 <200703232127.17790.mb@bu3sch.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-xR64O3nrtg6uACMVN/Ev"
Date: Fri, 23 Mar 2007 21:31:09 +0100
Message-Id: <1174681869.7414.1.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-xR64O3nrtg6uACMVN/Ev
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-03-23 at 21:27 +0100, Michael Buesch wrote:

> I finally have an USB ZD stick now, too. So I can test stuff, too.
> Should I test this somehow?

If you can, build libiw and wireless tools 32-bit programs and enable
the debug dump of the actual message (see one of my original mails),
then run them with scanning. You'll get a wrong message and some zeroes
where in my example the padding was not zeroed.

johannes

--=-xR64O3nrtg6uACMVN/Ev
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGBDkN/ETPhpq3jKURAgiCAKCViDjh4YFR//w0Op1L3IUyLUN1XQCaArz3
zNs4yv6qYX0oDlkaOZ9STyc=
=KkRm
-----END PGP SIGNATURE-----

--=-xR64O3nrtg6uACMVN/Ev--

