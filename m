Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0107.hostedemail.com ([216.40.44.107]:37766 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750834AbaENTPT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 May 2014 15:15:19 -0400
From: Joe Perches <joe@perches.com>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: [PATCH 0/2] drivers/net: Remove trailing semicolons from do {...} while 0 macros
Date: Wed, 14 May 2014 12:15:12 -0700
Message-Id: <cover.1400094804.git.joe@perches.com> (sfid-20140514_211631_341052_3CC4FDF1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Joe Perches (2):
  ti: Remove trailing semicolon from do {...} while (0) macro
  wlcore: Remove trailing semicolon from do {...} while (0) macro

 drivers/net/ethernet/ti/cpsw.c           | 4 ++--
 drivers/net/wireless/ti/wlcore/debugfs.h | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

-- 
1.8.1.2.459.gbcd45b4.dirty

