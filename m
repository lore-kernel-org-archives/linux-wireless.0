Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54661 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752689Ab2KITmM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Nov 2012 14:42:12 -0500
Message-ID: <1352490162.9238.23.camel@jlt4.sipsolutions.net> (sfid-20121109_204215_951530_427D6D95)
Subject: pull-request: mac80211 2012-11-09
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 09 Nov 2012 20:42:42 +0100
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-tHWLbC+kbM8idJUQX7R3"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-tHWLbC+kbM8idJUQX7R3
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

John,

Here are five more fixes from me for 3.7. There's no theme to them, just
various changes all over mac80211, see the commit logs for more
information.

Please pull, information below.

johannes


The following changes since commit 6dbda2d00d466225f9db1dc695ff852443f28832=
:

  mac80211: make sure data is accessible in EAPOL check (2012-10-26 22:52:4=
2 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git for-john

for you to fetch changes up to 20f544eea03db4b498942558b882d463ce575c3e:

  mac80211: don't send null data packet when not associated (2012-11-09 17:=
31:47 +0100)

----------------------------------------------------------------
Arik Nemtsov (1):
      mac80211: sync acccess to tx_filtered/ps_tx_buf queues

David Spinadel (1):
      mac80211: init sched_scan_ies

Felix Fietkau (1):
      mac80211: do not call ieee80211_configure_filter if no interfaces are=
 up

Johannes Berg (2):
      mac80211: fix memory leak in device registration error path
      mac80211: don't send null data packet when not associated

 net/mac80211/cfg.c      | 3 +++
 net/mac80211/main.c     | 6 ++++--
 net/mac80211/scan.c     | 2 +-
 net/mac80211/sta_info.c | 5 +++++
 net/mac80211/util.c     | 2 ++
 5 files changed, 15 insertions(+), 3 deletions(-)


--=-tHWLbC+kbM8idJUQX7R3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJQnVyyAAoJEDBSmw7B7bqrhgIP/R6+HcVppqWOk+GPcyly+hrS
NxpKo6P/KJCTGpDXHzK+wAby+JUHn2DoTW0WbN2YRqMA32QAks0zv3rzFnnfPVeP
skR81Gm24zx7+TMJlMupRMZqvzXjIcGSr7hP24XnqlBQ3/xSYDT8bLsspFuz+ue0
LvRsDNpYd12nEEy87x1wXaxO9AX4X3SmDwX84L8AFh8nayIRKauFZ4DzSAgfDesE
eCpQgxKUyJrDahgyqvGVGFvHiPMmn2pkTrCu6TMbwhYEZAEVxhAtM9G1TFRrIJ8f
y65yVZpovpN5Pchz9/7tsA9DhpDMhFv6Sv/whIfI9Nr7QiPLECdBCJbfxkMyiBlp
IRRQ3r03hjp8DcuOM3PiDxS+eC/fa7nvspJ35sXzrPZBNRDyVmc+7OVXV1wqla/Q
vq0yW7ntZiS1rCwE6QtQ4muJh3D5YKzWanT4wdCayjL+V3b4ejsvUem+Qe/0KJM1
h04Sg5gArZVux43gT8srBNdCDFXyLz9L3CMtpmYsO9FomiprZvjnlv0+f4VCOQ5o
OQcXJxhIeqFKPUOD0YvHznqAnzfZe0b89kIByDZIyWCJE3X6bE/EVumxEcxdKrNf
Sz8XZIrdxofqdCdIAfWMar8mFbzAuKeCyU5JwlY95IDDy9zBbvGwng6YRE4vgQI7
Pu/6TEYUu3O3sY8YeLg0
=ZM2f
-----END PGP SIGNATURE-----

--=-tHWLbC+kbM8idJUQX7R3--

