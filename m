Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:41842 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105Ab3J2WjK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Oct 2013 18:39:10 -0400
Received: by mail-wg0-f52.google.com with SMTP id k14so541793wgh.19
        for <linux-wireless@vger.kernel.org>; Tue, 29 Oct 2013 15:39:09 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 0/3] ath: a few enhancements for dynamic user selection
Date: Tue, 29 Oct 2013 23:39:03 +0100
Message-Id: <1383086346-2096-1-git-send-email-mcgrof@do-not-panic.com> (sfid-20131029_233915_057081_76828BDE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John, Johannes,

here's a few enhancements for the dynamic user selection stuff.
I think this will depend on application on the no-ir flag patches
so not sure what route to go.

Luis R. Rodriguez (3):
  ath: move dynamic_country_user_possible() to the top
  ath: dynamic user allow check helper to the top
  ath: fix dynamic user regulatory domain support

 drivers/net/wireless/ath/regd.c | 193 +++++++++++++++++++++-------------------
 1 file changed, 103 insertions(+), 90 deletions(-)

-- 
1.8.4.rc3

