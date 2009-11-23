Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpm-eml101.kpnxchange.com ([195.121.3.5]:58408 "EHLO
	CPSMTPM-EML101.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752758AbZKWVo4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Nov 2009 16:44:56 -0500
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org
Cc: Ivo van Doorn <ivdoorn@gmail.com>
Subject: [PATCH v2 0/8] Assorted fixes and cleanups for rt2x00 and mac80211.
Date: Mon, 23 Nov 2009 22:44:46 +0100
Message-Id: <1259012694-14869-1-git-send-email-gwingerde@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The following patch series contains a list of fixes and cleanups for rt2x00.
Also included is a fix for mac80211 that fixes the insufficient headroom
bug reported by David Ellingsworth.

v2:
Handle review comments from Julian, Johannes and Ivo.
Split up patch 5 of first version in 3 different parts.

	[PATCH v2 1/8] rt2x00: Only initialize HT on rt2800 devices that support it.
	[PATCH v2 2/8] rt2x00: Remove unused variable frame_control from rt2x00mac_tx.
	[PATCH v2 3/8] rt2x00: Clean up use of rt2x00_intf_is_pci.
	[PATCH v2 4/8] rt2x00: Fix typo (lengt --> length) in rt2x00queue.c
	[PATCH v2 5/8] rt2x00: Whitespace cleanup.
	[PATCH v2 6/8] rt2x00: Centralize setting of extra TX headroom requested by rt2x00.
	[PATCH v2 7/8] mac80211: Add define for TX headroom reserved by mac80211 itself.
	[PATCH v2 8/8] rt2x00: Properly request tx headroom for alignment operations.

---
Gertjan.
