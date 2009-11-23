Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpm-eml102.kpnxchange.com ([195.121.3.6]:50531 "EHLO
	CPSMTPM-EML102.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752544AbZKWHQL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Nov 2009 02:16:11 -0500
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org
Cc: Ivo van Doorn <ivdoorn@gmail.com>
Subject: [PATCH 0/6] Assorted fixes and cleanups for rt2x00 and mac80211.
Date: Mon, 23 Nov 2009 08:15:59 +0100
Message-Id: <1258960565-26736-1-git-send-email-gwingerde@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The following patch series contains a list of fixes and cleanups for rt2x00.
Also included is a fix for mac80211 that fixes the insufficient headroom
bug reported by David Ellingsworth.

	[PATCH 1/6] rt2x00: Only initialize HT on rt2800 devices that support it.
	[PATCH 2/6] rt2x00: Remove unused variable frame_control from rt2x00mac_tx.
	[PATCH 3/6] rt2x00: Clean up use of rt2x00_intf_is_pci.
	[PATCH 4/6] rt2x00: Fix typo (lengt --> length) in rt2x00queue.c
	[PATCH 5/6] rt2x00: Properly request tx headroom for alignment operations.
	[PATCH 6/6] mac80211: Allow extra TX headroom to be consumed by drivers.

---
Gertjan.
