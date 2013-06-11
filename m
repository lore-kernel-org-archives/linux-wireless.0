Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:38594 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755957Ab3FKSPk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Jun 2013 14:15:40 -0400
Message-ID: <1370974531.8356.56.camel@jlt4.sipsolutions.net> (sfid-20130611_201543_141311_7A590D93)
Subject: pull-request: iwlwifi-next 2013-06-11
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 11 Jun 2013 20:15:31 +0200
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-dgtfQRQNnyHtmp1W+P1D"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-dgtfQRQNnyHtmp1W+P1D
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

For iwlwifi-next I only have a few cleanups:

Emmanuel removed an unused field, fixed a comment and added a warning
for something that shouldn't happen in practice, and I removed the
declaration of a function that doesn't even exist.

johannes

The following changes since commit fded313ec045024d4f769ce6b3e41fe343c167b0=
:

  iwlwifi: mvm: don't request SMPS on non-STA iface (2013-06-05 09:06:13 +0=
200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git fo=
r-john

for you to fetch changes up to 476a9e09cbe37bad93de6e460b76f89f3ad22c9b:

  iwlwifi: ignore 0-length PHY DB sections (2013-06-11 20:12:02 +0200)

----------------------------------------------------------------
Emmanuel Grumbach (3):
      iwlwifi: mvm: remove unused wait_for_ba field
      iwlwifi: mvm: fix irrelevant comment
      iwlwifi: ignore 0-length PHY DB sections

Johannes Berg (1):
      iwlwifi: mvm: remove iwl_mvm_dbgfs_set_fw_dbg_log declaration

 drivers/net/wireless/iwlwifi/iwl-phy-db.c   | 3 +++
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 3 +--
 drivers/net/wireless/iwlwifi/mvm/mvm.h      | 5 -----
 drivers/net/wireless/iwlwifi/mvm/sta.h      | 2 --
 4 files changed, 4 insertions(+), 9 deletions(-)


--=-dgtfQRQNnyHtmp1W+P1D
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJRt2lDAAoJEDBSmw7B7bqrfaAP/0yrwk4KyYRRdlQ/hJfJjilk
bzhrwbWHfiWOFOWctDQ2G/AMyba68wLc2Ors+GmWkwqnp6GlEXSJptNFnY1mZ3pK
6UUDJl+y8prgByWrt/mmL0bS/xpVHmhr2JPI99S+lGXbaeMOLl5ljKryfdw1+WbQ
oDoqaFUhZDYcnV+Qa7TM+t47gzaUrPsz7/RtzQakQHWVBkDI6y6g7T5B7a3dv7uM
8j9Z8mJg4DLId7OVYo42leob3GjkQfWPFOuf3x9w2BWC0KzNzsnJ0co+kNmwrkGQ
iXQIR9jedg/A156eIM24ECaDhB+g0g2JT28VMsv56RKCZ/I4yiGlSFf3uqDkJFi8
kNLXCUPeFsKjlFbK4qTlDT0vV2+FTK8LwGQIdvGUcdwy9PMWPY2W8m5CPKMih4ja
diZN2oYiUTWhPagowevIWdixPUtrSRNgll/bdAebg9hbkb/QIU1yUhIQNhFOD+NP
fb0M+3QoLRe/2FhUz7b8yoUCxLzsZwK7nWlsGyTkDxFZdlcG0yl+QkfcDQIa0Tiz
V+ttx0TK3BXa09zTf2sUa3KHbdB18BOWlJpJOGIwjo2FK8iHyYHCvMYMThllYJDe
KWatCce2NfrAZspxtxZX4arYF2k2k/3oAlLxR5/8PwivXFoW7ENE51hjIFIhMX2U
oD8RbHBCHtOTiKqWCFm5
=EOQI
-----END PGP SIGNATURE-----

--=-dgtfQRQNnyHtmp1W+P1D--

