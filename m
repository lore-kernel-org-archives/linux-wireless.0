Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48214 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753444Ab3ACNuz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Jan 2013 08:50:55 -0500
Message-ID: <1357221075.9741.4.camel@jlt4.sipsolutions.net> (sfid-20130103_145058_755150_FBDF69D6)
Subject: pull-request: mac80211 2013-01-03
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 03 Jan 2013 14:51:15 +0100
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-8oN2HokJ9WzY+REE4h6t"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-8oN2HokJ9WzY+REE4h6t
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

John,

Please pull (per below). This includes a number of fixes for various
pieces of mac80211. I've also included Thomas's memory RMC hash table
optimisation since it saves so much memory.

Thanks,
Johannes



The following changes since commit a49f0d1ea3ec94fc7cf33a7c36a16343b74bd565=
:

  Linux 3.8-rc1 (2012-12-21 17:19:00 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git for-john

for you to fetch changes up to 09b1426e7fcec510aba55a761da5004e47a11ce3:

  mac80211: fix maximum MTU (2013-01-03 13:00:01 +0100)

----------------------------------------------------------------
Chaitanya (1):
      mac80211: fix maximum MTU

Felix Fietkau (1):
      mac80211: flush AP_VLAN stations when tearing down the BSS AP

Johannes Berg (4):
      mac80211: assign VLAN channel contexts
      mac80211: fix station destruction in AP/mesh modes
      mac80211: use del_timer_sync for final sta cleanup timer deletion
      mac80211: fix dtim_period in hidden SSID AP association

Stanislaw Gruszka (1):
      mac80211: fix ibss scanning

Thomas Pedersen (1):
      mac80211: RMC buckets are just list heads

 net/mac80211/cfg.c         |  2 ++
 net/mac80211/chan.c        | 38 +++++++++++++++++++++++
 net/mac80211/ibss.c        |  9 +++---
 net/mac80211/ieee80211_i.h | 16 +++++-----
 net/mac80211/iface.c       | 48 ++++++++++++++---------------
 net/mac80211/mesh.c        |  8 ++---
 net/mac80211/mesh.h        |  2 +-
 net/mac80211/mlme.c        | 75 +++++++++++++++++++++++++++++++++---------=
----
 net/mac80211/scan.c        | 46 ++++++++++++++--------------
 net/mac80211/sta_info.c    | 46 ++++++++++++++++++++++++----
 net/mac80211/sta_info.h    |  3 +-
 11 files changed, 202 insertions(+), 91 deletions(-)


--=-8oN2HokJ9WzY+REE4h6t
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJQ5YzTAAoJEDBSmw7B7bqra3AP/0D5OGd54ulEs/YljP02Znbj
pQUV6gG8kT7F5qDhCIgMw1prXoyySX9nNYwLRs+Fqip9aJ2KKhrVCNyBYsvfYNaA
iPEzxFg7F0jZSWLcP9RiV3Kw/si0Di2sk1NwqsTjb+ssLTZipy5fTOVhdmLSyQT8
dOn9sP6c1ntMn6aprBwQh5VPAA1h/v4BteL9b5h9J0OLYNdt3plcGbIDrgNOGAmZ
yKOlM8iu6lUfGBKOic3zugotijwysVC47KNH0qrhbNdK7h9NEV0eSbMLHs6Gyl6A
/TPXZP98hW+znA+enz+u3xDn/y1XMO/zCEKYWPVw22wDtsZJQw7fOBU8JRZId0H2
GhRhhpIUMW5Tv/ZJFUgdgaCL9GZeeoDkEOZ/ilBJAssZfXaecfCVfhVuB+ocNxWe
3TrobiLbjFqAPJ4EV+QX3+fIdghQLZSs0NSIw7Ch15tgRDJ31BpJsSs9e/ffWleR
9LSQ3X6jX4rEa+Sh2fEvGgllgt2gr1th1K6ctOG0ZZ60l+lecbn/MP/mpGG48SOe
/ygKCIxKWwDTEbA5mjscU+Yi34C6XQ5b3up73Yxadecz61VivvMO7t1FS2UxGXBU
A44WJoamXZOqOiyW5TB4HC4jchLvdctRw3hDYcqKo3TVtjFfq/w6TdJ6vbJ0LQ/B
y8nNcWpTuOLVFYRw9aD+
=uvXe
-----END PGP SIGNATURE-----

--=-8oN2HokJ9WzY+REE4h6t--

