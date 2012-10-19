Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54830 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758242Ab2JSN67 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Oct 2012 09:58:59 -0400
Message-ID: <1350655170.10678.8.camel@jlt4.sipsolutions.net> (sfid-20121019_155901_886659_F0FDC49B)
Subject: pull-request: iwlwifi-next 2012-10-19
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Fri, 19 Oct 2012 15:59:30 +0200
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-3NRoA9O81x0BRN6IyDP/"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-3NRoA9O81x0BRN6IyDP/
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

John,

please pull my iwlwifi-next tree. There isn't a lot right now since
we're still working on that new code I told you about, but I have a few
general updates.

johannes


The following changes since commit ddffeb8c4d0331609ef2581d84de4d763607bd37=
:

  Linux 3.7-rc1 (2012-10-14 14:41:04 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git fo=
r-john

for you to fetch changes up to 4e760f1ab267edcd6e4b232ff732fc9cdc659ebb:

  iwlwifi: don't WARN when a non empty queue is disabled (2012-10-16 16:41:=
40 +0200)

----------------------------------------------------------------
Emmanuel Grumbach (5):
      iwlwifi: wipe out the status of the SCD when we disable a queue
      iwlwifi: use the new macro for the SCD Q STTS bits
      iwlwifi: first deactivate a queue, then wipe out its data
      iwlwifi: don't print the Intel banner twice
      iwlwifi: don't WARN when a non empty queue is disabled

Johannes Berg (3):
      iwlwifi: improve oversized command warning
      iwlwifi: make data frame tracing optional
      iwlwifi: remove unused variables

 drivers/net/wireless/iwlwifi/dvm/main.c     |    9 +--
 drivers/net/wireless/iwlwifi/iwl-devtrace.h |   95 +++++++++++++++++++++++=
+---
 drivers/net/wireless/iwlwifi/iwl-io.c       |    4 +-
 drivers/net/wireless/iwlwifi/iwl-io.h       |    2 +-
 drivers/net/wireless/iwlwifi/iwl-prph.h     |    3 +
 drivers/net/wireless/iwlwifi/iwl-trans.h    |    8 +++
 drivers/net/wireless/iwlwifi/pcie/rx.c      |    3 +-
 drivers/net/wireless/iwlwifi/pcie/trans.c   |    9 +--
 drivers/net/wireless/iwlwifi/pcie/tx.c      |   18 ++---
 9 files changed, 121 insertions(+), 30 deletions(-)


--=-3NRoA9O81x0BRN6IyDP/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJQgVzCAAoJEDBSmw7B7bqr5BgQALsX2ezpq93MdEnAU9jWlkZK
wpgBgP4Tvr2SJPpTgzYrQXXcLPHCxR4D89YKwzCk2QEdXV/5MsInr/xg+ifelnSX
fGv9qGoogVcWFGdXlnv2rE+78ukkPgrFK9XDpkkg2f7ag7ADk8DWvYmWSdRpG6Yd
wFK3XptB9A0EDueBtjKYiwFEiPJVdcGqqxfoY7qRbULaFagkQ8GqGt5qoDSerOZR
n2juynM77CrOW+yqbw3ng99yOkdWjGGUapBq91vKwdkmclqRP2vbmN0jkYwJTX20
Vuy1JoZJruNP6pnHE1BtqJthbTFzUBIInuGVckwWA+65kGlDLAK8AhMgBRSkYiko
bk/l5L8qrdol5XldzbOCidR1H/nyiqH7OkelZYVSDNsWRQ3lzmfXnIGJmeEVvXnR
CL4e6iRZhDJyIZ0akJGuWi2nsQFJnziJ/ibyV9EyJviIfjKpRFs+hjawlCdHgD+X
snghMAaOp9+6g7bfqiH522fYqSG5x/vW8w9et7pq61iIBvDmroQEIL74WG7pty6D
P1ZLUaMzy2Cekne6P6GqkD2oumb+WjLMrgcOqbPnFdS+rZwWs1AheIy+U/1WRJox
YvV5lqjffN8dN9JnzHN1h0P0A3KFwD5EjmbQQNLhEn0y5OPjxdJHkCUb9U8ri4vR
XB9AjkxDEVFEYiSkQPvh
=hhdT
-----END PGP SIGNATURE-----

--=-3NRoA9O81x0BRN6IyDP/--

