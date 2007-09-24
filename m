Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:43215 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751558AbXIXJLD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Sep 2007 05:11:03 -0400
Subject: Re: [PATCH] zd1211: Fix crashes with NULL mac addresses (monitor  mode)
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: Ulrich Kunitz <kune@deine-taler.de>, Daniel Drake <dsd@gentoo.org>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200709231835.37069.mb@bu3sch.de>
References: <200709231626.22446.mb@bu3sch.de>
	 <20070923152743.GA23532@deine-taler.de>  <200709231835.37069.mb@bu3sch.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-evLNqgXJvGU2uVg8uvDW"
Date: Mon, 24 Sep 2007 11:12:17 +0200
Message-Id: <1190625137.18521.265.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-evLNqgXJvGU2uVg8uvDW
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2007-09-23 at 18:35 +0200, Michael Buesch wrote:

> Also, what's needed to get monitor during operation running?
> I guess it's only about removing the artificial restriction
> for this in the add_interface callback. Is there something else?

Michael, just ignore all this, the filter flags patch is on the way into
the tree and it gets rid of all that. No need to now try to fix it.

johannes

--=-evLNqgXJvGU2uVg8uvDW
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG939x/ETPhpq3jKURAmDvAKC6y5Y3+ubC1+nJnvc2ZZ9L9qIYkgCeLkdu
vaCJ5jqgO0otOXzE+q1IFbw=
=SnTx
-----END PGP SIGNATURE-----

--=-evLNqgXJvGU2uVg8uvDW--

