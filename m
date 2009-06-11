Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:32790 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758882AbZFKTJh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Jun 2009 15:09:37 -0400
Subject: Re: [ath9k-devel] [PATCH] mac80211: disassociate when switching
 bands  and not scanning
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Kalle Valo <kalle.valo@nokia.com>,
	reinette chatre <reinette.chatre@intel.com>,
	"Zhu, Yi" <yi.zhu@intel.com>, "j@w1.fi" <j@w1.fi>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>,
	"Abbas, Mohamed" <mohamed.abbas@intel.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>
In-Reply-To: <43e72e890906111204g18e71720w97cb2ea346e5d663@mail.gmail.com>
References: <1244666131-20031-1-git-send-email-lrodriguez@atheros.com>
	 <1244666973.20900.399.camel@rc-desk>
	 <43e72e890906101349t502e9022h16fa79ea512f8b4d@mail.gmail.com>
	 <1244667817.20900.402.camel@rc-desk>
	 <43e72e890906101404l6a8bee67r560f7c8a1c5f8c36@mail.gmail.com>
	 <1244668077.4706.4.camel@johannes.local>
	 <43e72e890906101542l5064384auf027267a3d19f3ee@mail.gmail.com>
	 <43e72e890906101544i22bacc8fxa0a7d045eea50280@mail.gmail.com>
	 <43e72e890906111204g18e71720w97cb2ea346e5d663@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-eBniXGOS4yVWvsS0u2jG"
Date: Thu, 11 Jun 2009 21:10:16 +0200
Message-Id: <1244747416.29447.2.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-eBniXGOS4yVWvsS0u2jG
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-06-11 at 12:04 -0700, Luis R. Rodriguez wrote:

> As expected I was able to reproduce the warning with atht5k and ath9k
> on 2.6.30. I did not get a crash with ath9k though, which is good. But
> the warning is still present.
>=20
> Do we want to fix this for stable? If so is the patch I posted reasonable=
?

Which patch are you talking about now? This disassociate one? If yes, I
think I'd prefer to have mine so we don't diverge much and I can still
remember what's going on where :)

johannes

--=-eBniXGOS4yVWvsS0u2jG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKMVaUAAoJEODzc/N7+QmaXdQQAMMWzOg9UhYvDiDGFlZNkK/a
y6LyHjssVuQjzAOoBhhUtjd00GqDR5yrNsyFxSnSDnt1dqujZ13tK7c3rOrUbxLX
1TiET2B4MWG0y5zviDJqoYgO77oL3PMg/1wud0ajg6GhW4xvw7LtKsPa2KkCtIud
XU72ikxmzQOAKzBX263mYGy1vh57WU1pPUdgIUzknJMolN9iYfiudXVKMdJ5qZIW
DQJ9TFeYDuR6cInvjfnTuLRPgz3r4sWiF29JDziFuGuCpuOmikw2mOQrGi6nJaji
dd+bdtcIF88dQsKlIeWJQuGkrAae1r0YJqaW1i9tBCkVVqaENZbjWNwL1ER8uAOt
bIeRAnACDC+muCLo8epXok5yOWqE4YwJEeBtgZPARN/M33AHT+xBaOyyyFq7qR21
U9SOKk9NBirYskQH07TxtDjcjH1XWPW2wx8Ct5VlHAU1FEsUuRXPAifbvmYSPCAp
0uC70qjEur3CUhA8QiHEdfKGKYOsZr8GdT+VwmHUP8pe0UamQ3/kf92DRn6NoJWH
iNn8J9CnyW59r5L0AEhLHFPVURgg0AgkTMDiGuzUsUsJqQvnAQwGoF8pIFkmv/3F
mwNebhLqd6UXStymjW+gXW+AlRdnHaeZ9abPUqF5dckz+O5X93dl/Ya7xPlT57x0
EZy3U928rabNwJcAvx0L
=5Inc
-----END PGP SIGNATURE-----

--=-eBniXGOS4yVWvsS0u2jG--

