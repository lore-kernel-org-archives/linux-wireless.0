Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:52027 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754281Ab2GJRY6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jul 2012 13:24:58 -0400
Cc: <linux-wireless@vger.kernel.org>, <kvalo@qca.qualcomm.com>,
	<arend@broadcom.com>, <henry@logout.com>,
	<senthilb@qca.qualcomm.com>,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
To: <johannes@sipsolutions.net>, <linville@tuxdriver.com>
Subject: [PATCH v4 0/2] wireless: onus driver updates
Date: Tue, 10 Jul 2012 10:24:52 -0700
Message-ID: <1341941094-11279-1-git-send-email-rodrigue@qca.qualcomm.com> (sfid-20120710_192503_123632_C554D197)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>

John, this depends on the v4 series of onus / cell base
station hints. This v4 has no changes but I am sending
it just to clarify its dependency and so you can ignore
the older v3 series.

Luis R. Rodriguez (2):
  ath5k: replace modparam_all_channels with CONFIG_ATH5K_TEST_CHANNELS
  ath9k: make CONFIG_ATH9K_DFS_CERTIFIED depend on
    CFG80211_CERTIFICATION_ONUS

 drivers/net/wireless/ath/ath5k/Kconfig |    8 ++++++++
 drivers/net/wireless/ath/ath5k/base.c  |   17 ++++++++++-------
 drivers/net/wireless/ath/ath9k/Kconfig |    2 +-
 3 files changed, 19 insertions(+), 8 deletions(-)

-- 
1.7.10.rc1.22.gf5241

