Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:55886 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752533AbYDDPq1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Apr 2008 11:46:27 -0400
Subject: Re: SKB BUG: invalid truesize in AP mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Chr <chunkeey@web.de>
Cc: linux-wireless@vger.kernel.org, Tomas Winkler <tomasw@gmail.com>
In-Reply-To: <200804031807.53768.chunkeey@web.de>
References: <200804031807.53768.chunkeey@web.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-J+4yqlqetbO/c41GI732"
Date: Fri, 04 Apr 2008 17:46:24 +0200
Message-Id: <1207323984.19189.60.camel@johannes.berg> (sfid-20080404_164630_679778_C87CA786)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-J+4yqlqetbO/c41GI732
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

> [ 4439.730154] SKB BUG: Invalid truesize (712) len=3D524, sizeof(sk_buff)=
=3D200                                                                =20


> mostly when I'm testing the p54 ap-mode (station mode is fine)...
> but, I got them on my Intel 4965n (iwlwifi in 2.6.25-rc7-git5) too.
> nothing bad happend so far, other than MBs of spamming in the logs.
> So, is this a known problem and more or less harmless, or not?=20

Yes, it's a known problem, and seems to happen with TX packets whenever
you have a monitor mode (or just cooked monitor?) open. I don't know
what causes it but I'm fairly sure it's not harmless.

johannes

--=-J+4yqlqetbO/c41GI732
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR/ZNT6Vg1VMiehFYAQJ1Gg/+IhKCaldYj9TmkzSFcPAvXv+zt13Z49Aj
+0QlR3a8jzqNLXp4A1H+XvWPnwzcy6QnVMgt6dvPd5o8VCoZKmj1yT/wi3pP7JcS
8pxFiWdFNe5P3SN6pUf10vibSRL2nuxmxEDeqBXNy5T98rAE/OJSXlNJFg5ksjye
zgtbbaiZ2lzFAB6hcSo7QKQewev9XDuk1fbw1r7teDQptPlpRJzGM6nNDD/WXCmu
kbJNyJQGjK5uLJzXNLDU56JoLdUU1jJdI74XFHjk/czhcdQltADvmmWYiVjW5HRR
C64g29cx9UGrDDf8Adi1VRH7gDAJdEAifXpRLP/SAozAt+jgmQRf2hC7NWgqAKlX
P+rUOii8KQTlg3hzyZrU4HR1/ZNKiQ0tt991Nzm3hVl/AqjZCWghvBfvAvliYUHp
FY/1T8393uHDaFbIPGOeMh/8lQX2tUCrFaPLO4mbh56C00wmt+5oLnS3olQjArtW
LSXUXngsYn4ZzDZvBfy+f0Y07P6xkPUPC6KO3TIfG18/QYl8KZ66SzCLFbvUt6hw
F0e2ZISCgQzl6b6Gf1lPHNSOQPH2e/XvsxSez3eGWa6+vLtKZ5IrYwdk6BuW/vIO
f1bcuW5eei8BvUZezXzqUBrQu8l4SodviBaReXuvqsiIJAcooykOzywdCbTci5Bc
hmnpjPynfjI=
=vZ2R
-----END PGP SIGNATURE-----

--=-J+4yqlqetbO/c41GI732--

