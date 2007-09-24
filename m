Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:56859 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754565AbXIXT2J (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Sep 2007 15:28:09 -0400
Subject: Re: zd1211 config operation problem
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Wu <flamingice@sourmilk.net>
Cc: Michael Buesch <mb@bu3sch.de>, Ulrich Kunitz <kune@deine-taler.de>,
	Daniel Drake <dsd@gentoo.org>, linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
In-Reply-To: <200709241522.21156.flamingice@sourmilk.net>
References: <200709231648.17107.mb@bu3sch.de>
	 <1190654401.18521.272.camel@johannes.berg>
	 <1190654481.18521.274.camel@johannes.berg>
	 <200709241522.21156.flamingice@sourmilk.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-qoLQduqoY1U/oObY5czV"
Date: Mon, 24 Sep 2007 21:29:25 +0200
Message-Id: <1190662165.18521.284.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-qoLQduqoY1U/oObY5czV
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-09-24 at 15:22 -0400, Michael Wu wrote:

> I'm pretty sure that was done for all cases at some point. When did it ge=
t=20
> switched to being done for just monitor?

Looks like an oversight in the filter flags patch. I'll take a look
tomorrow.

johannes

--=-qoLQduqoY1U/oObY5czV
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG+BAV/ETPhpq3jKURAjB8AJ0Z5oOnqo0MiADVamIQSDPUbA53JACgpSEt
xTNhv6jgapmrApg+cabhS54=
=OczP
-----END PGP SIGNATURE-----

--=-qoLQduqoY1U/oObY5czV--

