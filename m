Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.net.t-labs.tu-berlin.de ([130.149.220.252]:57600 "EHLO
	mail.net.t-labs.tu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757023Ab3FGSOY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Jun 2013 14:14:24 -0400
From: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, nbd@nbd.name,
	johannes@sipsolutions.net, bvahl@net.t-labs.tu-berlin.de
Subject: [PATCH 0/3] mac80211: restructure tx control flag handling
Date: Fri,  7 Jun 2013 20:13:20 +0200
Message-Id: <1370628803-28785-1-git-send-email-thomas@net.t-labs.tu-berlin.de> (sfid-20130607_201439_573511_E03B1AE3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently all possible bits to assign tx control flags via
ieee80211_tx_info->flags are depleted. This patch series frees 2 bits
in ieee80211_tx_info->flags by shifting possible tx control flags
into a new variable flags2.

Greetings Thomas

[PATCH 1/3] mac80211: restructure tx_control_flag handling in
[PATCH 2/3] mac80211: move flag IEEE80211_TX_CTL_REQ_TX_STATUS from
[PATCH 3/3] mac80211: move flag IEEE80211_TX_CTL_ASSIGN_SEQ from
