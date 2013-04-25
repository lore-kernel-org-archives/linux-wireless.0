Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sipsolutions.net ([144.76.43.152]:37989 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758687Ab3DYNxb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Apr 2013 09:53:31 -0400
Message-ID: <1366898002.15528.4.camel@jlt4.sipsolutions.net> (sfid-20130425_155336_679347_09921C26)
Subject: pull-request: iwlwifi-next 2013-04-25
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 25 Apr 2013 15:53:22 +0200
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-42Q8oPTzipi4yWUVRuah"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-42Q8oPTzipi4yWUVRuah
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi John,

For some reason I didn't send this before ...

Here are a few more changes for the 3.10 stream, some bugfixes,
adjustments to some powersave parameters and a new device ID.

Please pull.

Thanks,
johannes

The following changes since commit 2d055afdcada4bd8b510e9d2a8566fbded3c9696=
:

  iwlwifi: dvm: handle FLUSH ampdu actions from mac80211 (2013-04-08 13:32:=
20 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git fo=
r-john

for you to fetch changes up to 499892f2a9ad89910ff21c687273ac80b4367dc0:

  iwlwifi: add a subdevice ID for 7000 series (2013-04-18 13:40:05 +0200)

----------------------------------------------------------------
Alexander Bondar (2):
      iwlwifi: mvm: change TX/RX AM-to-PSM transition time for LP mode
      iwlwifi: mvm: remove usage of power_save module parameter

Emmanuel Grumbach (4):
      iwlwifi: mvm: remove TODO which has been addressed
      iwlwifi: mvm: fix first_antenna
      iwlwifi: dvm: don't send zeroed LQ cmd
      iwlwifi: add a subdevice ID for 7000 series

Stanislaw Gruszka (3):
      iwlwifi: fix freeing uninitialized pointer
      iwlwifi: remove redundant argument from iwl_dump_nic_event_log
      iwlwifi: remove unneeded goto from iwl_dbgfs_log_event_read

 drivers/net/wireless/iwlwifi/dvm/agn.h      |  2 +-
 drivers/net/wireless/iwlwifi/dvm/debugfs.c  | 16 +++++++---------
 drivers/net/wireless/iwlwifi/dvm/main.c     |  6 +++---
 drivers/net/wireless/iwlwifi/dvm/sta.c      |  5 ++++-
 drivers/net/wireless/iwlwifi/mvm/mac80211.c |  2 +-
 drivers/net/wireless/iwlwifi/mvm/phy-ctxt.c |  5 -----
 drivers/net/wireless/iwlwifi/mvm/power.c    | 16 ++++------------
 drivers/net/wireless/iwlwifi/mvm/utils.c    |  5 +++--
 drivers/net/wireless/iwlwifi/pcie/drv.c     |  1 +
 9 files changed, 24 insertions(+), 34 deletions(-)


--=-42Q8oPTzipi4yWUVRuah
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJReTVSAAoJEDBSmw7B7bqrjlQQAITZT2XZTvFB2JxESvq7/H/Y
Y+W+ke8azZ4OrWD1weLx+OCn0dRE6oYHLEYThODNOWUtnXlshmGciMRNYVpLof3r
U9UlvzJPk9Wptc4AT+iBNDlaBqKSD/VcHeoV/AUyzVktwTbAnHqEDPCCWR4b30m6
YRyG/xLE0E89bkunx+H0MWb/PpnUVZUFL14+J85kCLfS0b/5YnDk1HHVbRh7qhYM
qWjIvwLt0fgLSZY80Xj2YclEAL+/1ke0rZj8zN76knlNDZpWMh724aDApvpSeypx
dqRq6+pzAZMyGzD5jIyp0POSHyQ5vJLkBlpZmnC6GeVgFkn9LKBFiJ1KRRoc5+D2
ksPeZBn3arfL8RqqwPSpE/Zf47y/2dLnxpO0p+E55kFXSZ/UiqhWHo9XwNzh2/l8
69aSue1d1ZOb0RFMOlsyIg3W4/E6VoNAGhrHxDmlcLb3z92kgP/XMN5IHtwHbKuX
V61dX2j7Z4vD8D3rp3eA1b/EQC0dD68L+MFvtZg9QPKH70i5QWIiCtW/ESeC0L/c
qXbF2z/OyDKDju++//Vl3sGsMR2ffG2GRSCeUBCnn1pIBZ51QJloBTY64DPILr0X
bW/8FwiW3YnP6aTRrglkcYc5kLRgnPxT0c4/QQX1xsBL0mPuQNPBFMspniVilRi/
r6ZuHgbI2Z4EUNolW6RZ
=jqS7
-----END PGP SIGNATURE-----

--=-42Q8oPTzipi4yWUVRuah--

