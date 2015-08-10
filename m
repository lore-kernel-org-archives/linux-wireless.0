Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0150.hostedemail.com ([216.40.44.150]:40085 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932789AbbHJVwL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Aug 2015 17:52:11 -0400
From: Joe Perches <joe@perches.com>
To: devel@driverdev.osuosl.org, driverdev-devel@linuxdriverproject.org,
	ac100@lists.launchpad.net, linux-tegra@vger.kernel.org,
	speakup@linux-speakup.org, linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
	HPDD-discuss@lists.01.org
Subject: [PATCH 00/19] staging: Remove unnecessary externs
Date: Mon, 10 Aug 2015 14:51:15 -0700
Message-Id: <cover.1439241825.git.joe@perches.com> (sfid-20150810_235720_644492_30F7430C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

trivial neatening of prototypes

Joe Perches (19):
  staging: android: Remove unnecessary externs
  staging: dgnc: Remove unnecessary externs
  staging: fbtft: Remove unnecessary externs
  staging: ft1000: Remove unnecessary externs
  staging: iio: Remove unnecessary externs
  staging: lustre: Remove unnecessary externs
  staging: most: Remove unnecessary externs
  staging: mt29f_spinand: Remove unnecessary externs
  staging: netlogic: Remove unnecessary externs
  staging: nvec: Remove unnecessary externs
  staging: octeon: Remove unnecessary externs
  staging: olpc_dcon: Remove unnecessary externs
  staging: rtl8188eu: Remove unnecessary externs
  staging: rtl8192e: Remove unnecessary externs
  staging: rtl8192u: Remove unnecessary externs
  staging: rtl8712: Remove unnecessary externs
  staging: speakup: Remove unnecessary externs
  staging: wilc1000: Remove unnecessary externs
  staging: xgifb: Remove unnecessary externs

 drivers/staging/android/sync.h                     |  10 +-
 drivers/staging/dgnc/dgnc_sysfs.h                  |  16 +-
 drivers/staging/fbtft/fbtft.h                      |  52 ++-
 drivers/staging/ft1000/ft1000-pcmcia/ft1000.h      |  19 +-
 drivers/staging/ft1000/ft1000-usb/ft1000_usb.h     |   4 +-
 drivers/staging/iio/meter/ade7854.h                |   4 +-
 .../staging/lustre/lnet/klnds/o2iblnd/o2iblnd.h    |   2 +-
 .../staging/lustre/lnet/klnds/socklnd/socklnd.h    | 141 +++++----
 drivers/staging/lustre/lnet/selftest/console.h     |  90 +++---
 .../staging/lustre/lustre/include/lprocfs_status.h | 313 +++++++++----------
 .../lustre/lustre/include/lustre/lustre_idl.h      | 133 ++++----
 .../lustre/lustre/include/lustre/lustre_user.h     |   2 +-
 drivers/staging/lustre/lustre/include/lustre_dlm.h |   2 +-
 .../staging/lustre/lustre/include/lustre_export.h  |   4 +-
 .../staging/lustre/lustre/include/lustre_import.h  |   4 +-
 drivers/staging/lustre/lustre/include/lustre_net.h |  16 +-
 drivers/staging/lustre/lustre/include/obd_class.h  |  16 +-
 .../staging/lustre/lustre/include/obd_support.h    |   6 +-
 drivers/staging/lustre/lustre/ldlm/ldlm_internal.h |   2 +-
 drivers/staging/lustre/lustre/libcfs/tracefile.h   |  32 +-
 .../staging/lustre/lustre/llite/llite_internal.h   |  16 +-
 drivers/staging/most/hdm-dim2/dim2_hal.h           |   8 +-
 drivers/staging/mt29f_spinand/mt29f_spinand.h      |   4 +-
 drivers/staging/netlogic/xlr_net.h                 |   2 +-
 drivers/staging/nvec/nvec.h                        |  19 +-
 drivers/staging/octeon/ethernet-mdio.h             |   2 +-
 drivers/staging/octeon/octeon-ethernet.h           |  22 +-
 drivers/staging/olpc_dcon/olpc_dcon.h              |   2 +-
 drivers/staging/rtl8188eu/include/osdep_service.h  |   2 +-
 drivers/staging/rtl8188eu/include/rtw_mlme_ext.h   |   8 +-
 drivers/staging/rtl8188eu/include/sta_info.h       |  18 +-
 drivers/staging/rtl8192e/rtl8192e/r8190P_rtl8256.h |  10 +-
 drivers/staging/rtl8192e/rtl8192e/r8192E_cmdpkt.h  |   4 +-
 .../staging/rtl8192e/rtl8192e/r8192E_firmware.h    |   2 +-
 drivers/staging/rtl8192e/rtl8192e/r8192E_phy.h     |  52 ++-
 drivers/staging/rtl8192e/rtl8192e/rtl_dm.h         |  22 +-
 drivers/staging/rtl8192e/rtllib.h                  | 347 ++++++++++-----------
 drivers/staging/rtl8192u/ieee80211/ieee80211.h     | 345 ++++++++++----------
 drivers/staging/rtl8192u/r8190_rtl8256.h           |  11 +-
 drivers/staging/rtl8192u/r8192U.h                  |   2 +-
 drivers/staging/rtl8192u/r8192U_dm.h               |  36 +--
 drivers/staging/rtl8192u/r8192U_wx.h               |   2 +-
 drivers/staging/rtl8192u/r819xU_cmdpkt.h           |   8 +-
 drivers/staging/rtl8192u/r819xU_phy.h              |  55 ++--
 drivers/staging/rtl8712/rtl871x_ioctl.h            |  28 +-
 drivers/staging/speakup/i18n.h                     |  12 +-
 drivers/staging/speakup/speakup.h                  |  68 ++--
 drivers/staging/wilc1000/coreconfigurator.h        |  30 +-
 drivers/staging/wilc1000/linux_wlan_common.h       |   4 +-
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.h  |   2 +-
 drivers/staging/xgifb/vb_init.h                    |   4 +-
 drivers/staging/xgifb/vb_setmode.h                 |  34 +-
 52 files changed, 1007 insertions(+), 1042 deletions(-)

-- 
2.1.2

