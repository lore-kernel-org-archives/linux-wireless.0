Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:52285 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754507AbaIKUvi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Sep 2014 16:51:38 -0400
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH for-3.17 0/3] brcmfmac: regression fixes
Date: Thu, 11 Sep 2014 22:51:29 +0200
Message-ID: <1410468692-20852-1-git-send-email-arend@broadcom.com> (sfid-20140911_225141_606794_E6B4CB25)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series contains fixes regression made by new functionality
in the driver. The Kconfig fix was reported. The other two changes
were found during internal testing.

This series is intended for v3.17 kernel and applies to the master
branch of the wireless repository.

Arend van Spriel (2):
  brcmfmac: conditionally compile firmware protocol source code
  brcmfmac: obtain ifp through wdev structure

Hante Meuleman (1):
  brcmfmac: Fix memory leak and missing assignment.

 drivers/net/wireless/brcm80211/Kconfig                | 10 ++++++++++
 drivers/net/wireless/brcm80211/brcmfmac/Makefile      | 10 ++++++----
 drivers/net/wireless/brcm80211/brcmfmac/bcdc.h        |  7 +++++--
 drivers/net/wireless/brcm80211/brcmfmac/msgbuf.h      | 11 +++++++++--
 drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c |  9 +++++++--
 5 files changed, 37 insertions(+), 10 deletions(-)

-- 
1.9.1

