Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:58499 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757351AbXFAJsY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Jun 2007 05:48:24 -0400
Subject: Re: [PATCH] mac80211: Update stop_queues kdoc
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: Michael Wu <flamingice@sourmilk.net>, Jiri Benc <jbenc@suse.cz>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200706011129.12432.mb@bu3sch.de>
References: <200706011129.12432.mb@bu3sch.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-fQNKtIm7exeHd86tzl0O"
Date: Fri, 01 Jun 2007 11:48:11 +0200
Message-Id: <1180691291.18266.3.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-fQNKtIm7exeHd86tzl0O
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-06-01 at 11:29 +0200, Michael Buesch wrote:
> This updates stop_queue(s) kdoc as currently there's
> a undocumented dependency.
>=20
> Stopping the queue from anywhere else than the ops->tx()
> callback will result in a hard to debug deadlock and
> system freeze (on UP).

Ugh. Any way to actually detect a wrong spot to call it at runtime?

johannes

--=-fQNKtIm7exeHd86tzl0O
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGX+tb/ETPhpq3jKURAvBjAJ9Ma3Hrx0vkSsb2Q1OG6H0PYNjMLwCeKzVH
ramJweMJXbwQa+4kDL4Snko=
=dGk4
-----END PGP SIGNATURE-----

--=-fQNKtIm7exeHd86tzl0O--

