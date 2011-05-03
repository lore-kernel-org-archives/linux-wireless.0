Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2179 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752019Ab1ECHBK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 May 2011 03:01:10 -0400
From: sukeshs@broadcom.com
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 0/2] *** SUBJECT HERE ***
Date: Tue, 3 May 2011 00:00:55 -0700
Message-ID: <1304406057-8722-1-git-send-email-sukeshs@broadcom.com> (sfid-20110503_090113_623365_8DC3A802)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sukesh Srikakula <sukeshs@xl-sj1-20.sj.broadcom.com>

*** BLURB HERE ***

Sukesh Srikakula (2):
  brcm80211: FIX for TKIP GTK bug
  brcm80211: Fix for suspend/resume bug

 drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c |    4 ----
 drivers/staging/brcm80211/brcmfmac/dhd.h          |    3 +++
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c    |    6 ++++--
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c  |   12 ++++++++++++
 4 files changed, 19 insertions(+), 6 deletions(-)

-- 
1.7.3.2


