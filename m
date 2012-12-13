Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52113 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757083Ab2LMU3A (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2012 15:29:00 -0500
Received: by mail-pb0-f46.google.com with SMTP id wy7so1815582pbc.19
        for <linux-wireless@vger.kernel.org>; Thu, 13 Dec 2012 12:28:59 -0800 (PST)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: johannes@sipsolutions.net, greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [RFT 0/3] cfg80211: beacon hint improvements
Date: Thu, 13 Dec 2012 12:28:51 -0800
Message-Id: <1355430534-7881-1-git-send-email-mcgrof@do-not-panic.com> (sfid-20121213_213028_083091_F4BBB13F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>

Just a few improvements for beacon hint processing due to
scheduling considerations and discovered by Ben with a lot of
stations. For details see:

http://article.gmane.org/gmane.linux.kernel.wireless.general/101482

Luis R. Rodriguez (3):
  cfg80211: do not process beacon hints if one is already queued
  cfg80211: move reg_is_world_roaming()
  cfg80211: move world roaming check for beacon hints

 net/wireless/reg.c |   48 ++++++++++++++++++++++++++++++++++--------------
 1 file changed, 34 insertions(+), 14 deletions(-)

-- 
1.7.10.4

