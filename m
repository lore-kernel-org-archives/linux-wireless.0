Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:51423 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751966AbXHOK7o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Aug 2007 06:59:44 -0400
Subject: patch mess
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, jbenc@suse.cz,
	flamingice@sourmilk.net
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-a9NrhMzKHaewrmUFHXzj"
Date: Wed, 15 Aug 2007 13:02:22 +0200
Message-Id: <1187175742.3998.25.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-a9NrhMzKHaewrmUFHXzj
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hey,

It seems I've made quite a mess with patches interdependent on hostapd
and kernel patches.

Please drop all my patches for now.

Now that Jouni has merged a bunch of my patches I'll be going through
later today and will repost those that can be applied now because the
corresponding patches to hostapd have been merged, and I'll hold the
other ones. Then I'll rebase the other ones and post them as RFC again.

Review would still be appreciated :) I have, however, found a few minor
bugs in some patches that I've fixed too.

johannes

--=-a9NrhMzKHaewrmUFHXzj
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGwt0+/ETPhpq3jKURAngQAJ9TDd1Ab4710uRNoNQXZSm0mn64rACgki1E
phvqDmFRGtesHxMcEp2wOAY=
=JOkZ
-----END PGP SIGNATURE-----

--=-a9NrhMzKHaewrmUFHXzj--

