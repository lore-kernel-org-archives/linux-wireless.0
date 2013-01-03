Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48371 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752853Ab3ACOpD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Jan 2013 09:45:03 -0500
Message-ID: <1357224324.9741.20.camel@jlt4.sipsolutions.net> (sfid-20130103_154507_387968_EEE45336)
Subject: pull-request: iwlwifi-next 2012-01-03
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 03 Jan 2013 15:45:24 +0100
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-/5aZgUxtLUZafvYZ2+4N"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-/5aZgUxtLUZafvYZ2+4N
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

John,

My last pull request for today :-)

For iwlwifi-next, I have a few cleanups/improvements as well as a few
not very important fixes and more preparations for new devices.

Let me know if there are any problems.

Thanks,
johannes


The following changes since commit a49f0d1ea3ec94fc7cf33a7c36a16343b74bd565=
:

  Linux 3.8-rc1 (2012-12-21 17:19:00 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git fo=
r-john

for you to fetch changes up to abae2386d55aff1d395cdb665f03684c227a6a69:

  iwlwifi: always check that grab_nic_access succeeds (2013-01-03 15:34:11 =
+0100)

----------------------------------------------------------------
Emmanuel Grumbach (8):
      iwlwifi: make the BC table layout configurable
      iwlwifi: clean up code in AGG
      iwlwifi: don't verify fw after download
      iwlwifi: let the op_mode run a FW while in RFKILL
      iwlwifi: virtualize iwl_{grab,release}_nic_access
      iwlwifi: virtualize SRAM access
      iwlwifi: don't treat a bool as an error code
      iwlwifi: always check that grab_nic_access succeeds

Eytan Lifshitz (1):
      iwlwifi: fix spelling and value in LED registers.

Johannes Berg (3):
      iwlwifi: use __packed
      iwlwifi: request IRQ only once
      iwlwifi: move some PCIe calls to better places

 drivers/net/wireless/iwlwifi/dvm/commands.h  |   8 +-
 drivers/net/wireless/iwlwifi/dvm/debugfs.c   |   4 +-
 drivers/net/wireless/iwlwifi/dvm/led.c       |   2 +-
 drivers/net/wireless/iwlwifi/dvm/mac80211.c  |   8 +-
 drivers/net/wireless/iwlwifi/dvm/main.c      |  21 ++--
 drivers/net/wireless/iwlwifi/dvm/tt.c        |   4 +-
 drivers/net/wireless/iwlwifi/dvm/tx.c        |  21 ++--
 drivers/net/wireless/iwlwifi/dvm/ucode.c     |  96 +-------------
 drivers/net/wireless/iwlwifi/iwl-csr.h       |   4 +-
 drivers/net/wireless/iwlwifi/iwl-io.c        | 168 ++++-------------------=
--
 drivers/net/wireless/iwlwifi/iwl-io.h        |  21 +---
 drivers/net/wireless/iwlwifi/iwl-test.c      |  53 ++++----
 drivers/net/wireless/iwlwifi/iwl-trans.h     |  69 ++++++++++-
 drivers/net/wireless/iwlwifi/pcie/internal.h |   6 +-
 drivers/net/wireless/iwlwifi/pcie/rx.c       |   2 +
 drivers/net/wireless/iwlwifi/pcie/trans.c    | 179 ++++++++++++++++++++---=
----
 drivers/net/wireless/iwlwifi/pcie/tx.c       |  31 ++---
 17 files changed, 311 insertions(+), 386 deletions(-)


--=-/5aZgUxtLUZafvYZ2+4N
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJQ5ZmEAAoJEDBSmw7B7bqrHGcP/22sTHe28g5jCxv6xYEuRPQe
8wWVjOJ3bMdINPS6Q19qGfZeSvvmlZo4xgSUysK52sgvNVDYoaLECMO6FfIXZ6hn
xtzYlXof7N9lkf9S4g57kX3EaZbwM1iK26jt0SdJV167W2m7N3w+k5sDyi288t7Q
+WvHNkV24GmHcydkKU/lGC0mVqZY4Nh1WS1+JDW+rP3zb0O9HY828v9l1mz/Q6DN
HHk3dxmh/QK3jXiLd3VTEhATHD4OXo1NKXin58UmqOt8ritz4bzC0bJ4BUYJGnCX
2mkX97ZnwRXIQtt5JC60nBRWVT7cxsmIKxfaQevOhCw/ndnFSXc6INuR2fIQVdz5
TqcTg7hDMd26RyU4UO+9yyAiy9cenJQROQCJh7xzIrUyg6HxFIKOGorKZxhhr9Ck
E1v+iPlWFDQCKEys/pl44uG9uKsfU1bxt1OLl1NSkwxVne2t+Il6ylmq0J/bjT1B
k0Z8BMgz1UJsALfv/2KR4YD1orHf4xKRs3sa9ups2osQ+UkFpLBdj4aH6LFQ/s2B
SnwmsWAeS2GvCJcxsSUxbXh9uBgSqGA0trzarVYT/qlXjvCWvRSyFpGGpl5i5EMh
OmDQq4eojC+AteCJ9rjFzo6wg7nyjGK1PZW2KYNULmgtXOOPwYCEPc/BKK9/GcWR
g/To2lX2LOdMQt46FLch
=MfSS
-----END PGP SIGNATURE-----

--=-/5aZgUxtLUZafvYZ2+4N--

