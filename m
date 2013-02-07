Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56526 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754896Ab3BGUBV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Feb 2013 15:01:21 -0500
Message-ID: <1360267300.8038.13.camel@jlt4.sipsolutions.net> (sfid-20130207_210125_019256_B62FB536)
Subject: pull-request: mac80211 2013-02-07
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 07 Feb 2013 21:01:40 +0100
In-Reply-To: <1360168561.7910.24.camel@jlt4.sipsolutions.net> (sfid-20130206_173555_899354_0EC3DE1D)
References: <1360168561.7910.24.camel@jlt4.sipsolutions.net>
	 (sfid-20130206_173555_899354_0EC3DE1D)
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-Rnu1Cydz7Z7CGP5wbtXQ"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Rnu1Cydz7Z7CGP5wbtXQ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

John,

Just found another last minute fix for something I very stupidly broke
in my VHT work ... it only affects incompatible multi-vif so it's quite
unlikely, but still very dumb. *headdesk*.

As before of course I have the fix from Cong Ding for the bad sizeof()
which Stephen Hemminger had pointed it out at the end of December.

johannes

The following changes since commit c49dc9008b1c641a86837297df7c90cef070571b=
:

  cfg80211: off by one in ieee80211_bss() (2013-01-24 15:47:22 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git for-john

for you to fetch changes up to d601cd8d950c85032cefdcda162b8cd2cda363bb:

  mac80211: fix managed mode channel context use (2013-02-07 20:56:01 +0100=
)

----------------------------------------------------------------
Cong Ding (1):
      mac80211: fix error in sizeof() usage

Johannes Berg (1):
      mac80211: fix managed mode channel context use

 net/mac80211/cfg.c  | 3 ++-
 net/mac80211/mlme.c | 5 ++++-
 2 files changed, 6 insertions(+), 2 deletions(-)


--=-Rnu1Cydz7Z7CGP5wbtXQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJRFAgkAAoJEDBSmw7B7bqrK+EP/j5N/x8re6pdbimivggbvc5N
YdxeYCA16hc/v517TE31Bw0gaE0pHv/iffET17b03By7UIiT05j4579DnCZrkeh9
0j/8uJOBeGKcl4nVb7vb38CRFWnfHInbYpqX+/4jTd69Q2LsACRDAXRr7x2q/IqY
zsqIhiOcECXLw4S0FlBBtAoTkv02RzdevpeFzRNCkj1RLG/Ll409fXuzc3+UtP7O
mpDVNW1A8krP0DhCbqk5G4aQrznZqPe1JNOrJ2+zJSuIEiPYhKIVGvz5OFn9+eJk
nLZOo9JW5tkphiY2vkkktZc7cmhXuCAeBL/Y5JGw35Rm0XF2BmbEqUpqEg3RX+pl
YHOgfLHLdbnOdn1SztPUa5pd/qBwoGr04CO899zvw7dlqHifJ6x28cw43yLH/oQa
zMromhuyd4wkZ6Zu8fy5U4oGlp3IHsbzW4TBJS1t8mchWd4zU3uFhjcI8XTvdds/
Yd2w6EpvoQ7qkA5NTRxwE1YalbhD46U95znNjmQElC9rGyD9gvUhFjp9S97yWhj9
nslMAOHc+ekeNAZWjxhC7MGxhKJJEjxBNk6dxBdkAn5VyWpR7eAs2obOUcCfnsX5
gmynMYFTpyz0Vs+Hhfj1LvGcxbe3kNn198XuUh2Z3cWS8WqfOIUqJknRqDMS6PMM
S5dsPe9q3/dKeHKF+GKv
=t9CJ
-----END PGP SIGNATURE-----

--=-Rnu1Cydz7Z7CGP5wbtXQ--

