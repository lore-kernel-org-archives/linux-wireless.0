Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4089 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752544Ab1DRJcC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Apr 2011 05:32:02 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 0/3] staging: brcm80211: ASSERT removal in softmac
Date: Mon, 18 Apr 2011 11:31:45 +0200
Message-ID: <1303119108-32487-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Code cleanup. Driver contains too many ASSERTs.

Roland Vossen (3):
  staging: brcm80211: delete ASSERTs in 4 files in brcmsmac dir
  staging: brcm80211: removed all ASSERTs from wl_mac80211.c
  staging: brcm80211: removed all ASSERTs from wlc_ampdu.c

 drivers/staging/brcm80211/brcmsmac/wl_mac80211.c |   60 +++++++---------------
 drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c   |    9 +--
 drivers/staging/brcm80211/brcmsmac/wlc_antsel.c  |    3 -
 drivers/staging/brcm80211/brcmsmac/wlc_channel.c |   18 +------
 drivers/staging/brcm80211/brcmsmac/wlc_rate.c    |    6 +--
 drivers/staging/brcm80211/brcmsmac/wlc_stf.c     |   19 +------
 6 files changed, 28 insertions(+), 87 deletions(-)


