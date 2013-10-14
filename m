Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:57825 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753186Ab3JNHvT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Oct 2013 03:51:19 -0400
Message-ID: <1381736981.13092.4.camel@jlt4.sipsolutions.net> (sfid-20131014_095122_449124_D157F3B8)
Subject: pull-request: mac80211 2013-10-14
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: multipart/signed; micalg="pgp-sha256"; protocol="application/pgp-signature"; boundary="=-WgJottQPnmSbhr+B+HBE"
Date: Mon, 14 Oct 2013 09:49:45 +0200
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-WgJottQPnmSbhr+B+HBE
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

John,

I know it's getting later in the game (rc5 is out) and my last pull
request hasn't even made it into Linus's tree, but we still have some
fixes ...

This time I have two fixes from Emmanuel for RF-kill issues, and fixed
two issues reported by Evan Huus and Thomas Lindroth respectively.

Let me know if there's any problem.

johannes

The following changes since commit 22c4ceed0184318ec5a6182c6d75d398452c2e39=
:

  mac80211: Run deferred scan if last roc_list item is not started (2013-09=
-30 12:36:56 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git for-john

for you to fetch changes up to d86aa4f8ca58898ec6a94c0635da20b948171ed7:

  mac80211: fix crash if bitrate calculation goes wrong (2013-10-14 09:47:0=
8 +0200)

----------------------------------------------------------------
Emmanuel Grumbach (2):
      mac80211: correctly close cancelled scans
      cfg80211: don't add p2p device while in RFKILL

Johannes Berg (2):
      wireless: radiotap: fix parsing buffer overrun
      mac80211: fix crash if bitrate calculation goes wrong

 net/mac80211/ieee80211_i.h |  3 +++
 net/mac80211/scan.c        | 19 +++++++++++++++++++
 net/mac80211/util.c        |  4 ++++
 net/wireless/core.c        |  2 --
 net/wireless/core.h        |  3 +++
 net/wireless/radiotap.c    |  7 ++++++-
 6 files changed, 35 insertions(+), 3 deletions(-)


--=-WgJottQPnmSbhr+B+HBE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJSW6IVAAoJEDBSmw7B7bqr9HsQAIxBRswUx129K4ZFgsJfYowb
aUaaPb6mLyn0aj9GLIK4Pgu9V/qjaXmrtn3ma3rII3pvahSJo0UIPNIpu1u5hKZV
nPNr3CxJvAlsQucBlvS9/ORtzuj4dXLnFBzRKiTqYVC8E/Je5IevSmTAfs25cGCq
WqMZ9anfrs9m5+W82VsbkB0cVAV5zV5yigYsLXqt7XLioj3DJTjG+HQoEMXZnjvb
IETJ48kPXUxYY1TzKYd5Gt9QICkJ4JlcmFQFELZkiok33qm+CP38EeFvsQ8nkGUH
lyUOWzevKNEg+u734Tl4ezVTgoc8ARGDYjM97i3DQlRtbQInAdj8HtArn4IrLsUX
8/KfVDV/uFWgO92fUjJqpfjuWiYgTl1QI7tHQtmtJBNU1D5Qp9uisL798JFxNVbJ
LXdwGGubcRiahCfQ69AFfDlB97vakjsa/cRFnWh58q3PwNeO2z9WHCrWqO1lMqdr
ACzKNlY8jePmcpSshg6qlwgAcZBB0zibkfZSRzzBhk2fU80rIKpYpzc6lyNACZ7t
UaWy6VnsqHLlsRuGhWWEmFRVZnpR5RQfnhn/lhZqtrkdkvIeZIan5nVSR6LF4OXZ
gGuN94l9++sC59WAcwnDUXvfIFHYWmqHW1kI/rzSf+dT1L4kEqHKFuVZLVzXKLZp
CuHHjudR6Q+LkG70ypxC
=H1Js
-----END PGP SIGNATURE-----

--=-WgJottQPnmSbhr+B+HBE--

