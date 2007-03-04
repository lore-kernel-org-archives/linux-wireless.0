Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:45141 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156AbXCDAVg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 Mar 2007 19:21:36 -0500
Received: from [84.135.242.150] (helo=[10.0.0.4])
	by sipsolutions.net with esmtpsa (TLS-1.0:RSA_ARCFOUR_MD5:16)
	(Exim 4.63)
	(envelope-from <johannes@sipsolutions.net>)
	id 1HNePP-0001sO-7y
	for linux-wireless@vger.kernel.org; Sun, 04 Mar 2007 00:17:03 +0000
Subject: Re: question: /sys/class/net/*/wireless
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
In-Reply-To: <1172921257.4966.12.camel@johannes.berg>
References: <1172920691.4966.6.camel@johannes.berg>
	 <1172921257.4966.12.camel@johannes.berg>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-GdV71bUXVUhUkHO9Q63m"
Date: Sun, 04 Mar 2007 01:21:09 +0100
Message-Id: <1172967669.3402.0.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-GdV71bUXVUhUkHO9Q63m
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2007-03-03 at 12:27 +0100, Johannes Berg wrote:
> And related to that issue, /proc/net/wireless.

Actually, that was pointless. I should have checked before, but forgot
to, /proc/net/wireless lives in wext-common.c now which is compiled
whenever you have cfg80211/wext-compat and/or wext configured.

johannes

--=-GdV71bUXVUhUkHO9Q63m
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBF6hD1/ETPhpq3jKURAoIDAJ0bRINyU1DKd9w+hUW3kagBDL4KLACbBO/T
8W+t761pHvu515jYvNEgcbg=
=vJio
-----END PGP SIGNATURE-----

--=-GdV71bUXVUhUkHO9Q63m--

