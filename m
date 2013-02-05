Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:45316 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755045Ab3BEPl7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Feb 2013 10:41:59 -0500
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH 0/2] iw: prefer 64-bit byte counters
Date: Tue, 5 Feb 2013 17:41:42 +0200
Message-ID: <1360078904-13056-1-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20130205_164203_103830_DC29FD28)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use 64-bit counters in iw.

Vladimir Kondratiev (2):
  iw: sync nl80211.h with kernel
  iw: prefer 64-bit byte counters for sta_info

 link.c    |   14 ++++++-
 nl80211.h |  127 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++---
 station.c |   12 +++++-
 3 files changed, 144 insertions(+), 9 deletions(-)

-- 
1.7.10.4

