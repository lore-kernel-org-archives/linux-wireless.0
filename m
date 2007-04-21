Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:45620 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752443AbXDUUbg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Apr 2007 16:31:36 -0400
Message-ID: <462A74A3.3060807@lwfinger.net>
Date: Sat, 21 Apr 2007 15:31:31 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH 0/2 V3] ieee80211: Output frequency and channel in scan results
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Following reviewers suggestions, this patch has been reworked to output both channel and frequency 
in the scan results. This is accomplished in two steps:

(1) A new routine, ieee80211_channel_to_freq, is added to ieee80211. This routine does no 
calculations of frequency, but gets the value stored in the ieee80211_geo struct.

(2) Modify ieee80211_wx to use the new routine.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
