Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:51734 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754931Ab3E0J27 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 May 2013 05:28:59 -0400
Message-ID: <1369646928.8229.24.camel@jlt4.sipsolutions.net> (sfid-20130527_112906_162152_1A664A4F)
Subject: pull-request: mac80211 2013-05-27
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 27 May 2013 11:28:48 +0200
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-poeYbXkkOxkf+9/jL6qG"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-poeYbXkkOxkf+9/jL6qG
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi John,

Another pull request for 3.10 with a number of fixes.

This time I have a fix from Stanislaw for a stupid mistake I made in the
auth/assoc timeout changes, a fix from Felix for 64-bit traffic counters
and one from Helmut for address mask handling in mac80211. I also have a
few fixes myself for four different crashes reported by a few people.

Please let me know if there are any issues.

johannes


The following changes since commit e248ad30204eff6559b4d2d94d49d9d46c08185a=
:

  cfg80211: fix sending WoWLAN TCP wakeup settings (2013-05-16 22:38:09 +02=
00)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git for-john

for you to fetch changes up to ac20976dcaeea3e77e40e9aac8f3799d2a22ea2b:

  mac80211: Allow single vif mac address change with addr_mask (2013-05-27 =
11:26:48 +0200)

----------------------------------------------------------------
Felix Fietkau (1):
      cfg80211: fix reporting 64-bit station info tx bytes

Helmut Schaa (1):
      mac80211: Allow single vif mac address change with addr_mask

Johannes Berg (4):
      cfg80211: check wdev->netdev in connection work
      mac80211: fix queue handling crash
      mac80211: assign AP_VLAN hw queues correctly
      mac80211: close AP_VLAN interfaces before unregistering all

Stanislaw Gruszka (1):
      mac80211: fix direct probe auth

 net/mac80211/iface.c   | 44 +++++++++++++++++++++++++++++++++++++-------
 net/mac80211/mlme.c    | 12 ++++++------
 net/wireless/nl80211.c |  2 +-
 net/wireless/sme.c     |  3 +++
 4 files changed, 47 insertions(+), 14 deletions(-)


--=-poeYbXkkOxkf+9/jL6qG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJRoydQAAoJEDBSmw7B7bqrBz4P+QFsMKcoKKd/s+XyG1FAG6o6
R9Xk1DXB1moFoZnBOu2+9TvMgrOXwX7Uduc1eWLgNy9bHzXoPJhiysgbgWyvil5y
Brz8R02GDg0V4R4rYIWfEGtNFQhsKYB+UhIQ7b+BkuGUZnqkrRx4qiGK3nYrRxZD
FTBCCyg0TNXmumMQBeRdmEU/1otVLe2GEb5Bz7vB/+iT+oZBbtqUg56tnav95P3t
9cbT1FO5vvF1jJxCtyMUZlxAZjaUHQzt4f/zrbHkwEn5+GBRJMOswmiakWMb8UaQ
agSPRRKPK2PkuFy+UZP4nxOxoAx6/L3JkPIGgd2/7isuEoFCVF5wwAYgIvf3VOrZ
uriMZ+YpMHM2VnZDqykpb5xKO5pCn3WiFY7zknAhffPBOgavDJXPp8DO3AVSEYdA
sGjR4kjhhIpf8a/2HITz4mgFB84JcEgRFsctq3CFWnF6SJOn6kyy3DNnlj22WzFi
aYHoYapvWpp4wH/y1sdTQnYqm/mQ9JyP94vz+A5JXmGws/kqOGS/b3OoCdZ4sk5e
ZhsUFF7IhOxY+yWU1ZWC486nv475/36etEZkl2F5E1p49Bpu8njumph8wbDSIm7l
vHjJnGllU93MtPL6A9LsXR9cROPgAk29hQTxRHpHaTjrvjeyN948Y4mkZiTuuURO
sc3mOtFAkhpEnbCbEewB
=zhCW
-----END PGP SIGNATURE-----

--=-poeYbXkkOxkf+9/jL6qG--

