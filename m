Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:59252 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751963Ab3HUNod (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Aug 2013 09:44:33 -0400
Message-ID: <1377092661.15268.13.camel@jlt4.sipsolutions.net> (sfid-20130821_154449_261497_45B7E261)
Subject: pull-request: mac80211 2013-08-21
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 21 Aug 2013 15:44:21 +0200
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-j60f5tLzX2bIHVg2FjQx"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-j60f5tLzX2bIHVg2FjQx
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

John,

I have three more patches for the 3.11 stream: Felix's fix for the
fairly visible brcmsmac crash, a fix from Simon for an IBSS join bug I
found and a fix for a channel context bug in IBSS I'd introduced.

Let me know if there's any problem.

Thanks,
johannes

The following changes since commit dee8a9732e713480075adbbca8eb220c5b8d1216=
:

  cfg80211: don't request disconnect if not connected (2013-08-14 14:00:19 =
+0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git for-john

for you to fetch changes up to 75a423f493ffdf741acae27bf179cd560f7813d7:

  mac80211: ibss: fix ignored channel parameter (2013-08-21 15:33:08 +0200)

----------------------------------------------------------------
Felix Fietkau (1):
      mac80211: add a flag to indicate CCK support for HT clients

Johannes Berg (1):
      mac80211: add missing channel context release

Simon Wunderlich (1):
      mac80211: ibss: fix ignored channel parameter

 drivers/net/wireless/ath/ath9k/init.c    |  3 ++-
 drivers/net/wireless/ath/carl9170/main.c |  3 ++-
 drivers/net/wireless/rt2x00/rt2800lib.c  |  3 ++-
 include/net/mac80211.h                   |  1 +
 net/mac80211/ibss.c                      | 34 ++++++++++++++++++++++++++++=
----
 net/mac80211/rc80211_minstrel_ht.c       |  3 +++
 6 files changed, 40 insertions(+), 7 deletions(-)


--=-j60f5tLzX2bIHVg2FjQx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJSFMQ1AAoJEDBSmw7B7bqrn+MP/R2jsPoiqSqAOowG7fGov5uB
4anRzCMfShTAFvtrNn/o5V93nhpB9wI44pomT9Ep0FeT+4IKb9GobS8L/vNtCgIz
ixKkh8LWUwBIK1IDuQSO9E3F/8n4shOlPrayIC7DTLA/vwpBGJtsJ/Z97OsfGo2/
yAJDPr14cOLm/OOPqOPH3jPt3hkf/NbV0L95DxT3mzAYU3VD0mxnaeTDIxvK3Gi1
wd0opGPhthUjGTYBreAdeM4CAPdExqCHKy6goRJQtqA0jTwr9vB8j/VeERX/B7EQ
GzVMa4Mgxd1NFKfLfNqJhl5wu/25uKzBFAn4rzdGLwB5vTfJsiIawHKM9RMmswBU
QQQ04rVeVzXboEyzHWpl1kdftFvWnWd0qrN8DF1P1Wb0ImE9CgjGaVDckxpb8omU
rqajKQhVG8fowtUdWBNHGxupepzs4nDMZqw9exLQfjvM+0QJ4KJtMlx2WHzg3JeI
baOyiET9NbTeokm0tgXj/WG9jEN6suuwz2zDLluvESyFeQg5XBC0cb3WOIoNOelH
L7ZZsvfgVNsWTKRYlubUs2fqUJX0zHBeYU8Bx1XvRbCdbIXGfjfPnEdMfrlGNEqD
J/KcfocYcEhGTEkGaOkPqf6p1z3HtW2bXSPsglxiis3iU61z1Jgi+Qb31oCxmhak
HtRd8NoXQ4J14NwvcE3T
=E82+
-----END PGP SIGNATURE-----

--=-j60f5tLzX2bIHVg2FjQx--

