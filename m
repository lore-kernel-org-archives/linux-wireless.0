Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:51730 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779AbaGTMdx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Jul 2014 08:33:53 -0400
Received: by mail-wg0-f44.google.com with SMTP id m15so5251942wgh.3
        for <linux-wireless@vger.kernel.org>; Sun, 20 Jul 2014 05:33:52 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Philippe Duchein <wireless-dev@duchein.net>
Subject: [PATCH 0/2] add auto parameter to set distance command
Date: Sun, 20 Jul 2014 14:33:47 +0200
Message-Id: <1405859629-32326-1-git-send-email-lorenzo.bianconi83@gmail.com> (sfid-20140720_143356_883226_D1083E6D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add auto parameter to set distance command in order to enable ack timeout
estimation algorithm (dynack). Currently dynack is supported just by ath9k

This patchset is based on "configure ack timeout estimation algorithm through
mac80211 stack" one sent on linux-wireless

Lorenzo Bianconi (2):
  iw: sync nl80211_attrs
  iw: add auto parameter to set distance command

 nl80211.h | 10 ++++++++++
 phy.c     | 44 +++++++++++++++++++++++++-------------------
 2 files changed, 35 insertions(+), 19 deletions(-)

-- 
1.9.1

