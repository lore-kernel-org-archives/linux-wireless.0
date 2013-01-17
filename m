Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:57026 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869Ab3AQWJN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Jan 2013 17:09:13 -0500
Message-ID: <1358460572.4653.7.camel@jlt4.sipsolutions.net> (sfid-20130117_230915_527234_2CE1EB85)
Subject: pull-request: mac80211 2013-01-17
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 17 Jan 2013 23:09:32 +0100
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-FHk0eoZ+6vd57WhaSmC2"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-FHk0eoZ+6vd57WhaSmC2
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

John,

Please pull my mac80211 tree.=20

I have a few small fixes for you:
 * some mesh frames would cause encryption warnings -- fixes from Bob
 * scanning would pretty much break an association if we transmitted
   anything to the AP while scanning -- fix from Stanislaw
 * mode injection was broken by channel contexts -- fix from Felix
 * FT roaming was broken: hardware crypto would get disabled by it

Let me know if there are any problems.

Thanks,
johannes


The following changes since commit 09b1426e7fcec510aba55a761da5004e47a11ce3=
:

  mac80211: fix maximum MTU (2013-01-03 13:00:01 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git for-john

for you to fetch changes up to 8680451f38a64bd270233b3c0eeb7c45f2b5efe3:

  mac80211: add encrypt headroom to PERR frames (2013-01-16 23:24:51 +0100)

----------------------------------------------------------------
Bob Copeland (2):
      mac80211: set NEED_TXPROCESSING for PERR frames
      mac80211: add encrypt headroom to PERR frames

Felix Fietkau (1):
      mac80211: fix monitor mode injection

Johannes Berg (1):
      mac80211: fix FT roaming

Stanislaw Gruszka (1):
      mac80211: synchronize scan off/on-channel and PS states

 net/mac80211/cfg.c         | 12 +++++++++++-
 net/mac80211/ieee80211_i.h |  6 ++----
 net/mac80211/mesh_hwmp.c   |  5 ++++-
 net/mac80211/offchannel.c  | 19 +++++++------------
 net/mac80211/scan.c        | 15 +++++----------
 net/mac80211/tx.c          |  9 ++++++---
 6 files changed, 35 insertions(+), 31 deletions(-)


--=-FHk0eoZ+6vd57WhaSmC2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJQ+HacAAoJEDBSmw7B7bqrFzQP/3tuCOaBsrAhfetDzdx96pKu
eFTyF1HC6je/FgqK43Lcmso0mrBrARDZtEKvDxN+AxtzftH7XtFaJLWAnDmGKtf6
Ok2m5iK7Rkhxp/hBrwpjFOZ7KgywnBURoYQbp8lE+Yygds06x9clRFFLiaZleKyk
QDZ8LRCqn1zngBDv0MrmGzF45UcYfBueDuxKhSWxK1BYAkezlHL0hGSfRDl/7XcG
gDO0oGDaz+LBcn48JOgjvRypPAVhgdac4whmP+XVRiVbcnq9HlCgdfLLwnMNy3Cl
8bNVNWp0u065HhsbLVv0l+9AKd9XdsU2TcgvrS5sut7uYlkwNi3JP5biDNOvCTrV
sBlIhlp508NuJLVpRwp54yo30I1PkzXFblPJJ54c5uID5mZ+mY0nMCMc1anuIKHt
Ye2zIUNS3TZHVFBagwyPuZ1yDxFXXof7JbKtcU/uEvbiQOl99LX7pb3mGQWNdLeN
PkxwrfqEsaW3pc37wglfWAk0KmTMlSObmnos3Ed5FQwkQYOV24c8cLhxh+oxtdqh
aro1LxU8w1GwcRNKlPikum//q4L5LUsd5CXj9az6Wu11MQqA9IlixjJyqdLw7f5M
jKyVqwi+tSQ5abi0TBaUI5VM2lh4w5ImUSb3PAIsJB9ja+j1c9DQSSChFzZl/mf9
L7p4p9FA+Nf9eTrfKXdU
=XC/g
-----END PGP SIGNATURE-----

--=-FHk0eoZ+6vd57WhaSmC2--

