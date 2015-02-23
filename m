Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f65.google.com ([209.85.220.65]:36819 "EHLO
	mail-pa0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752345AbbBWN5n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Feb 2015 08:57:43 -0500
Received: by pablf10 with SMTP id lf10so20555240pab.3
        for <linux-wireless@vger.kernel.org>; Mon, 23 Feb 2015 05:57:43 -0800 (PST)
From: Rohan Joyce <rojoyce.github@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 0/1] nl80211: add NL80211_CMD_GET_TSF
Date: Mon, 23 Feb 2015 21:57:11 +0800
Message-Id: <1424699832-19284-1-git-send-email-rojoyce.github@gmail.com> (sfid-20150223_145746_534983_1A96B143)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

This is a followup to the original discussion about having a way to query the
TSF value for a wireless interface from userspace[1]. Rather than using the
sysfs method proposed there, it adds a new command to nl80211. I've tried to
conform to the way in which existing nl80211 commands are written.

[1] http://comments.gmane.org/gmane.linux.kernel.wireless.general/117485

Rohan Joyce (1):
  nl80211: add NL80211_CMD_GET_TSF

 include/net/cfg80211.h       |  6 ++++++
 include/uapi/linux/nl80211.h | 10 ++++++++++
 net/mac80211/cfg.c           | 16 +++++++++++++++
 net/wireless/nl80211.c       | 47 ++++++++++++++++++++++++++++++++++++++++++++
 net/wireless/rdev-ops.h      | 11 +++++++++++
 net/wireless/trace.h         | 18 +++++++++++++++++
 6 files changed, 108 insertions(+)

-- 
2.1.0

