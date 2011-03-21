Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:7621 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753131Ab1CUViO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Mar 2011 17:38:14 -0400
Received: from kpbe19.cbf.corp.google.com (kpbe19.cbf.corp.google.com [172.25.105.83])
	by smtp-out.google.com with ESMTP id p2LLcD6x006099
	for <linux-wireless@vger.kernel.org>; Mon, 21 Mar 2011 14:38:13 -0700
Received: from glenhelen.mtv.corp.google.com (glenhelen.mtv.corp.google.com [172.22.72.223])
	by kpbe19.cbf.corp.google.com with ESMTP id p2LLcCCe015357
	for <linux-wireless@vger.kernel.org>; Mon, 21 Mar 2011 14:38:12 -0700
From: Paul Stewart <pstew@google.com>
Date: Mon, 21 Mar 2011 14:32:59 -0700
Subject: [PATCH 0/4] Add station BSS parameters to station
To: linux-wireless@vger.kernel.org
Message-Id: <20110321213812.76CD420891@glenhelen.mtv.corp.google.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This allows user-space monitoring of BSS parameters for the associated
station.  This is useful for debugging and verifying that the paramaters
are as expected.

Paul Stewart (4):
  nl80211: Add station info flags and intervals
  cfg80211: Add station info to station struct
  nl80211: Add bss info to station message
  mac80211: Add bss info to that exported to station

 include/linux/nl80211.h |   35 ++++++++++++++++++++++++++++++++++-
 include/net/cfg80211.h  |   34 ++++++++++++++++++++++++++++++++++
 net/mac80211/cfg.c      |   13 ++++++++++++-
 net/wireless/nl80211.c  |   21 ++++++++++++++++++++-
 4 files changed, 100 insertions(+), 3 deletions(-)

-- 
1.7.3.1

