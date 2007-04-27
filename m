Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:49417 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757189AbXD0URp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Apr 2007 16:17:45 -0400
Subject: Re: [PATCH] mac80211: don't export linux/ieee80211.h
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Wu <flamingice@sourmilk.net>
Cc: Jiri Benc <jbenc@suse.cz>, linux-wireless@vger.kernel.org
In-Reply-To: <200704271554.55770.flamingice@sourmilk.net>
References: <200704271554.55770.flamingice@sourmilk.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Pm1D0UX8SMmeJKt4Ke7O"
Date: Fri, 27 Apr 2007 22:17:40 +0200
Message-Id: <1177705060.3565.55.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Pm1D0UX8SMmeJKt4Ke7O
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-04-27 at 15:54 -0400, Michael Wu wrote:

> The definitions in linux/ieee80211.h don't need to be exported.

Actually, cfg80211 depends on the cipher suite defines. These are of
course well-known constants and can be found in the specs, but I don't
see the point of not just exporting them.

Does anybody remember a reason why this should not be exported?

johannes

--=-Pm1D0UX8SMmeJKt4Ke7O
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGMlpk/ETPhpq3jKURAic5AJ9xOqq7ehSp/pRRNbkqcHh/R50cCgCgnpDd
v1Wt1FYtr13ArsSWjBID2HQ=
=LA0s
-----END PGP SIGNATURE-----

--=-Pm1D0UX8SMmeJKt4Ke7O--

