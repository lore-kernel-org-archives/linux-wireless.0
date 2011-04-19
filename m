Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4484 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752167Ab1DSJB1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Apr 2011 05:01:27 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 0/5] staging: brcm80211: last ASSERTs removed from
 softmac
Date: Tue, 19 Apr 2011 11:01:11 +0200
Message-ID: <1303203676-20165-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Code cleanup.

Roland Vossen (5):
  staging: brcm80211: removed ASSERTs from aiutils.c
  staging: brcm80211: removed ASSERTs from wlc_pmu.c
  staging: brcm80211: removed ASSERTs from siutils.c
  staging: brcm80211: removed ASSERTs from hnddma.c and sbutils.c
  staging: brcm80211: moved ASSERT logic to fullmac driver

 drivers/staging/brcm80211/brcmfmac/bcmsdh.c        |    2 +
 drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c  |    3 +
 .../brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c        |    3 +
 drivers/staging/brcm80211/brcmfmac/dhd.h           |   10 +++
 drivers/staging/brcm80211/brcmfmac/dhd_pmu.c       |    3 +-
 drivers/staging/brcm80211/brcmfmac/wl_iw.c         |   50 +++++++++++++
 drivers/staging/brcm80211/brcmsmac/aiutils.c       |   78 +------------------
 drivers/staging/brcm80211/brcmsmac/wlc_pmu.c       |   50 +------------
 drivers/staging/brcm80211/include/bcmdefs.h        |    6 --
 drivers/staging/brcm80211/include/bcmutils.h       |   10 ---
 drivers/staging/brcm80211/util/bcmutils.c          |   50 -------------
 drivers/staging/brcm80211/util/hnddma.c            |    2 -
 drivers/staging/brcm80211/util/sbutils.c           |   16 +----
 drivers/staging/brcm80211/util/siutils.c           |   49 +-----------
 14 files changed, 82 insertions(+), 250 deletions(-)


