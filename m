Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1352 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751166Ab1DSHN7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Apr 2011 03:13:59 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com
Subject: [PATCH 0/2] staging: brcm80211: removal of obsolete mips code
Date: Tue, 19 Apr 2011 09:13:43 +0200
Message-ID: <1303197225-4263-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Code cleanup. Follow up on feedback from John Linville. 

Roland Vossen (2):
  staging: brcm80211: removed #ifdef __mips__
  staging: brcm80211: removed BCMFASTPATH macro

 .../staging/brcm80211/brcmsmac/phy/wlc_phy_cmn.c   |   50 +-------------------
 drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_n.c |    2 +-
 drivers/staging/brcm80211/brcmsmac/wl_mac80211.c   |    8 ++--
 drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c     |   10 ++--
 drivers/staging/brcm80211/brcmsmac/wlc_antsel.c    |    2 +-
 drivers/staging/brcm80211/brcmsmac/wlc_bmac.c      |   12 ++--
 drivers/staging/brcm80211/brcmsmac/wlc_main.c      |   40 ++++++++--------
 drivers/staging/brcm80211/brcmsmac/wlc_rate.c      |    4 +-
 drivers/staging/brcm80211/include/bcmdefs.h        |    6 --
 drivers/staging/brcm80211/include/bcmutils.h       |   31 ------------
 drivers/staging/brcm80211/util/bcmutils.c          |   44 +++--------------
 drivers/staging/brcm80211/util/hnddma.c            |   37 +++------------
 12 files changed, 55 insertions(+), 191 deletions(-)


