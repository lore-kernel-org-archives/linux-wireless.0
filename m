Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:54144 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751776Ab2KTJEL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Nov 2012 04:04:11 -0500
Received: from dlelxv30.itg.ti.com ([172.17.2.17])
	by bear.ext.ti.com (8.13.7/8.13.7) with ESMTP id qAK94A72031384
	for <linux-wireless@vger.kernel.org>; Tue, 20 Nov 2012 03:04:10 -0600
Received: from DLEE74.ent.ti.com (dlee74.ent.ti.com [157.170.170.8])
	by dlelxv30.itg.ti.com (8.13.8/8.13.8) with ESMTP id qAK94A3G030567
	for <linux-wireless@vger.kernel.org>; Tue, 20 Nov 2012 03:04:10 -0600
From: Luciano Coelho <coelho@ti.com>
To: <coelho@ti.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 0/2] wlcore: a couple of small clean-ups
Date: Tue, 20 Nov 2012 11:03:30 +0200
Message-ID: <1353402212-20439-1-git-send-email-coelho@ti.com> (sfid-20121120_100418_991940_8D9CD7E3)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Just a couple of patches cleaning up things I bumped into.

Luca.

Luciano Coelho (2):
  wlcore: avoid using goto in normal code flow
  wlcore: remove a bunch of unnecessary parentheses

 drivers/net/wireless/ti/wlcore/main.c |   37 +++++++++++++++++----------------
 1 file changed, 19 insertions(+), 18 deletions(-)

-- 
1.7.10.4

