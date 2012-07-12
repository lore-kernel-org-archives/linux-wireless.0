Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46889 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752853Ab2GLMqH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jul 2012 08:46:07 -0400
Message-ID: <1342097161.4531.21.camel@jlt3.sipsolutions.net> (sfid-20120712_144611_915106_02E3F8FA)
Subject: pull-request: iwlwifi-next 2012-07-12
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Thu, 12 Jul 2012 14:46:01 +0200
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-EdLZfpI6DdEUNe5GvhJH"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-EdLZfpI6DdEUNe5GvhJH
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

John,

Please pull my iwlwifi-next tree to get two fixes and a cleanup patch
(as per below).

Thanks,
johannes

The following changes since commit 0ff1bd35f5aece42879b04cbfe6b4040cf50a697=
:

  iwlwifi: disallow log_event access if interface down (2012-07-03 14:03:26=
 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git fo=
r-john

for you to fetch changes up to 3ec4588231914344834805a6828551cd5c65afd8:

  iwlwifi: don't use stack memory for kmem cache name (2012-07-12 14:37:39 =
+0200)

----------------------------------------------------------------
Emmanuel Grumbach (1):
      iwlwifi: REPLY_RX doesn't exist any more

Johannes Berg (1):
      iwlwifi: don't use stack memory for kmem cache name

Wey-Yi Guy (1):
      iwlwifi: set correct 32 bit boost register value

 drivers/net/wireless/iwlwifi/dvm/commands.h |    1 +
 drivers/net/wireless/iwlwifi/dvm/lib.c      |    2 ++
 drivers/net/wireless/iwlwifi/dvm/main.c     |    1 -
 drivers/net/wireless/iwlwifi/dvm/rx.c       |   44 +++++++----------------=
----
 drivers/net/wireless/iwlwifi/iwl-config.h   |    2 +-
 drivers/net/wireless/iwlwifi/iwl-trans.h    |    1 +
 drivers/net/wireless/iwlwifi/pcie/2000.c    |    2 +-
 drivers/net/wireless/iwlwifi/pcie/trans.c   |    7 ++---
 8 files changed, 20 insertions(+), 40 deletions(-)


--=-EdLZfpI6DdEUNe5GvhJH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJP/scJAAoJEDBSmw7B7bqrH90P/2rKJFzDz+LBz/jE1PJjbO0v
jBpeDo7qJU7yelKo2CC0wUMid44yncOzgcN7u+ioJYJg84bvWTJfzgdXSAoMcAi+
r/F/cxXuQ+tSlijcCCEyTCWaqUKlGz00xO35ZFqTV/woHPf+mcg35raagA/sT2y/
8fTs14o9aV5pgMo3wpX6ZMWpujQpNmlczX+YcQvgMPrK4RkspM8hVf3jKxxjjIvs
gvJ/gn/fndeJEE5KKZvv1b6e3/QY6h7IJ5FOH/Ewv4WWb3V1x5HF1E2NdvXfgc13
iycevOOcYPnoK6Y2WJvtm5fg1YZt9hMZdtqb4QJExOgzuS3NwAOMeI1Zr5tBHlLc
NKuQYZ0SBpwf+mpR8p4LklIflsERqf6C6FywFSYYxh5fiq1q/dkfdhqL3uCne08C
AGhnEH9gsLn5EPnN7iourXx2fFXyIgSki+GHsNyp0ddlnSbRHcUUk+j7dLA+hejv
h86sjpMSKkAMSS4nu6XJxTrorUbUScJGxTEc8YO0PuGvrEqsb3FgyB3pptImtheu
v3uhHjQkpQFqYKWprECkn4eBdrEfmYTN0ZZe1is8SbaTkGBz4GoGr2J1lkHTaUMO
OJyhJWcZ1YEtQiGwwqzbDdXUM8dwGjbln7OiobQ2b3iYcltBKqfr2WSNgGx7fK1z
DlkMz28HF24au1EOE4yg
=XiEc
-----END PGP SIGNATURE-----

--=-EdLZfpI6DdEUNe5GvhJH--

