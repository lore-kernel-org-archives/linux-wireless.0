Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:49833 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752759AbXDHIKR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Apr 2007 04:10:17 -0400
Subject: Re: RFC: ieee80211: Spamming of log resulting from packets with  ExtIV  not set
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <larry.finger@lwfinger.net>
Cc: Jouni Malinen <j@w1.fi>, wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <46171B36.6090108@lwfinger.net>
References: <4616DD7E.6010606@lwfinger.net>
	 <20070407013848.GG16197@jm.kir.nu>  <46171B36.6090108@lwfinger.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-/PYltyxa1r6FDnjbGNfL"
Date: Sun, 08 Apr 2007 10:10:13 +0200
Message-Id: <1176019813.8459.15.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-/PYltyxa1r6FDnjbGNfL
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-04-06 at 23:16 -0500, Larry Finger wrote:

> As far as I can tell, FCS errors are not filtered.

Actually, they are filtered by the firmware and never passed up to the
driver unless you set the "rx invalid frames" bit in the mac control
field. Since the driver never sets that except with some of the module
parameters (or is that modparm bcm43xx-mac80211 only?) the FCS on all
frames passed up should be fine.

johannes

--=-/PYltyxa1r6FDnjbGNfL
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGGKNk/ETPhpq3jKURAjHtAKCez9VgWMXVcOfi1dCLzIyDsqcYqgCfYi0i
J3K1OxK/JaP05Q9tAF2VAF4=
=K4eg
-----END PGP SIGNATURE-----

--=-/PYltyxa1r6FDnjbGNfL--

