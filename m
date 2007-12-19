Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:59632 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753440AbXLSQFi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Dec 2007 11:05:38 -0500
Subject: Re: [patch 4/9] mac80211: Make PID rate control algorithm the
	default
From: Johannes Berg <johannes@sipsolutions.net>
To: Mattias Nissler <mattias.nissler@gmx.de>
Cc: Stefano Brivio <stefano.brivio@polimi.it>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1198008087.7553.9.camel@localhost> (sfid-20071218_200138_269873_1AF5AE72)
References: <20071217012517.882216322@gmx.de>
	 <20071217012550.213561122@gmx.de> <20071217150202.GC3121@tuxdriver.com>
	 <20071217210649.370ba385@morte> <20071217204112.GE3121@tuxdriver.com>
	 <20071217221610.7906f3e2@morte>  <1197982157.4885.124.camel@johannes.berg>
	 <1198008087.7553.9.camel@localhost> (sfid-20071218_200138_269873_1AF5AE72)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-aeFgVRH8zK4JsAOcdTBq"
Date: Wed, 19 Dec 2007 17:05:27 +0100
Message-Id: <1198080328.4747.17.camel@johannes.berg> (sfid-20071219_160551_139417_2B51B708)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-aeFgVRH8zK4JsAOcdTBq
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> The only issue I know about is that if people disable module auto
> loading, they'll end up without rate control algorithm. If you don't
> like this, please comment on how to fix it.

That's exactly the issue we had before hence we started building one
into mac80211. Please build the default one into mac80211 and the other
one as a module *and* fall back to the built-in one when the default was
changed via debugfs but that one is not available.

johannes

--=-aeFgVRH8zK4JsAOcdTBq
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR2lBRqVg1VMiehFYAQJJeg/9FImUPKkR5sFcarf4FPNT6xlNgGC1urfQ
+zTUtnuMTJNav5KVsLXXZfR0McEGTA6fBauF3X7UjMaDnHr8pa4zKR1cTL/YglRq
oFOylRSydp6N/l4MMdFWFw8/qBUxnZCl3iRNqUUx+NqM29wesM7gN/LB7MjsjK+x
4TpmK/PJLa7vf4O1CSEA6ZiE1jmrxvuIKs7gu1MbU55joWRSURPSHbWfj9/MLWqC
x16a6owai2G8DWEKejbkgn9ELDDvbGt/JS9d+PS/9xFsx5PaxPZPm3nt9EvbR/aX
3SyRnS+eBnF8DDf3YPANiyJEipSpNLV5bopthPEnkRitph4T0vlJY1JocH/k1/DR
lWDfbtntRznNPmkW32TdZj0Eay5audo06zK4K2sEUtRn3e1iW75pnYfQS3GdwG7h
gp0kwa268/PKYoNEjTwLI5b+yXJaTxvYNz/96GyTMDCy5pFqevjCXozV1UPDiTkv
q3jQEE+kUnnMHz/Dmg/9A6riO3w++Z9VpAoscdOKtThBQnWxwnELkSR/mdVhhtUn
UFHytTkI4emhUuCmFJ9cifpZpR/hZaAko2rxkThsYm9LIN4PGx343vx3qxs7Yq6W
vjM/yP9SDhbJVouULTT1S8utodzygavjf7Q7WYYON6ZU2Jnz7F4T5sa0rg5HmbHa
q5tJMFKjTRY=
=DpoL
-----END PGP SIGNATURE-----

--=-aeFgVRH8zK4JsAOcdTBq--

