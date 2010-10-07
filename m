Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:32976 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760536Ab0JGNEd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Oct 2010 09:04:33 -0400
From: Shahar Levi <shahar_levi@ti.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <luciano.coelho@nokia.com>
Subject: [PATCH 00/03] wl1271: BA Initiator support
Date: Thu,  7 Oct 2010 15:05:59 +0200
Message-Id: <1286456762-17480-1-git-send-email-shahar_levi@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Series that add 80211n BA initiator session support wl1271 driver. BA initiator 
session management included in FW independently.
BA receiver session not supported in that Series.

Dependencies:
- BA Initiator patches have a runtime dependency on
  commit "[PATCH v2] wl1271: 11n Support" series (patches is in linux-wireless
  mailing list)

Limitation:
- For now only TID0 supported (Beast Effort).

Thanks,
Shahar

Shahar Levi (3):
  wl1271: BA Initiator support, Add Definitions
  wl1271: BA Initiator support, BA functions
  wl1271: BA Initiator support, active BA ability

 drivers/net/wireless/wl12xx/wl1271_acx.c  |   51 +++++++++++++++++++++++++++
 drivers/net/wireless/wl12xx/wl1271_acx.h  |   20 +++++++++++
 drivers/net/wireless/wl12xx/wl1271_conf.h |    3 ++
 drivers/net/wireless/wl12xx/wl1271_main.c |   54 ++++++++++++++++++++++++++++-
 4 files changed, 127 insertions(+), 1 deletions(-)

