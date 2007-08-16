Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:38680 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764974AbXHPQNo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Aug 2007 12:13:44 -0400
Received: from [131.234.209.34] (helo=[131.234.237.45])
	by sipsolutions.net with esmtpsa (TLS-1.0:RSA_ARCFOUR_MD5:16)
	(Exim 4.67)
	(envelope-from <johannes@sipsolutions.net>)
	id 1ILhyh-00039k-9e
	for linux-wireless@vger.kernel.org; Thu, 16 Aug 2007 17:13:43 +0100
Subject: mac80211 hardware flags
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-gMxx1swPomJSRK1z5sox"
Date: Thu, 16 Aug 2007 18:16:28 +0200
Message-Id: <1187280988.23489.29.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-gMxx1swPomJSRK1z5sox
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hey,

Currently, it looks as though many drivers otherwise well-maintained
should be setting hardware flags but don't, this is often because of the
weird semantics of these flags, e.g. IEEE80211_HW_NO_PROBE_FILTERING.

Would anybody object to doing the dumb-down thing and having flags only
set for hardware to enable special features or work around hardware
limitations?

I propose to add some prose to mac80211.h that if you add flags it
should be done that way, and invert the meaning of
IEEE80211_HW_DATA_NULLFUNC_ACK now.

Any objections?

johannes

--=-gMxx1swPomJSRK1z5sox
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGxHhc/ETPhpq3jKURAgqpAJ0UFe3PcX4YlWUjYCHwLJkUvdEf0wCgnKh4
DpRpaJJolr4/Ibt7YgDJW0M=
=iHpX
-----END PGP SIGNATURE-----

--=-gMxx1swPomJSRK1z5sox--

