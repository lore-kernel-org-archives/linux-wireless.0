Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1045 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753333Ab1DOJ5h (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Apr 2011 05:57:37 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 0/4] staging: brcm80211: error code cleanup
Date: Fri, 15 Apr 2011 11:57:20 +0200
Message-ID: <1302861444-27530-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Code cleanup. Converted Broadcom specific error codes into Linux native
ones.

Roland Vossen (4):
  staging: brcm80211: removed error string function
  staging: brcm80211: replace error codes part 1
  staging: brcm80211: replace error codes part 2
  staging: brcm80211: made fullmac error codes more consistent

 drivers/staging/brcm80211/brcmfmac/bcmsdh.c        |   32 ++--
 drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c  |   18 +-
 .../brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c        |    2 +-
 drivers/staging/brcm80211/brcmfmac/dhd_cdc.c       |   12 +-
 drivers/staging/brcm80211/brcmfmac/dhd_common.c    |   30 ++--
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c     |   65 +------
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c      |  120 ++++++------
 drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_n.c |   12 +-
 drivers/staging/brcm80211/brcmsmac/wl_mac80211.c   |    2 +-
 drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c     |   10 +-
 drivers/staging/brcm80211/brcmsmac/wlc_bmac.c      |    4 +-
 drivers/staging/brcm80211/brcmsmac/wlc_channel.c   |    2 +-
 drivers/staging/brcm80211/brcmsmac/wlc_key.h       |   10 +-
 drivers/staging/brcm80211/brcmsmac/wlc_main.c      |  208 ++++++++++----------
 drivers/staging/brcm80211/brcmsmac/wlc_stf.c       |   10 +-
 drivers/staging/brcm80211/include/bcmutils.h       |   87 --------
 drivers/staging/brcm80211/util/bcmotp.c            |   30 ++--
 drivers/staging/brcm80211/util/bcmsrom.c           |   12 +-
 drivers/staging/brcm80211/util/bcmutils.c          |   32 +---
 drivers/staging/brcm80211/util/nvram/nvram_ro.c    |    6 +-
 20 files changed, 271 insertions(+), 433 deletions(-)


