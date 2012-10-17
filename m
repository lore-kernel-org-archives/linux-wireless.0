Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46580 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756630Ab2JQLy4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Oct 2012 07:54:56 -0400
Message-ID: <1350474926.10728.17.camel@jlt4.sipsolutions.net> (sfid-20121017_135459_509718_716C8DEC)
Subject: pull-request: mac80211 2012-10-17
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Wed, 17 Oct 2012 13:55:26 +0200
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-uSd+X2NTkiktlhjP5l72"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-uSd+X2NTkiktlhjP5l72
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi John,

Please pull my mac80211.git tree (as below) to get three fixes for 3.7,
one from Stanislaw for a state mismatch between cfg80211 and mac80211
that causes crashes, one from Jouni to fix a bitmask in CCMP and one
from myself to disable HT40 if not permitted which ultimately fixes a
sysassert in iwlwifi.

Thanks,
johannes




The following changes since commit c3e7724b6bc2f25e46c38dbe68f09d71fafeafb8=
:

  mac80211: use ieee80211_free_txskb to fix possible skb leaks (2012-10-08 =
15:06:05 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git for-john

for you to fetch changes up to 3a40414f826a8f1096d9b94c4a53ef91b25ba28d:

  mac80211: connect with HT20 if HT40 is not permitted (2012-10-17 13:46:38=
 +0200)

----------------------------------------------------------------
Johannes Berg (2):
      Merge remote-tracking branch 'wireless/master' into mac80211
      mac80211: connect with HT20 if HT40 is not permitted

Jouni Malinen (1):
      mac80211: Fix FC masking in BIP AAD generation

Stanislaw Gruszka (1):
      cfg80211/mac80211: avoid state mishmash on deauth

 include/net/cfg80211.h |    1 +
 net/mac80211/mlme.c    |   35 +++++++++++++++++++++++------------
 net/mac80211/wpa.c     |   11 ++++++++---
 net/wireless/mlme.c    |   12 +++---------
 4 files changed, 35 insertions(+), 24 deletions(-)


--=-uSd+X2NTkiktlhjP5l72
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJQfpyuAAoJEDBSmw7B7bqrta8P/An9BfnrqIdia54R0RZuexMa
T9QFse8W4tZqoHP+FQpLjnxunqlSvbvY2hjc22npno+jY5bpbiMan96d2c4VhGnK
5yFaUewHjxTfAm6wU5mJgg45oOEDdDjHU9ze6xGUMst8paWOzyY7/wourHV7bBui
9MawtJGzkUblZSZVxPZQOv0pecStU4Jw0KPVKpb/h7Vls/FikdrqMG6hxE2agvOD
QnQ+XUSQWORNhsolwjMwdXYx3Ioc4iGcJyknOHfG0xiO/XMXpWK3RDECB2hJCrVQ
rYL8dFvHbEksrY7l45KyyNN2yZSxfotgeY5ajZmzXes86Xn5KFwwZBWTzNhX9+wM
1zZrS4nSygD1qErsvIEA9A8pPzJuVUoWPVhwz63tX/n9dDTo2XTuhFTXQcBesCwJ
b+ZEJy5lIhingPIMbhy3qr/soMbhlVMEqQl5n5IOsnQmWTWgafB3XmvD2ahNaLY1
wXguTP5yo3NAmegSsv+22jhGex6Vx65Cciro7jilWn1ycsDpPbOexCEM9P7pkrqg
IxKkLZ/VY1JgjjmeqCtW3cvO41F6GXmpE9VIZ6na3VnwKSB4IhCMVZTDP9jXptSi
3rdXdg8qcpEpr8z+2nUHE6++l1tCuydI447LP2Af20Oy9kauDhWA0D6OVArguMYr
bcs4iUXLtYqIO8bfqK5n
=Mft4
-----END PGP SIGNATURE-----

--=-uSd+X2NTkiktlhjP5l72--

