Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40061 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754739Ab3CST5u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Mar 2013 15:57:50 -0400
Message-ID: <1363723052.8336.6.camel@jlt4.sipsolutions.net> (sfid-20130319_205755_751711_D4ADDEEC)
Subject: pull-request: mac80211 2013-03-19
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 19 Mar 2013 20:57:32 +0100
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-Hp7gGXktainnYCuBZEoR"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Hp7gGXktainnYCuBZEoR
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi John,

Coming back after a week of many meetings, I have a set of fixes for the
3.9 series.

I have two tracing fixes (one from Vladimir), two fixes for P2P device
crashes and a fix for a BSS memory leak/lost update problem.

Let me know if there's any problem.

johannes


The following changes since commit 801d929ca7d935ee199fd61d8ef914f51e892270=
:

  mac80211: another fix for idle handling in monitor mode (2013-03-02 21:24=
:42 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git for-john

for you to fetch changes up to c831bbaef890c0c739f9409f4a2cccb126da7e7a:

  cfg80211: fix wdev tracing crash (2013-03-19 20:26:57 +0100)

----------------------------------------------------------------
Johannes Berg (5):
      mac80211: always synchronize_net() during station removal
      cfg80211: fix potential BSS memory leak and update
      mac80211: fix crash with P2P Device returning action frames
      cfg80211: always check for scan end on P2P device
      cfg80211: fix wdev tracing crash

Vladimir Kondratiev (1):
      cfg80211: fix inconsistency in trace for rdev_set_mac_acl

 net/mac80211/rx.c       | 14 +++++++++++++-
 net/mac80211/sta_info.c | 12 ++++++++++--
 net/wireless/core.c     | 49 +++++++++++++++++++++++++++++++++++++--------=
----
 net/wireless/core.h     |  3 +++
 net/wireless/nl80211.c  | 17 ++---------------
 net/wireless/scan.c     | 22 ++++++++++++++--------
 net/wireless/trace.h    |  5 +++--
 7 files changed, 82 insertions(+), 40 deletions(-)


--=-Hp7gGXktainnYCuBZEoR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJRSMMsAAoJEDBSmw7B7bqrrmAP/jQUjx6yWyhTNrR16eV6wNeF
ZSnZFUSMY6oD8w/FZWJqEnc9Bby0PBtZYynIxOHZeT28wSDN8SUYx7w5NFS0jEQB
zBQbwx56lkB2E2xBI0DzqC/KPSGep8xz35zoP7+hkjELKBORY4qSyYHxyIyWVdHj
UW3CjZGAsJ8E7+VRKQTpxhpri4kgydhATP30YpBWHRPXilSY10OZg8V/5OQaIkPA
b2Ns4M7MLof+EY6uYPtORYBqU7F52xZFmAErk1UZqV8WcN6VaH9UM7v/tjLaW890
FUTOrS5DK/wPTizD9Hogkwc9fzvJIHUnP9aln8MItMZQ1TNRkDBbg2dB57ToyPji
uCX1L62zZPLme3yqPjpkEP9Tmlf3wojoqu2qFhnvhjKTx50MqbmOVQkvammsmFZs
kUPaamEuZE/g/GwDkLAAJJKRLF9cFks8dLO/+nXHI+YwT1VUWUVElJor8lZtid7e
6CgNCIYMc8LHE5qkFaRj06zMyS3PJ/CyqNDfKUrhNRIA5bHIn69ImZPeiZnqW/kc
+Yp/RzyAlh3PC/IRcz0/lwxd6EoIJUAHJgBy+Lm0L6mJlj/bOw+vtBf3sZ40Ks7Z
HNSs1EgHTXar3MlP5FWJnKAsn2FRIIrir0VjTpIEm27npix3y5nIVWSsGrH4Ofyg
VC76O3yOHP70lE8xXkQA
=GXXC
-----END PGP SIGNATURE-----

--=-Hp7gGXktainnYCuBZEoR--

