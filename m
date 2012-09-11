Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:7042 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758851Ab2IKLwd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Sep 2012 07:52:33 -0400
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH v1] Fix for regulatory in 60g
Date: Tue, 11 Sep 2012 14:52:08 +0300
Message-ID: <1347364329-19443-1-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20120911_135236_654164_D63C5379)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Another bit in 60g band support.

If possible, this is bug fix intended for 3.6

Vladimir Kondratiev (1):
  cfg80211: Fix regulatory check for 60GHz band frequencies

 net/wireless/reg.c |   54 ++++++----------------------------------------------
 1 file changed, 6 insertions(+), 48 deletions(-)

-- 
1.7.9.5

