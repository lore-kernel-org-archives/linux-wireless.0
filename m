Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:4734 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753554Ab2ISHWf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Sep 2012 03:22:35 -0400
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH v2] Fix for regulatory in 60g
Date: Wed, 19 Sep 2012 10:22:18 +0300
Message-ID: <1348039339-22246-1-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20120919_092239_285590_2CE3418C)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Adjust check for frequency belonging to the same band as regulatory rule

Luis is right, freq_in_rule_band is required to check that we are after
specific band. So, simply fix logic there for the 60GHz

Vladimir Kondratiev (1):
  cfg80211: Fix regulatory check for 60GHz band frequencies

 net/wireless/reg.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

-- 
1.7.9.5

