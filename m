Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:59314 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759947AbYAKV2T (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Jan 2008 16:28:19 -0500
Subject: Re: [RFC PATCH 06/10] mac80211: A-MPDU Tx adding qdisc support
From: Johannes Berg <johannes@sipsolutions.net>
To: Ron Rindjunsky <ron.rindjunsky@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com, yi.zhu@intel.com
In-Reply-To: <11999857503421-git-send-email-ron.rindjunsky@intel.com>
References: <11999857423156-git-send-email-ron.rindjunsky@intel.com>
	 <11999857503421-git-send-email-ron.rindjunsky@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-MSI2no1wXX4lEq78XT3R"
Date: Fri, 11 Jan 2008 17:55:23 +0100
Message-Id: <1200070523.3861.206.camel@johannes.berg> (sfid-20080111_212823_291439_C4D318BF)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-MSI2no1wXX4lEq78XT3R
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Thu, 2008-01-10 at 19:22 +0200, Ron Rindjunsky wrote:
> This patch allows qdisc support in A-MPDU Tx. This is not a complete
> solution, but a general direction to handle QoS <-> TID switches

Ok, I'll have to think a lot more about this, my train is about to
arrive :)

johannes

--=-MSI2no1wXX4lEq78XT3R
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR4efeqVg1VMiehFYAQJF1A/+MeJf3SSZ7ZFck/quki82+pmyrhT4Q32p
EY+Ywv5meHAPw6RkGgG5oF0PPduSXPg4IAozrroh9JRD0RU0EILQa55Fmh0g8J72
9pR9ZI1EhyyD9ZiQFzvi1aJyIYKAXnAEpT2CarkCTcw7viXtWZ39qAnACEfR+x+4
6czc+WR86cgTmtN3LI1OqLRMSOl62oBOuvgCZgASh46v9qSRzktyYxgDGS/uUfls
GYISLgzHPnbo2M+9QJoN7ikrvpf1Jlm4Zv2meT9ID8rQG85pc69xWiXgVRkHL15p
Ilyc0U7lpdioW+1KWfCDS0kAWfJfF3E1MTapC7Ek4Kvr1UeDbjUnccJBEt3qOjL3
fTDr7qtaxYmGvxA3vwCyIGJn4BiLrGGPwsELQ4pVPe0p0mOYKBxO9QsHa4AZO/TZ
5oTP3hVKQCpoIqXUyezwjfh5q7hk49WYzC32IMFNHR+0KzaB1a16eh87NBKnLh0d
KLD1NkTiPBHsqOMzQ+D2dv9TZzSh00HxeJIolMDEh24RMcR4hFPgFEcSZrNtihkk
XM1XbodJMWvTaEpf8VVIsL8ynWY0OT8f1V2afzGeGgYtnerBFir1jOyVIeF4mPPy
MhZxGeuAQzp7kOyt3KT0HtChdo4CA+vOh57STCoQ4fOkz0nqOcWrUfw/KQdzx6VU
NJx8ZEoWFGA=
=sLEd
-----END PGP SIGNATURE-----

--=-MSI2no1wXX4lEq78XT3R--

