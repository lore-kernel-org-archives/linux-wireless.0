Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:32847 "EHLO
	mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751057AbcBJQbU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Feb 2016 11:31:20 -0500
Received: by mail-wm0-f45.google.com with SMTP id g62so34402342wme.0
        for <linux-wireless@vger.kernel.org>; Wed, 10 Feb 2016 08:31:20 -0800 (PST)
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>
Subject: [RFC 0/2] add VHT radiotap parsing support to mac80211
Date: Wed, 10 Feb 2016 17:31:15 +0100
Message-Id: <1455121877-7238-1-git-send-email-lorenzo.bianconi83@gmail.com> (sfid-20160210_173124_230568_926DBFC2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Lorenzo Bianconi (2):
  cfg80211: add radiotap VHT info to rtap_namespace_sizes
  mac80211: parse VHT info in injected frames

 Documentation/networking/mac80211-injection.txt | 10 ++++++++
 net/mac80211/tx.c                               | 31 +++++++++++++++++++++++++
 net/wireless/radiotap.c                         |  1 +
 3 files changed, 42 insertions(+)

-- 
2.5.0

