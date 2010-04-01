Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:25250 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752837Ab0DAIis (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Apr 2010 04:38:48 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 0/8] wl1271: patches of the week
Date: Thu,  1 Apr 2010 11:38:16 +0300
Message-Id: <1270111104-29549-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

We have a few more patches to be applied upstream.  These patches have just
been added to our internal tree, so they're as hot as we can make them at the
moment. ;)

Please apply them.

And, no, it's not an April Fool's joke that I'm sending a smaller and more
recent bunch this time! :D

Cheers,
Luca.

Juuso Oikarinen (6):
  wl1271: Fix keep-alive related command error
  wl1271: Use minimum rate for each band for control messages
  wl1271: Configure rates for templates
  wl1271: Configure a higher listen interval to AP upon association
  wl1271: Fix debug prints for beacon-loss and psm-entry-fail scenarios
  wl1271: Fix tx queue flushing

Luciano Coelho (2):
  wl1271: fix sdio driver name in wl1271_sdio_driver
  wl1271: added missing command header in wl1271_cmd_disconnect

 drivers/net/wireless/wl12xx/wl1271.h       |    1 +
 drivers/net/wireless/wl12xx/wl1271_acx.c   |    2 +-
 drivers/net/wireless/wl12xx/wl1271_cmd.c   |   48 ++++++------
 drivers/net/wireless/wl12xx/wl1271_cmd.h   |    6 +-
 drivers/net/wireless/wl12xx/wl1271_conf.h  |   20 +++++
 drivers/net/wireless/wl12xx/wl1271_event.c |    4 +-
 drivers/net/wireless/wl12xx/wl1271_init.c  |   18 +++--
 drivers/net/wireless/wl12xx/wl1271_main.c  |  122 +++++++++++++++++++++++-----
 drivers/net/wireless/wl12xx/wl1271_sdio.c  |    2 +-
 drivers/net/wireless/wl12xx/wl1271_tx.c    |   20 +----
 drivers/net/wireless/wl12xx/wl1271_tx.h    |    1 +
 11 files changed, 167 insertions(+), 77 deletions(-)

