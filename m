Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:50825 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753107AbaDKIJN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Apr 2014 04:09:13 -0400
Message-ID: <1397203735.4420.10.camel@jlt4.sipsolutions.net> (sfid-20140411_100924_226758_1FD5B469)
Subject: pull-request: mac80211 2014-04-11
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Fri, 11 Apr 2014 10:08:55 +0200
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-gXgw9TVnbl7cFgmp+xoL"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-gXgw9TVnbl7cFgmp+xoL
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi John,

First few fixes ... nothing big though.

We have a fix from Chun-Yeow to not look at management frame bitrates
that are typically really low, two fixes from Felix for AP_VLAN
interfaces, a fix from Ido to disable SMPS settings when a monitor
interface is enabled, a radar detection fix from Micha=C5=82 and a fix from
myself for a very old remain-on-channel bug.

Let me know if there's any problem.

johannes


The following changes since commit ce7613db2d8d4d5af2587ab5d7090055c4562201=
:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net (2014-04-08=
 12:41:23 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git for-john

for you to fetch changes up to 764152ff66f4a8be1f9d7981e542ffdaa5bd7aff:

  mac80211: exclude AP_VLAN interfaces from tx power calculation (2014-04-1=
1 09:37:41 +0200)

----------------------------------------------------------------
Chun-Yeow Yeoh (1):
      mac80211: update last_tx_rate only for data frame

Felix Fietkau (2):
      mac80211: suppress BSS info change notifications for AP_VLAN
      mac80211: exclude AP_VLAN interfaces from tx power calculation

Ido Yariv (1):
      mac80211: Disable SMPS for the monitor interface

Johannes Berg (1):
      mac80211: fix software remain-on-channel implementation

Michal Kazior (1):
      mac80211: fix radar_enabled propagation

 net/mac80211/chan.c       | 11 +++++++++--
 net/mac80211/main.c       |  4 +++-
 net/mac80211/offchannel.c |  1 +
 net/mac80211/status.c     |  1 +
 4 files changed, 14 insertions(+), 3 deletions(-)


--=-gXgw9TVnbl7cFgmp+xoL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJTR6MXAAoJEDBSmw7B7bqrIdUP/jx0BmbJmpurz0codei3wqix
LKyhmrXzBIQ5V4aNZovi51gWx7JcahRy45RzbCQVFoQk3RhvmSyCxd5bHFVOoGsS
muUfnW0z9/C97vfSdD75L3LAME6CsVLkYTp6mZqS+xhwsCZTkEqXLnIiZQz/v5LK
O3zr3+ra09YigDlCa3SHr8DXW8rE5UtXCXyC1wf3OCdkvgrKEVwOrFe0u2ExidRi
sZuGiUqdNhc1o/Wd45KhuSP1UnzTKxcdWOu8ceSRssum9ZT4N6Zb79VzllDEdqZM
NlEMUofJZkqle/hsouN7UpaD0Bf09GRS3mShtxH7WYrTvxBPjGc7quz0JS4Vmpyi
uWtON1FNeYUBramNhsDEkjOhhkCbizQ+31Mp45g379E6PYsb8dSayEQlmiXb9PlW
P4fbm0sq0RpvoVOkzR8HQdoGI5Y7v+see3AUECK0WQie2ggfU5uzNRU23Ej6yG9Q
2hmROzjYLKxcaQSSA9srhuAy2zhmedH7dw6NXij5NZQR5NEAzjJnMqDnmmtLQ9vT
AdvOYeU2lmg1K551F1aM5kDtJcR9KrQ5F1rR8ySHYUwTOrvbB0dPOsDDgTpHsQr9
ZUHxbvyQpuoq8mL073GatfesoEfzv7hsgiE/YvGJNu6ihldOsq1xEhAluAXH4+ku
t7jEBAxplRaDI6GHo97M
=H2X8
-----END PGP SIGNATURE-----

--=-gXgw9TVnbl7cFgmp+xoL--

