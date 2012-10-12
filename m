Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1239 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933837Ab2JLK23 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Oct 2012 06:28:29 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 0/3] wireless: only use WLAN_EID_VENDOR_SPECIFIC
Date: Fri, 12 Oct 2012 12:28:13 +0200
Message-ID: <1350037696-23747-1-git-send-email-arend@broadcom.com> (sfid-20121012_122844_139948_31776ADC)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Getting rid of duplicate definitions in linux/ieee80211.h.

Patches are intended for 3.8 and apply to the wireless-next
repository.

Arend van Spriel (3):
  wireless: drivers: make use of WLAN_EID_VENDOR_SPECIFIC
  wireless: gelic: make use of WLAN_EID_VENDOR_SPECIFIC
  wireless: remove duplicate enum ieee80211_eid definitions

 drivers/net/ethernet/toshiba/ps3_gelic_wireless.c  |    4 ++--
 drivers/net/wireless/airo.c                        |    2 +-
 drivers/net/wireless/ath/ath6kl/cfg80211.c         |    2 +-
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |    2 +-
 drivers/net/wireless/hostap/hostap_80211_rx.c      |    2 +-
 drivers/net/wireless/ipw2x00/libipw_rx.c           |    4 ++--
 drivers/net/wireless/libertas/mesh.c               |    2 +-
 drivers/net/wireless/mwifiex/scan.c                |   13 ++++++++-----
 drivers/net/wireless/mwifiex/sta_ioctl.c           |    4 ++--
 drivers/net/wireless/orinoco/main.h                |    2 +-
 include/linux/ieee80211.h                          |    2 --
 11 files changed, 20 insertions(+), 19 deletions(-)

-- 
1.7.9.5


