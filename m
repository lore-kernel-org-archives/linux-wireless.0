Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:36536 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752577Ab3JIHLZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Oct 2013 03:11:25 -0400
Message-ID: <1381302673.14186.0.camel@jlt4.sipsolutions.net> (sfid-20131009_091128_721760_BCC70A8D)
Subject: pull-request: mac80211 2013-10-09
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 09 Oct 2013 09:11:13 +0200
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-5+y2rmvHyz0ZzaBIZPY9"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-5+y2rmvHyz0ZzaBIZPY9
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

John,

Another pull request for mac80211 fixes ...

Jouni fixes a remain-on-channel vs. scan bug, and Felix fixes client TX
probing on VLANs.

Let me know if there's any problem.

johannes

The following changes since commit aa5f66d5a1df1c2b04bccdcb19711675c765d7c4=
:

  cfg80211: fix sysfs registration race (2013-09-26 20:03:45 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git for-john

for you to fetch changes up to 22c4ceed0184318ec5a6182c6d75d398452c2e39:

  mac80211: Run deferred scan if last roc_list item is not started (2013-09=
-30 12:36:56 +0200)

----------------------------------------------------------------
Felix Fietkau (2):
      mac80211: use sta_info_get_bss() for nl80211 tx and client probing
      mac80211: update sta->last_rx on acked tx frames

Jouni Malinen (1):
      mac80211: Run deferred scan if last roc_list item is not started

 net/mac80211/cfg.c        | 2 +-
 net/mac80211/offchannel.c | 2 ++
 net/mac80211/status.c     | 3 +++
 net/mac80211/tx.c         | 3 ++-
 4 files changed, 8 insertions(+), 2 deletions(-)


--=-5+y2rmvHyz0ZzaBIZPY9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJSVQGRAAoJEDBSmw7B7bqr/BMP/0L8NTG/jtrR7Q2g1EHZ6ZhH
1BC7uITHdseXbD3TG0J+V8e1QTGn9uDxTKmy6Vu8K1BBeTCsscGlbLNUm8ofI5XE
XYr1F/+0MgIKFYmH3HIi82+LWLeCAIBWEOTodjcuUnyyHGqOP6Lw7ULxBNVX6IUW
+PobpDBcYvld3g9dhmVZyjBpMJ2jFczaH63VJUWwMhETD+94zcmtMA5qhHtNIpTE
iM8RG2iHkW8BkA2T6eAFv1KCO1eYzwSF7tInsoafRedqtSC3BCfqeO9fF5gN8a5/
xvVPtqlgeJoZankwyfscqAJCTZf51ZegO8S7x5ZTSDIj9M8bp915SX0BLhRZvMsg
c82E3KtfYijmuC6FDpXSm7ZIabtBk1Td7DxvYSZAZPU6+c+BAx9P0LwOw+OgILdP
KY2BKQV9bydrztcGSKVyDABtjD02EB0LwmCLEcZeHn3vuPR3MVcSD5ATRglnojk1
CCcr319rotkm9zcD6cZys+wUdVzI9Em3ytrHu/E968odrKGn1f9As5f7K3fDqQrl
csku/9c/2aSVkGat5m1MCqtQAZkdwoyk8TW4ZZ5oBqc9XXFxkzkVilh4hou3bPA0
HaOnRGAeqO0wm69KtGQyKk5wgx2odhsqCqP5Lg8jMKrTD/MC0SR8YtbTnaRKxIRL
30u8LkKfuZZgLDXvjHnE
=0mUw
-----END PGP SIGNATURE-----

--=-5+y2rmvHyz0ZzaBIZPY9--

