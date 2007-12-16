Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:49021 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754732AbXLPVAd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Dec 2007 16:00:33 -0500
Subject: Re: b43 problem with led trigger registration
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Richard Purdie <rpurdie@openedhand.com>
In-Reply-To: <1197837505.6769.25.camel@johannes.berg> (sfid-20071216_203834_318779_C51C7629)
References: <1197822019.4138.2.camel@johannes.berg>
	 <200712162036.11084.mb@bu3sch.de> <1197835176.6769.21.camel@johannes.berg>
	 <200712162126.56483.mb@bu3sch.de>  <1197837505.6769.25.camel@johannes.berg>
	 (sfid-20071216_203834_318779_C51C7629)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-aBlYhJJWlt6c3cMXqh4C"
Date: Sun, 16 Dec 2007 22:00:26 +0100
Message-Id: <1197838826.6769.36.camel@johannes.berg> (sfid-20071216_210036_815003_43C1EE15)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-aBlYhJJWlt6c3cMXqh4C
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> Not with default triggers, I guess. The code in question only triggers
> when a default is assigned to any LED I think.

Come to think of it, it only triggers if the LED-trigger is registered
before the LED, unrelated of whether we have defaults or not.

johannes

--=-aBlYhJJWlt6c3cMXqh4C
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR2WR6aVg1VMiehFYAQJxzQ//f0keEFXiIbrHuJAFS/T/l1JQPmpr5rJS
3Au999ZfVuab2jR59xoRo5pft/0aXt7q2b4LmOuNg6nPL+SitwAghD8ThaOewQJe
+x5wLOOUdt2jHdvu66h7Z5Vv7oc3iFJymKvXpnkNQUizI+TcDcV7uoA0GyhAbcPN
mBkXVLpwtKVb+gmBEIfDUvpJuROSN0/fM5Rw1D95zshCQGeEjrNjDRyQN5/MYWLg
eD8g+W4MIbBRWIb7kokKlrtf8EuObwcJIMAMXPl2Zpo9/EY9LZiA8aBXzwqZ4yhG
jgoLID7zGHJKpS1Nb8VAZWFUInQKWilnhdhtZ9ItosOjzO34LYO/wG0MfMhP0gbM
XelgJIJ6vbUx25+PoAg1wts9bQs4lp7xDJtoEyLqY7RFIJ6bbR74vmCiaxHo66Tw
wr2tcYXCaaBNVAvvzcVWYO3k2K8Zrw86YhSTEr/5X+U3+zo1EHNyogVW/rXGhJud
bON9xgOYixFya8x/CvVJMvv+Koh6mgf+pMuEBgrrAlXPUZnKtNQ5TEJ2Q7vN31Il
1KB8URT3rf5Aw7tPB+ADt0UXAAK/Nu6tVVs+U/gsqMLH2Qx58tbJJ3hP8S0Y4E74
q08Bd1VQmNH6+YiM/Pat0wqNjtQbAOC8eETCDNUP5aRTdQ5X6yY8z6Z20TBfSTrl
1g/bYEa17GE=
=djG5
-----END PGP SIGNATURE-----

--=-aBlYhJJWlt6c3cMXqh4C--

