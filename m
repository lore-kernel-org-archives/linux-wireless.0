Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:53940 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038AbZJWHX6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Oct 2009 03:23:58 -0400
Message-ID: <DFA227DB01A441D8AAD1ABD6291FEC93@yklamPC>
From: "Lam Yoke Khei" <yk.lam@stagetec.com>
To: <linux-wireless@vger.kernel.org>
Subject: mac80211 scan & mlme delay
Date: Fri, 23 Oct 2009 15:23:59 +0800
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

1. I would like to get advice whether the delay value defined in mac80211 
scan.c (IEEE80211_PROBE_DELAY, IEEE80211_CHANNEL_TIME, 
IEEEE80211_PASSIVE_CHANNEL_TIME) and mlme.c (IEEE80211_AUTH_TIMEOUT, 
IEEE80211_ASSOC_TIMEOUT, IEEE80211_MONITORING_INTERVAL, 
IEEE80211_RETRY_AUTH_INTERVAL) can be reduced?

2. What baseline is followed to fix the delay value?

3. Can I say the the delay value increases packet loss during 
re-authentication/re-association?

4. From mac80211 point of view, what causes packet loss during 
re-authentication/re-association?

Thank you and with best regards,
Lam 

