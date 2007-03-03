Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:34383 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965254AbXCCMM0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 Mar 2007 07:12:26 -0500
Received: from [84.135.251.95] (helo=[10.0.0.4])
	by sipsolutions.net with esmtpsa (TLS-1.0:RSA_ARCFOUR_MD5:16)
	(Exim 4.63)
	(envelope-from <johannes@sipsolutions.net>)
	id 1HNT1n-0005p9-5z
	for linux-wireless@vger.kernel.org; Sat, 03 Mar 2007 12:07:55 +0000
Subject: straw poll: new Kconfig symbol for mac80211 debugfs?
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-FgelKFngyYwiawh9+idm"
Date: Sat, 03 Mar 2007 13:12:03 +0100
Message-Id: <1172923924.4966.41.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-FgelKFngyYwiawh9+idm
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

After moving all the sysfs stuff to debugfs I notice that it is quite a
large amount of code. Does anybody think having a new Kconfig symbol for
that like this one

config MAC80211_DEBUGFS
	bool "DebugFS support"
	depends on MAC80211
	---help---
	  Select this to see extensive information about
	  the internal state of mac80211 in debugfs.

	  Say N unless you know you need this.

would make sense?

johannes

--=-FgelKFngyYwiawh9+idm
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBF6WYT/ETPhpq3jKURAjF9AJ9Eic35DUe37zEnQRl0+uahyYXlQACfeVs7
fvleHc8YMk/VtCSYFBuIcMA=
=/xls
-----END PGP SIGNATURE-----

--=-FgelKFngyYwiawh9+idm--

