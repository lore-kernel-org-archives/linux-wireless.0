Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f50.google.com ([74.125.82.50]:48458 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759288AbaGXKjy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jul 2014 06:39:54 -0400
Received: by mail-wg0-f50.google.com with SMTP id n12so2424257wgh.21
        for <linux-wireless@vger.kernel.org>; Thu, 24 Jul 2014 03:39:51 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Philippe Duchein <wireless-dev@duchein.net>
Subject: [PATCHv2 0/2] add auto parameter to set distance command
Date: Thu, 24 Jul 2014 12:39:46 +0200
Message-Id: <1406198388-5040-1-git-send-email-lorenzo.bianconi83@gmail.com> (sfid-20140724_123958_557897_34F839D9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add auto parameter to set distance command in order to enable ack timeout
estimation algorithm (dynack). Currently dynack is supported just by ath9k

This patchset is based on "configure ack timeout estimation algorithm through
mac80211 stack" one sent on linux-wireless

Changes since v1:
- add dynack info to info command

Lorenzo Bianconi (2):
  iw: sync nl80211_attrs
  iw: add auto parameter to set distance command

 info.c    | 16 +++++++++++-----
 nl80211.h | 10 ++++++++++
 phy.c     | 44 +++++++++++++++++++++++++-------------------
 3 files changed, 46 insertions(+), 24 deletions(-)

-- 
1.9.1

