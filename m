Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:3082 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751180AbcKHNOu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 8 Nov 2016 08:14:50 -0500
From: <c_traja@qti.qualcomm.com>
To: <linux-wireless@vger.kernel.org>
CC: <ath10k@lists.infradead.org>, <johannes@sipsolutions.net>,
        <tamizhchelvam@codeaurora.org>,
        Tamizh chelvam <c_traja@qti.qualcomm.com>
Subject: [PATCH 0/4] cfg80211: mac80211: BTCOEX feature support
Date: Tue, 8 Nov 2016 18:45:28 +0530
Message-ID: <1478610932-21954-1-git-send-email-c_traja@qti.qualcomm.com> (sfid-20161108_141454_513319_2E28A501)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tamizh chelvam <c_traja@qti.qualcomm.com>

This patchset add support for BTCOEX feature to enable/disable btcoex
and modifying btcoex priority value via nl80211.

Tamizh chelvam (4):
  cfg80211: Add support to enable or disable btcoex
  cfg80211: Add new NL80211_CMD_SET_BTCOEX_PRIORITY to support BTCOEX
  mac80211: Add support to enable or disable btcoex
  mac80211: Add support to update btcoex priority value

 include/net/cfg80211.h       |   68 ++++++++++++++++++++++++
 include/net/mac80211.h       |   11 ++++
 include/uapi/linux/nl80211.h |   43 +++++++++++++++
 net/mac80211/cfg.c           |   17 ++++++
 net/mac80211/driver-ops.h    |   26 +++++++++
 net/mac80211/trace.h         |   14 +++++
 net/wireless/nl80211.c       |  119 ++++++++++++++++++++++++++++++++++++++++++
 net/wireless/rdev-ops.h      |   24 +++++++++
 net/wireless/trace.h         |   48 +++++++++++++++++
 9 files changed, 370 insertions(+)

-- 
1.7.9.5
