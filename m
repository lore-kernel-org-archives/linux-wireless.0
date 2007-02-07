Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:52988 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161226AbXBGLrY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Feb 2007 06:47:24 -0500
Subject: Re: d80211: Fix TKIP key type
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: Michael Wu <flamingice@sourmilk.net>, Jiri Benc <jbenc@suse.cz>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200702061644.11150.mb@bu3sch.de>
References: <200702031832.48505.mb@bu3sch.de>
	 <20070205221957.3c9003b5@griffin.suse.cz>
	 <200702061033.50134.flamingice@sourmilk.net>
	 <200702061644.11150.mb@bu3sch.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-L80WVWnskIoGEyk/wluk"
Date: Wed, 07 Feb 2007 12:44:28 +0100
Message-Id: <1170848668.6798.13.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-L80WVWnskIoGEyk/wluk
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2007-02-06 at 16:44 +0100, Michael Buesch wrote:

> So I think we need a callback or something that sets the key in HW.
> Maybe we can do that in the already existing set_key callback.

Yes, your original patch with the library functions should be fine, if
the driver needs it it can request it either in set_key or during tx (if
the TSC cycled or whatever)

johannes

--=-L80WVWnskIoGEyk/wluk
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBFybuc/ETPhpq3jKURAnc9AKCJtJdo9SSnMWKW6AZZKedT5p3doQCfcD2z
44nG2/kf4eFAESJTmCl0O8M=
=E1f4
-----END PGP SIGNATURE-----

--=-L80WVWnskIoGEyk/wluk--

