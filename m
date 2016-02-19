Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:34040 "EHLO
	mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992783AbcBSKnJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Feb 2016 05:43:09 -0500
Received: by mail-wm0-f65.google.com with SMTP id b205so7291078wmb.1
        for <linux-wireless@vger.kernel.org>; Fri, 19 Feb 2016 02:43:08 -0800 (PST)
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH v2 0/2] add VHT radiotap parsing support to mac80211
Date: Fri, 19 Feb 2016 11:43:03 +0100
Message-Id: <1455878585-5525-1-git-send-email-lorenzo.bianconi83@gmail.com> (sfid-20160219_114317_891357_894F6534)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Changelog:

v2: 
- added cfg80211 patch to the patchset 

Lorenzo Bianconi (2):
  cfg80211: add radiotap VHT info to rtap_namespace_sizes
  mac80211: parse VHT info in injected frames

 Documentation/networking/mac80211-injection.txt | 10 ++++++++
 net/mac80211/tx.c                               | 31 +++++++++++++++++++++++++
 net/wireless/radiotap.c                         |  1 +
 3 files changed, 42 insertions(+)

-- 
2.5.0

