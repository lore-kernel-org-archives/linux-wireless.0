Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f52.google.com ([209.85.210.52]:58860 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753531Ab2DLVcg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Apr 2012 17:32:36 -0400
Received: by dake40 with SMTP id e40so2999487dak.11
        for <linux-wireless@vger.kernel.org>; Thu, 12 Apr 2012 14:32:35 -0700 (PDT)
From: Javier Cardona <javier@cozybit.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Javier Cardona <javier@cozybit.com>,
	Marco Porsch <marco.porsch@s2005.tu-chemnitz.de>,
	Pavel Zubarev <pavel.zubarev@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	devel@lists.open80211s.org, ashok@cozybit.com,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH 0/4] Mesh sync fixes
Date: Thu, 12 Apr 2012 14:32:19 -0700
Message-Id: <1334266343-3970-1-git-send-email-javier@cozybit.com> (sfid-20120412_233240_002279_A8D362C3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We noticed these while testing mesh synchronization.

Javier Cardona (4):
  mac80211: Set the correct values for hwmp (1) and airtimeLinkMetric
    (1)
  mac80211_hwsim: fixup for tsf setting
  mac80211: Choose a new toffset setpoint if a big tsf jump is
    detected.
  mac80211: Take into account TSF adjustment latency in Toffset
    setpoint

 drivers/net/wireless/mac80211_hwsim.c |    1 +
 include/linux/ieee80211.h             |    4 ++--
 net/mac80211/mesh_sync.c              |   32 ++++++++++++++++++++++++++------
 3 files changed, 29 insertions(+), 8 deletions(-)

-- 
1.7.5.4

