Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56845 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762420AbYF3NO6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jun 2008 09:14:58 -0400
Message-Id: <20080630131043.136595000@sipsolutions.net> (sfid-20080630_151516_844468_1FFEBB94)
Date: Mon, 30 Jun 2008 15:10:43 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 0/3] mac80211 updates
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patchset contains the TX/RX handler inlining and the printk and
debugging rework that depends on those, rebased after the TKIP kconfig
rename.

johannes

