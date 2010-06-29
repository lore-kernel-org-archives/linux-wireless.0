Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx04.teleca.com ([212.92.145.6]:34031 "EHLO mx04.teleca.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755303Ab0F2Kux (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jun 2010 06:50:53 -0400
From: Yuri Ershov <ext-yuri.ershov@nokia.com>
To: johannes@sipsolutions.net
Cc: ext-yuri.kululin@nokia.com, linux-wireless@vger.kernel.org
Subject: [RFC 0/3] Update for some defects
Date: Tue, 29 Jun 2010 15:08:05 +0400
Message-Id: <cover.1277808543.git.ext-yuri.ershov@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

These are some proposals for wireless code minor defects. 

Yuri Ershov (3):
  mac80211: Put some code under MESH macro
  nl80211: Fix memory leaks
  cfg80211: Update of regulatory request initiator handling

 net/mac80211/tx.c      |    2 ++
 net/wireless/nl80211.c |    2 ++
 net/wireless/reg.c     |    3 ++-
 3 files changed, 6 insertions(+), 1 deletions(-)

