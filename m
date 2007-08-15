Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:60550 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752420AbXHOKwO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Aug 2007 06:52:14 -0400
Subject: Re: [RFC] the recently discussed flags patch
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Jiri Benc <jbenc@suse.cz>, Michael Wu <flamingice@sourmilk.net>,
	Daniel Drake <dsd@gentoo.org>
In-Reply-To: <1187108515.4037.3.camel@johannes.berg>
References: <1187108515.4037.3.camel@johannes.berg>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-T7i25ryv8q01f3nuXo1N"
Date: Wed, 15 Aug 2007 12:54:52 +0200
Message-Id: <1187175292.3998.15.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-T7i25ryv8q01f3nuXo1N
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> After noticing that set_multicast_list is totally useless

That, of course, isn't true, so I shall be updating this patch to have
set_multicast_list again but only implement it for drivers that can
actually do multi-multicast filters, and use FIF_ALLMULTI for the
others.

johannes

--=-T7i25ryv8q01f3nuXo1N
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGwtt8/ETPhpq3jKURApq8AJ4yOKKa/va5XccMGgIJV6fDs4s0mgCfeRF6
ZO9u7CZ8IMVblWaQ7YQFs88=
=/6NW
-----END PGP SIGNATURE-----

--=-T7i25ryv8q01f3nuXo1N--

