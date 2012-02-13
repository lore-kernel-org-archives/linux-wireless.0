Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44708 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751634Ab2BMKXs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Feb 2012 05:23:48 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 00/24] iwlegacy update 2012-02-13
Date: Mon, 13 Feb 2012 11:23:07 +0100
Message-Id: <1329128611-6815-1-git-send-email-sgruszka@redhat.com> (sfid-20120213_112352_683768_D3392C47)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Further cleanups and some debugging improvements.

 drivers/net/wireless/iwlegacy/3945-debug.c |    6 
 drivers/net/wireless/iwlegacy/3945-mac.c   |  108 ++---
 drivers/net/wireless/iwlegacy/3945.c       |  133 ++----
 drivers/net/wireless/iwlegacy/3945.h       |    8 
 drivers/net/wireless/iwlegacy/4965-calib.c |    4 
 drivers/net/wireless/iwlegacy/4965-debug.c |    6 
 drivers/net/wireless/iwlegacy/4965-mac.c   |  589 +++++++++++++++++++++--------
 drivers/net/wireless/iwlegacy/4965.c       |  402 +------------------
 drivers/net/wireless/iwlegacy/4965.h       |   20 
 drivers/net/wireless/iwlegacy/common.c     |  548 +++++++-------------------
 drivers/net/wireless/iwlegacy/common.h     |  224 +++--------
 drivers/net/wireless/iwlegacy/debug.c      |  260 +++++++-----
 12 files changed, 956 insertions(+), 1352 deletions(-)

