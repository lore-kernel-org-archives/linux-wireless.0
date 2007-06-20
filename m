Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:34084 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753093AbXFTLur (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jun 2007 07:50:47 -0400
Subject: Re: [PATCH] clarify some mac80211 things
From: Johannes Berg <johannes@sipsolutions.net>
To: Jiri Benc <jbenc@suse.cz>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20070620134604.72ecbbc7@griffin.suse.cz>
References: <1182333960.3714.54.camel@johannes.berg>
	 <20070620134604.72ecbbc7@griffin.suse.cz>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ACKwzlyGGIDr/hdd4vnE"
Date: Wed, 20 Jun 2007 13:51:50 +0200
Message-Id: <1182340310.3714.65.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ACKwzlyGGIDr/hdd4vnE
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-06-20 at 13:46 +0200, Jiri Benc wrote:

> Maybe it's a time to finally get rid of open and stop callbacks...

Fine with me, there isn't really much point in them and it'll definitely
simplify code. Since drivers need to keep track anyway they won't be
more complicated... bcm43xx for example doesn't use it anyway...

johannes

--=-ACKwzlyGGIDr/hdd4vnE
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGeRTW/ETPhpq3jKURArNLAJ9zdsVBEuCMpTq0Iy8dAk5dx15ERgCeLIaA
ChIPhgpmRtky1g6SmyqIPhw=
=0gZS
-----END PGP SIGNATURE-----

--=-ACKwzlyGGIDr/hdd4vnE--

