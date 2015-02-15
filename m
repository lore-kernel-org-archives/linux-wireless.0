Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gn237.zone.eu ([217.146.67.237]:17769 "EHLO gn237.zone.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754724AbbBOUsW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Feb 2015 15:48:22 -0500
From: Priit Laes <plaes@plaes.org>
To: Larry Finger <Larry.Finger@lwfinger.net>,
	Chaoming Li <chaoming_li@realsil.com.cn>,
	Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, Priit Laes <plaes@plaes.org>
Subject: [PATCH v2 0/7] rtlwifi: Unused #define removal
Date: Sun, 15 Feb 2015 22:46:44 +0200
Message-Id: <1424033211-11696-1-git-send-email-plaes@plaes.org> (sfid-20150215_215053_177312_0B7B409E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

This is v2 of the rtlwifi unused #define cleanup patchset.

Changes since v1:

  - Rebase patches against wireless-driver-next tree.


Priit Laes (7):
  rtlwifi: Remove unused defines from rtl8192cu driver
  rtlwifi: Remove unused defines from driver-specific def.h
  rtlwifi: Remove unused RF6052_MAX_REG define
  rtlwifi: Remove unused defines from cam.h
  rtlwifi: Remove unused defines from base.h
  rtlwifi: Remove unused defines from efuse.h
  rtlwifi: Remove unused RTL_SUPPORTED_CTRL_FILTER define

 drivers/net/wireless/rtlwifi/base.h          |  6 ----
 drivers/net/wireless/rtlwifi/cam.h           |  2 --
 drivers/net/wireless/rtlwifi/core.h          |  2 --
 drivers/net/wireless/rtlwifi/efuse.h         |  6 ----
 drivers/net/wireless/rtlwifi/rtl8188ee/def.h | 41 ----------------------------
 drivers/net/wireless/rtlwifi/rtl8188ee/rf.h  |  1 -
 drivers/net/wireless/rtlwifi/rtl8192ce/def.h | 41 ----------------------------
 drivers/net/wireless/rtlwifi/rtl8192ce/rf.h  |  1 -
 drivers/net/wireless/rtlwifi/rtl8192cu/hw.h  |  2 --
 drivers/net/wireless/rtlwifi/rtl8192cu/rf.h  |  1 -
 drivers/net/wireless/rtlwifi/rtl8192de/def.h | 39 --------------------------
 drivers/net/wireless/rtlwifi/rtl8192ee/rf.h  |  1 -
 drivers/net/wireless/rtlwifi/rtl8192se/def.h |  1 -
 drivers/net/wireless/rtlwifi/rtl8723ae/def.h | 41 ----------------------------
 drivers/net/wireless/rtlwifi/rtl8723ae/rf.h  |  1 -
 drivers/net/wireless/rtlwifi/rtl8723be/rf.h  |  1 -
 drivers/net/wireless/rtlwifi/rtl8821ae/def.h | 41 ----------------------------
 drivers/net/wireless/rtlwifi/rtl8821ae/rf.h  |  1 -
 18 files changed, 229 deletions(-)

-- 
2.3.0

