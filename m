Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:43353 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755427AbYCXKV6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Mar 2008 06:21:58 -0400
Subject: Re: [PATCH] mac80211: trigger ieee80211_sta_work after opening
	interface
From: Johannes Berg <johannes@sipsolutions.net>
To: Jan Niehusmann <jan@gondor.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Michael Wu <flamingice@sourmilk.net>, Jiri Benc <jbenc@suse.cz>
In-Reply-To: <20080323235718.GA5389@x61s.gondor.com>
References: <20080323192355.GA5773@x61s.gondor.com>
	 <1206310595.16475.190.camel@johannes.berg>
	 <20080323235718.GA5389@x61s.gondor.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-lSVk1nfZPjIaolfAfKXq"
Date: Mon, 24 Mar 2008 11:21:43 +0100
Message-Id: <1206354103.16475.192.camel@johannes.berg> (sfid-20080324_102204_594059_EF86AA85)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-lSVk1nfZPjIaolfAfKXq
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> BTW, after doing this, I noticed that setting essid first and the WEP
> encryption key later didn't lead to associated state. Again, I had to
> trigger association by calling 'iwconfig wlan0 essid ...' or 'iwconfig
> wlan0 ap any' after setting the key. Is this behaviour expected?

Yes, and for sure not going to change.

johannes

--=-lSVk1nfZPjIaolfAfKXq
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR+eAtaVg1VMiehFYAQJ2cw//fvNLnEuRWBnRt36JaU3EZxP1CyMAYCf6
ETLEpEMOpNeWxCBb5fEW+T4al7HC9iAgaMsOMkJBQcjjq3bYDjATlSboOjLmAbhF
Wi98g8EPb2E/mG8tE7HQb6M/3vWJUuQ3TPdUtRbw4hNcMXLF1FPy2y69fRmfPmjU
dYak2208C3gLFrEhPVz1Vg18QMej8S2OU5pjzonhx3uMYq3vCjr5LguNvOR5mEvj
jqT64AY6bO/rooo3Lr67/coTinus8bdCKvAaF4tbyu8j7naDJAHxCeAQVXjskbHP
pPLmDrR5jrh930VfZ11FL/5xqINRemlE4Q5Kkb9hjNHcbK8EvKdyWOx6DowWnpze
puAXnYoaWIEud8KHgyP+X+A2JIt6jFuDRTFBniH6W8N9owKb8/lDwoFOtSVjV9pp
I8mm/yLuzO7fJbp4zfPDaFT8cLF3NHVS5xqUNoBjCHgydJZj9ZnfBloS3jDrg3Qb
HCe9A+hl9f9bviyvRwQ8AahtoP439homXmiTh8j32wd0I3Ps1YE50N+0kkKCznjF
0WKKLKhNcQJnBgCvpcrPriWKXaN4DqUlOGloI+OceneGvZGTLu8rsT/IDAK7XD7s
EHAh4/YHTuS++6k/kx7eV1H/J7LcazB3B83cEvsOMfpzVHPvND30WKBo26GPQq7Z
xvCR3z5jLvc=
=LCop
-----END PGP SIGNATURE-----

--=-lSVk1nfZPjIaolfAfKXq--

