Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:46668 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753515AbXLQBJY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Dec 2007 20:09:24 -0500
Subject: Re: [patch 4/9] mac80211: Make PID rate control algorithm the
	default
From: Johannes Berg <johannes@sipsolutions.net>
To: Stefano Brivio <stefano.brivio@polimi.it>
Cc: mattias.nissler@gmx.de, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <20071217015748.5bb3f7fc@morte>
References: <20071217001956.640555983@gmx.de>
	 <20071217002056.351743954@gmx.de> <1197852547.4885.1.camel@johannes.berg>
	 <20071217015004.2400ab33@morte> <1197852873.4885.2.camel@johannes.berg>
	 <20071217015748.5bb3f7fc@morte>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-+Ay7h8SanTmoOl4lyF8T"
Date: Mon, 17 Dec 2007 02:09:17 +0100
Message-Id: <1197853758.4885.4.camel@johannes.berg> (sfid-20071217_010927_788354_A065135B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-+Ay7h8SanTmoOl4lyF8T
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> That was my original proposal, but during a recent discussion John
> suggested not to remove rc80211-simple right now, as it's currently
> almost working for a lot of people. John, any suggestions?

Those people can fix the bitrate at 1M if the pid algorithm becomes
problematic, that's what simple currently does in practice.

johannes

--=-+Ay7h8SanTmoOl4lyF8T
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR2XMPKVg1VMiehFYAQJxZA/9E3vi2Nm+lo63jaLPFrZGi5e6JFl3w/Vu
4AzCdUJ0nu3HSSpSHHv80FfARzSbBOSpi0A5hzkvSPLe02bgtEwI+2TqWY5hhuIt
zHbauEyrIbcPFqtVkpUxQDEsveqp7MCUaZUywP7EQvwkzlbRU3j/yYWJICwq/Zoe
muM3LplK/eR9dH10GCD3/S1PFL6aC1xaHm4TfxF4Rkz2Wk6GgSFSLsr6Id50IjMf
LtLJca3OZfzAn3EGu/w4ddZ8G2bjJUp1j7a5zK5jzZv4QyOsK8r1JIaGzIphFaq1
EMi30Mr5xT7bed5tMVxusxhX0ILBn9RKSEeaeYMgYk0/qmjlUZrW0b6ddGt5JUIZ
TinbwZqLHZ13YIyn9OEjLKZgb3BEr9fYyYEKmDCw7m+sWi87Z0jVkLT2EwR/TdX0
yYIIIY1i4jkh1W319BAiT9GwmHGt+g7AB84KcsrGUYUputi4u8mQ33KvmrbHHkYW
FJ/RnCI7exoTv/n9g0cNv6/TAUefgj7A0RvGuC0ipT2dQksfco0mHUU73h+cr1rx
YEOL+uFxg9P41aSMmfDh1LY+4hxbZioEVS6k2+7J9bRlGwC3z7byLWZ6xLjWGEct
c6mWQQLeu4n4GNri9N1J95X1Mj28OQE/6+LepaM7LtVYN+aCt7nkEf0waPCjgK36
GwHGAsMnork=
=UTeR
-----END PGP SIGNATURE-----

--=-+Ay7h8SanTmoOl4lyF8T--

