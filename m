Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:32785 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750771Ab2LSTAa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Dec 2012 14:00:30 -0500
Received: by mail-pa0-f47.google.com with SMTP id fa10so1513866pad.34
        for <linux-wireless@vger.kernel.org>; Wed, 19 Dec 2012 11:00:29 -0800 (PST)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: johannes@sipsolutions.net, greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 0/3] cfg80211: few regulatory beacon hint enhancements
Date: Wed, 19 Dec 2012 10:53:01 -0800
Message-Id: <1355943184-966-1-git-send-email-mcgrof@do-not-panic.com> (sfid-20121219_200033_965673_F9A47126)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>

Johannes, these now go tested by Ben, please merge.

Luis R. Rodriguez (3):
  cfg80211: do not process beacon hints if one is already queued
  cfg80211: move reg_is_world_roaming()
  cfg80211: move world roaming check for beacon hints

 net/wireless/reg.c |   48 ++++++++++++++++++++++++++++++++++--------------
 1 file changed, 34 insertions(+), 14 deletions(-)

-- 
1.7.10.4

