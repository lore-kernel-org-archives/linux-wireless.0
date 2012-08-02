Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47952 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752533Ab2HBPba (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Aug 2012 11:31:30 -0400
Message-ID: <1343921481.4471.10.camel@jlt3.sipsolutions.net> (sfid-20120802_173133_643384_639F110D)
Subject: pull-request: mac80211 2012-08-02
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Thu, 02 Aug 2012 17:31:21 +0200
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-sdGOjlp0e7XZVV5Upo5X"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-sdGOjlp0e7XZVV5Upo5X
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

John,

Please pull these fixes for the 3.6 stream from my tree as below.
Included are a few fixes for various things I found doing code
inspection for my multi-channel work and a few fixes from others. I've
included Seth's patch for the non-OFDM flag that's a requirement for the
bcrmsmac locking fix so you can pick up that patch after you pull.

I'm going to be on vacation next week and the week after, and though I
won't be away from home for all the time, it'd be great if you could
pick up urgent fixes for mac80211/cfg80211 for the 3.6 stream until I
return.

Since the merge window hasn't even closed yet I'm not going to send a
pull request for my mac80211-next tree before I return, but it's there
and has a bunch of work in it. I'll send a preview out in a bit though.

johannes

------

The following changes since commit 9dbf5f55f8d35ff9aedc75267f4e4042aaf89755=
:

  bcma: add missing iounmap on error path (2012-07-26 15:37:57 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git for-john

for you to fetch changes up to 899852af60c212bfe9a2fb71d4d9082d2622df5c:

  cfg80211: Clear "beacon_found" on regulatory restore (2012-08-02 15:34:22=
 +0200)

----------------------------------------------------------------
Eliad Peller (1):
      mac80211: don't clear sched_scan_sdata on sched scan stop request

Johannes Berg (4):
      mac80211: fix scan_sdata assignment
      Merge remote-tracking branch 'wireless/master' into mac80211
      mac80211: clear timer bits when disconnecting
      mac80211: cancel mesh path timer

Paul Stewart (1):
      cfg80211: Clear "beacon_found" on regulatory restore

Seth Forshee (1):
      cfg80211: add channel flag to prohibit OFDM operation

Stanislaw Gruszka (1):
      wireless: reg: restore previous behaviour of chan->max_power calculat=
ions

 include/net/cfg80211.h |    2 ++
 net/mac80211/mesh.c    |    3 +++
 net/mac80211/mlme.c    |    2 ++
 net/mac80211/scan.c    |    3 +--
 net/wireless/reg.c     |   19 ++++++++++++++++++-
 5 files changed, 26 insertions(+), 3 deletions(-)


--=-sdGOjlp0e7XZVV5Upo5X
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJQGp1JAAoJEDBSmw7B7bqrei0P/228UUAAuivEchdq0Q0JD25q
CldjW69woLCBncOn+0fH9hoQnoeEpqhGBKmGXC2uHnmwADae3kjeW4WcXLcg4GwK
Let5/GadnnfWJ0zkxuu1e5ugfAIujejANrGvpwYosZra0xyk/uR4otQ0xcGsIuFr
5HbxRscYPCZhR+sTXTViaQI48BsEcbCriU1HGvbZeztcdCQvoU/WaE+dCrDFgtSi
547TPk2HFsKbsaSgcK9z16aFuBaz2G0IFVskuyJ4kFKVFZzt/y6SOjtal5vkmTow
sf7uVRQPoKse7Ob5shzSV8bifOvDhjggxoNttIiuQkeezFcWEQbGgl+COJDGMqQQ
vzOdVDN+kL4PSmoRlyT7UzBs0INh/9x/QGlF8HsUs9WtDUYk3bgFp1MOz7KAeUwi
Z/Afy6vbgJ4Z61e4MjJTsFjds87NBsO/sp/nOSf1LzjOXw8PsPxnghX15TY3lon2
TtvbxDHFFpiDuZrsELsZUHbJfXpEuX8TKcK13aTkAbSEOY+5Ixqut2Vm66LkdrNb
yPLqiwyzUKJS77JDhpWzaUWpRZx8ve1A+QOlRYo9jUotdUCUlBK9rWdFJOo4pgX8
Mkzi9OaDO/ccrc5cEdcXulsMIy5A7UDp5xT09Jau60VUEoSvmS4nZzytDD7CT95t
v+awY1DlbP3meef95IMM
=12cR
-----END PGP SIGNATURE-----

--=-sdGOjlp0e7XZVV5Upo5X--

