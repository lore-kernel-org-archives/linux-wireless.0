Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f49.google.com ([209.85.219.49]:49305 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754091AbaAKTsm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Jan 2014 14:48:42 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	netdev@vger.kernel.org
Subject: [PATCH 0/3] Fixes for b43 and b43legacy
Date: Sat, 11 Jan 2014 13:48:31 -0600
Message-Id: <1389469714-13040-1-git-send-email-Larry.Finger@lwfinger.net> (sfid-20140111_204848_022733_3973DBE1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These 3 fixes should be applied as soon as possible. I understand that 3.13
will be released soon. As all 3 are marked for stable, inclusion in 3.14
will be satisfactory.

Larry
 

Larry Finger (3):
  b43: Fix lockdep splat
  b43: Fix oops if firmware is not available
  b43legacy: Fix oops if firmware is not available

 drivers/net/wireless/b43/main.c       | 24 +++++++++++++++---------
 drivers/net/wireless/b43legacy/main.c |  5 +++--
 2 files changed, 18 insertions(+), 11 deletions(-)

-- 
1.8.4

