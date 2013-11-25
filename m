Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:39148 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754380Ab3KYTrS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Nov 2013 14:47:18 -0500
Message-ID: <1385408827.4443.61.camel@jlt4.sipsolutions.net> (sfid-20131125_204725_025839_00015B80)
Subject: pull-request: mac80211 2013-11-25
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Mon, 25 Nov 2013 20:47:07 +0100
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-wrN6/J0KJgOBtSXSWTbZ"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-wrN6/J0KJgOBtSXSWTbZ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

John,

First pull request from me - it took me a while to get my trees in
order.

For now I have various fixes all over, mostly for issues introduced in
relatively recent patches. There's no real pattern to it. Some of the
issues like go back longer, but still seemed 3.13 material.

Let me know if there's any problem.

johannes

The following changes since commit 91398a0992c8aa18eb7749060b75761ece5ddc57=
:

  genetlink: fix genl_set_err() group ID (2013-11-21 13:09:43 -0500)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git for-john

for you to fetch changes up to 24d47300d118c5909a51b7270276d749cce150a2:

  mac80211: set hw initial idle state (2013-11-25 16:56:54 +0100)

----------------------------------------------------------------
Bob Copeland (1):
      Revert "mac80211: allow disable power save in mesh"

Chun-Yeow Yeoh (1):
      mac80211: fix the mesh channel switch support

Eliad Peller (1):
      mac80211: fix connection polling

Felix Fietkau (2):
      mac80211: fix crash when using AP VLAN interfaces
      cfg80211: ignore supported rates for nonexistant bands on scan

Janusz Dziedzic (1):
      mac80211: DFS setup chandef for radar_event correctly

Javier Lopez (1):
      mac80211: fix for mesh beacon update on powersave

Johannes Berg (6):
      mac80211: fix scheduled scan rtnl deadlock
      nl80211: check nla_put_* return values
      nl80211: fix error path in nl80211_get_key()
      nl80211: check nla_nest_start() return value
      cfg80211: disable 5/10 MHz support for all drivers
      mac80211: don't attempt to reorder multicast frames

Jouni Malinen (2):
      mac80211_hwsim: Fix radiotap header for ACK frames
      mac80211_hwsim: Fix bcn_en_iter to use atomic iteration

Karl Beldan (3):
      mac80211: minstrel_ht: fix rates selection
      mac80211: use capped prob when computing throughputs
      mac80211: set hw initial idle state

Simon Wunderlich (1):
      cfg80211: fix ibss wext chandef creation

 drivers/net/wireless/mac80211_hwsim.c | 16 +++++++---
 net/mac80211/cfg.c                    | 15 ++++++---
 net/mac80211/ieee80211_i.h            |  1 +
 net/mac80211/iface.c                  |  1 -
 net/mac80211/main.c                   |  3 ++
 net/mac80211/mesh.c                   | 20 +++++++-----
 net/mac80211/mlme.c                   |  2 ++
 net/mac80211/rc80211_minstrel_ht.c    |  7 ++--
 net/mac80211/rx.c                     |  3 +-
 net/mac80211/scan.c                   |  2 +-
 net/mac80211/spectmgmt.c              |  2 ++
 net/mac80211/util.c                   | 11 ++-----
 net/wireless/core.c                   |  3 ++
 net/wireless/ibss.c                   | 18 +++++------
 net/wireless/nl80211.c                | 60 +++++++++++++++++++++----------=
----
 15 files changed, 101 insertions(+), 63 deletions(-)


--=-wrN6/J0KJgOBtSXSWTbZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJSk6k7AAoJEDBSmw7B7bqrV54QAJyIPN8J8dWoBWiq+qQyMc6C
9qj2D3wasnO59DW60zp+7iiUl3OXW9RM1ooPHJxBPVAZ/iwrTg7QwsoBAetu18HO
XpvDx9+VkKhRNQj6TtTOzEwoC9JAiF4Sv6+LioJtCNKIiTkraVD9yMK6s9GAo7bD
X68T84N4/p4chC7gEnU40e4vD0oty8UaO607QIJ+nzkUeeAQhr+glEGpIdg9nZm6
KDvLZYzbt6oXQrvjZ+jYphDamssWglYwbkQ3v+6H6VlpeMsfIP0WGeiObpj9FAS1
OwfjeWeruvwUvq/D2YC5FwSarAWxLmT3FduBLcbhSlbS/S6KKlTq8maEej6X+sPj
V/MsrWrwmtFE18QD4KWSvTWPY2m0OpN+YaE6h61aKPVkw31D1WUWGmPPfNpxy1jH
JBOibfCwjVnuKXaM5g/p2kOK9tzwBUeuT9LW7geLdlbBCbP6eTdFZJ3DQECIYFWR
w0HWu3P6URSF2dtd4PYKSDSuLuEnH9n8ZhOSQvAjArxJjqGLiqgNucPD2BVI9QR8
E6HCag7h3O/8+kz8IwIHKmfg/fTuAooJWe/IDfWYAJ2w8pkK2DxQUF83OacGHyu8
SbZuQh0GaD7puhbZNS8COEBurNpDY89iX1PNYZorDsnrSktOnRhrc44GtDmtTdbc
F8GiAt8sp9nACGg+9FOb
=0VqD
-----END PGP SIGNATURE-----

--=-wrN6/J0KJgOBtSXSWTbZ--

