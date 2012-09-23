Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:35868 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752066Ab2IWHuH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Sep 2012 03:50:07 -0400
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH v3] Fix for regulatory in 60g
Date: Sun, 23 Sep 2012 09:49:53 +0200
Message-ID: <1348386594-6067-1-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20120923_095057_289560_67756212)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I borrowed comment log from Luis (Thanks for this!)
and added explanation for the DMG abbreviation.
Also, "4GHz" instead of 10 in the comment was mistake, fixed.

Vladimir Kondratiev (1):
  cfg80211: Fix regulatory check for 60GHz band frequencies

 net/wireless/reg.c |   19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

-- 
1.7.9.5

