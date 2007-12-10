Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:38415 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752246AbXLJQRr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2007 11:17:47 -0500
Subject: Re: coding style lesson: iwlwifi vs. endianness
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Dan Williams <dcbw@redhat.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Zhu Yi <yi.zhu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <1ba2fa240712100810s1216bee4v8142fb9a279feedf@mail.gmail.com> (sfid-20071210_161015_599477_99D634D7)
References: <1196189059.6058.95.camel@johannes.berg>
	 <1ba2fa240711281020n6052980cl610f6c790788d2da@mail.gmail.com>
	 <1196286192.4967.29.camel@localhost.localdomain>
	 <20071129005810.GA6161@tuxdriver.com>
	 <1ba2fa240711291502k65cefd5au60f2c22d6f436c82@mail.gmail.com>
	 <1197286949.6035.49.camel@johannes.berg>
	 <1ba2fa240712100618g35a8e13ve143f8687f1b531a@mail.gmail.com>
	 <1197299937.6035.81.camel@johannes.berg>
	 <1ba2fa240712100810s1216bee4v8142fb9a279feedf@mail.gmail.com>
	 (sfid-20071210_161015_599477_99D634D7)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-EAsx/Kl6HE9rfhlC8zKn"
Date: Mon, 10 Dec 2007 17:17:05 +0100
Message-Id: <1197303425.6035.89.camel@johannes.berg> (sfid-20071210_161750_153405_99FB5177)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-EAsx/Kl6HE9rfhlC8zKn
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> This is really arguing about taste and feel. I don't find it more
> confusing then any mixture of native and some-endian platform. I don't
> know how to measure it but I didn't see any endianity bug for more
> then 6 months  so I guess my approach is working.

I recently fixed one due to this style in the ieee80211 TKIP (or QoS?)
code.

johannes

--=-EAsx/Kl6HE9rfhlC8zKn
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR11mgKVg1VMiehFYAQLIHg/+N8d4Jrbb16QjMCgVFQG6kk9+hSQJl4yX
ytCi2mReNLny7PAqrR+pxFVoHVGz5XkqE4FDl8HJJOcytTejmLfczxhMDqnKKGZg
66K3GE3DjD3AjnytE7iI/qsaM9Zja2ghbrmp+nJ83C4tLodvcxmjRfIj/VEbxE6y
D24VukRvQ+yMieWjzDGkbki06IAlBnijQYrbbo5sJ1/Uux1YZYtg8AalYEIEeqq/
kvZJgY7S4u7z3nRa33E0KO4F6YR2Hfchs0DiDCXmfp/xNvmYAcw/rAd3YhblyPID
3/5OvHSFRGfUl4VS0w3kk/omLhzYeafYCL43l4Jv7oHNnqc7l/J3L/X9UGWOPN+y
O5dgcOtQXwpiEodkyFZ4hoppi1/9StlhPv0kLR1KZGesLsOC4SPQ6nW74xAVd3w2
xFT7f0Bm3vQy20PowMpoentQVwdtYg2l8J22hRfNjQpZxpvXF6Xc5RdQHpReL6ja
k/8H3UlIhkUW2zWXbeBhsp6YFDh9/4TLt4asKGlExR73HOOTeRw3Bs+T8dbHO/0m
0Rnsn2yEeneKZRMWGQRSCT2HTw8sA5ta0fA9L/vmuqkft7HHqWmDmLJK//3vjguF
1Pmts+qB56Zvep7zF6xDaREyEFwmBiwW9GGcAXFDvoZd6TySAV+a+54yeOSWM3aq
2zQubJPFDj4=
=GBoR
-----END PGP SIGNATURE-----

--=-EAsx/Kl6HE9rfhlC8zKn--

