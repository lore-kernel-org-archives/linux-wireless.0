Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:46932 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767AbaIXEhO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Sep 2014 00:37:14 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@qca.qualcomm.com
Subject: [RFC 0/4] ath9k patches
Date: Wed, 24 Sep 2014 10:07:28 +0530
Message-Id: <1411533452-22921-1-git-send-email-sujith@msujith.org> (sfid-20140924_063719_797726_FB6AF1AE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

MCC fixes. Please review !

Sujith Manoharan (4):
  ath9k: Fix queue management
  ath9k: Use normal queues for offchannel frames
  ath9k: Fix force_channel usage for offchannel frames
  ath9k: Fix offchannel queuing

 drivers/net/wireless/ath/ath9k/xmit.c | 20 ++++++--------------
 1 file changed, 6 insertions(+), 14 deletions(-)

-- 
2.1.0

