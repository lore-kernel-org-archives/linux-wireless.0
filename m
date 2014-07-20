Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f50.google.com ([74.125.82.50]:50234 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699AbaGTMci (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Jul 2014 08:32:38 -0400
Received: by mail-wg0-f50.google.com with SMTP id n12so5277541wgh.33
        for <linux-wireless@vger.kernel.org>; Sun, 20 Jul 2014 05:32:37 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Philippe Duchein <wireless-dev@duchein.net>
Subject: [PATCH 0/2] configure ack timeout estimation algorithm through
Date: Sun, 20 Jul 2014 14:32:33 +0200
Message-Id: <1405859555-31806-1-git-send-email-lorenzo.bianconi83@gmail.com> (sfid-20140720_145108_025994_FBC1F2D2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Define enable_dynack API to enable ack timeout estimation algorithm (dynack)
through nl80211. Currently dynack is supported just by ath9k

Lorenzo Bianconi (2):
  cfg80211: add enable_dynack API
  mac80211: add enable_dynack API

 include/net/cfg80211.h       |  4 ++++
 include/net/mac80211.h       |  4 ++++
 include/uapi/linux/nl80211.h |  5 +++++
 net/mac80211/cfg.c           |  8 ++++++++
 net/mac80211/driver-ops.h    | 14 ++++++++++++++
 net/mac80211/trace.h         |  5 +++++
 net/wireless/nl80211.c       |  7 +++++++
 net/wireless/rdev-ops.h      | 11 +++++++++++
 net/wireless/trace.h         |  5 +++++
 9 files changed, 63 insertions(+)

-- 
1.9.1

