Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f182.google.com ([209.85.214.182]:50519 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962AbaALVLu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 Jan 2014 16:11:50 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	netdev@vger.kernel.org
Subject: [PATCH 0/3 V2] iFixes for b43 and b43legacy
Date: Sun, 12 Jan 2014 15:11:36 -0600
Message-Id: <1389561099-17181-1-git-send-email-Larry.Finger@lwfinger.net> (sfid-20140112_221159_557990_F2F5519D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These 3 fixes should be applied as soon as possible. I understand that 3.13
will be released soon. As all 3 are marked for stable, inclusion in 3.14
will be satisfactory.

V2 - Patch 1 is unchanged, but 2 and 3 are fixed to remove any race conditions.

Larry


Larry Finger (3):
  b43: Fix lockdep splat
  b43: Fix unload oops if firmware is not available
  b43legacy: Fix unload oops if firmware is not available

 drivers/net/wireless/b43/b43.h        |  4 ++--
 drivers/net/wireless/b43/main.c       | 27 ++++++++++++++++-----------
 drivers/net/wireless/b43legacy/main.c |  1 +
 3 files changed, 19 insertions(+), 13 deletions(-)

-- 
1.8.4

