Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4910 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752890Ab1DSG7V (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Apr 2011 02:59:21 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 0/3] staging: brcm80211: message logging macro cleanup
Date: Tue, 19 Apr 2011 08:59:01 +0200
Message-ID: <1303196344-3157-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Code cleanup.

Roland Vossen (3):
  staging: brcm80211: replaced WL_TRACE by BCMMSG
  staging: brcm80211: replaced WL_AMPDU_* with BCMMSG
  staging: brcm80211: got rid of WL_FFPLD message log macro

 drivers/staging/brcm80211/brcmsmac/wl_dbg.h      |   20 ++---
 drivers/staging/brcm80211/brcmsmac/wl_mac80211.c |   18 ++--
 drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c   |   63 ++++++--------
 drivers/staging/brcm80211/brcmsmac/wlc_bmac.c    |  104 +++++++++++-----------
 drivers/staging/brcm80211/brcmsmac/wlc_channel.c |    2 +-
 drivers/staging/brcm80211/brcmsmac/wlc_main.c    |   62 +++++++-------
 drivers/staging/brcm80211/brcmsmac/wlc_stf.c     |    6 +-
 drivers/staging/brcm80211/include/wlioctl.h      |    2 -
 8 files changed, 128 insertions(+), 149 deletions(-)


