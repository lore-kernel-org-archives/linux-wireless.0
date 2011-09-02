Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1782 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752332Ab1IBOAz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Sep 2011 10:00:55 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 00/12] staging: brcm80211: 3rd reaction to mainline
 patch #2
Date: Fri, 2 Sep 2011 16:00:27 +0200
Message-ID: <1314972039-27098-1-git-send-email-rvossen@broadcom.com> (sfid-20110902_160102_893845_1C7EC646)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Code cleanup and reduction of sparse warnings.

This series applies to staging-next and depends on the following patch set:

Message-ID: <1314868640-9425-31-git-send-email-rvossen@broadcom.com>

Arend van Spriel (5):
  staging: brcm80211: remove extern keyword from function definition
  staging: brcm80211: replace 0 integer with NULL pointer
  staging: brcm80211: use address space qualifier in brcmfmac
  staging: brcm80211: remove sparse warning from main.c
  staging: brcm80211: remove 'default n' from Kconfig

Roland Vossen (7):
  staging: brcm80211: cleaned up softmac phy macro's affecting code
    flow
  staging: brcm80211: cleaned up softmac nicpci.c/nicpci.h macro's
  staging: brcm80211: cleaned up more softmac macro's
  staging: brcm80211: remove AP related code from softmac
  staging: brcm80211: cleaned up softmac pub.h macro's
  staging: brcm80211: cleaned up softmac scb.h macro's
  staging: brcm80211: cleaned up softmac srom macro

 drivers/staging/brcm80211/Kconfig                 |    4 -
 drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c |   25 ++--
 drivers/staging/brcm80211/brcmfmac/dhd.h          |    2 +-
 drivers/staging/brcm80211/brcmfmac/dhd_common.c   |    8 +-
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c    |    4 +-
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c  |    2 +-
 drivers/staging/brcm80211/brcmsmac/ampdu.c        |    2 +-
 drivers/staging/brcm80211/brcmsmac/channel.c      |    6 +-
 drivers/staging/brcm80211/brcmsmac/main.c         |  191 ++++++++++++---------
 drivers/staging/brcm80211/brcmsmac/main.h         |    4 +-
 drivers/staging/brcm80211/brcmsmac/nicpci.c       |   42 +++--
 drivers/staging/brcm80211/brcmsmac/nicpci.h       |   12 --
 drivers/staging/brcm80211/brcmsmac/otp.c          |    5 +-
 drivers/staging/brcm80211/brcmsmac/otp.h          |    6 -
 drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c  |    6 +-
 drivers/staging/brcm80211/brcmsmac/pmu.h          |   13 --
 drivers/staging/brcm80211/brcmsmac/pub.h          |  173 ++-----------------
 drivers/staging/brcm80211/brcmsmac/rate.h         |   16 --
 drivers/staging/brcm80211/brcmsmac/scb.h          |   24 +--
 drivers/staging/brcm80211/brcmsmac/srom.c         |   22 +--
 drivers/staging/brcm80211/brcmsmac/types.h        |    5 -
 21 files changed, 205 insertions(+), 367 deletions(-)

-- 
1.7.4.1


