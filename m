Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:33613 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750803AbcHKKcH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Aug 2016 06:32:07 -0400
From: Maxim Altshul <maxim.altshul@ti.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	Maxim Altshul <maxim.altshul@ti.com>
Subject: [PATCH] Add protection to get_expected_throughput opcode
Date: Thu, 11 Aug 2016 13:38:15 +0300
Message-ID: <20160811103816.1695-1-maxim.altshul@ti.com> (sfid-20160811_123210_937253_EC37B847)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The patch is done with respect to the patch that was applied:
[PATCH v3] mac80211: mesh: Add support for HW RC implementation

1. Patch adds protection as we discussed
2. Patch changes the function call that is made in the mesh patch
to comply with the change.

Maxim Altshul (1):
  mac80211: Add protection to get_expected_throughput opcode

 net/mac80211/driver-ops.h | 8 ++++----
 net/mac80211/sta_info.c   | 2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

-- 
2.9.0

