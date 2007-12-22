Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:44622 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753195AbXLVVPM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Dec 2007 16:15:12 -0500
Subject: Re: [RFC] mac80211: add unified BSS configuration
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Ron Rindjunsky <ron.rindjunsky@intel.com>,
	Ivo van Doorn <ivdoorn@gmail.com>,
	Michael Wu <flamingice@sourmilk.net>
In-Reply-To: <1ba2fa240712221255q2daee8eehf84e1a5829ad2ac0@mail.gmail.com> (sfid-20071222_205552_405839_90FFB5B0)
References: <1198109817.16241.7.camel@johannes.berg>
	 <1ba2fa240712221255q2daee8eehf84e1a5829ad2ac0@mail.gmail.com>
	 (sfid-20071222_205552_405839_90FFB5B0)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-LK0YCKgAsuV+K1mDStnJ"
Date: Sat, 22 Dec 2007 22:15:02 +0100
Message-Id: <1198358103.6630.10.camel@johannes.berg> (sfid-20071222_211516_952266_5639577D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-LK0YCKgAsuV+K1mDStnJ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> Except assoc id we need also TSF from the beacon before we can drop
> the sniffing code.

What would you need the TSF for? You don't know how long afterwards you
got it anyway, no?

johannes

--=-LK0YCKgAsuV+K1mDStnJ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR21+VaVg1VMiehFYAQLOFw/+JQFRZafH31xi3CMix/+A7dAZzgFlJQ0r
arMfeYPPrnzVdQ6ZOrbCgeshsFdKUxNlBX/JJBr7h9xex3aE8NuHXL9jk0Jp7Rth
OcfpXfryF+RYGFxW0BwNEfawcejallEaHI45wYLKEEusEkF47VfZjOLqTBuYhmmv
+A4oARqLdAa/BYw1tUDCcgHelZzOvayj/iF9a/YfyyuVfgG830TofCsNq/Rs7H5E
HIjXa1nbBPVlARHbHeFhFSRrqmiTLkK1jncMOoB46rBNgGlNY2WvfN0Xs4dTXzKj
0GEkv7N65OpCt1clwuu3suuHWF4jjTpJPB0VkGHVoEnibfDKyHPJ8fUhdONaG5fH
6LWU3F28/qJ5/6xRaAVdbRW/VESLYhFBTBvz552P6teU7HMiKkXhamL2A8z0bYZv
CUi5TPfFnPksCB8yWFEbuavsG+XE59Ny04pSh9dxm88S3K2GLS15VoHWyigGBShA
l7uKHZ6VGTnOp2Ybn3eh4BbmBCr34bfSw+S7bTsNnlB2/ShDmw9rTh47d7dRHNTn
5L7YiC/JsBGZBUbD1GhCKuPwBR13oiY/qSXUsY7cXnY8YrlonQeirjwBF7r+ZV/U
EZ0afAWPVBJthnDy+OEMJRaNpRbksYd4gHp64IhhhkNUnDEFsQ4Zpr+ath6BXjDc
bwIPLysI95U=
=ijgK
-----END PGP SIGNATURE-----

--=-LK0YCKgAsuV+K1mDStnJ--

