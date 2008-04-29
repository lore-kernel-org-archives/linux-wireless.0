Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:50560 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755930AbYD3OHF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Apr 2008 10:07:05 -0400
Message-Id: <20080429151858.253229000@sipsolutions.net> (sfid-20080430_160702_436241_F6965B76)
Date: Tue, 29 Apr 2008 17:18:58 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 0/3] mac80211 QoS related changes
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series does a few cleanups to mac80211's QoS code.
It contains:
 * clean up get_tx_stats callback
 * remove queue info from ieee80211_tx_status
 * QoS related cleanups

johannes
