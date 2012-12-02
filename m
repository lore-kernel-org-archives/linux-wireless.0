Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:53248 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751846Ab2LBOxd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Dec 2012 09:53:33 -0500
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 0/2] rt2x00: rt2800lib: indentation fixes
Date: Sun,  2 Dec 2012 15:53:27 +0100
Message-Id: <1354460009-28449-1-git-send-email-juhosg@openwrt.org> (sfid-20121202_155340_394873_C5BBD5CF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The following two patches contain some indentation fixes for rt2800lib.

Gabor Juhos (2):
  rt2x00: rt2800lib: fix indentation of some rt2x00_rt calls
  rt2x00: rt2800lib: fix indentation in rt2800_init_rfcsr

 drivers/net/wireless/rt2x00/rt2800lib.c |  138 +++++++++++++++----------------
 1 file changed, 69 insertions(+), 69 deletions(-)

-- 
1.7.10

