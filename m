Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.188]:25284 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757422AbYAaWFV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Jan 2008 17:05:21 -0500
Received: by nf-out-0910.google.com with SMTP id g13so186023nfb.21
        for <linux-wireless@vger.kernel.org>; Thu, 31 Jan 2008 14:05:20 -0800 (PST)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: IEEE80211_TXCTL_SEND_AFTER_DTIM
Date: Thu, 31 Jan 2008 23:04:58 +0100
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200801312304.58587.IvDoorn@gmail.com> (sfid-20080131_220527_105259_AE8FCB86)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

I have overlooked the following patch when you submitted it to this list:
	mac80211: allow easier multicast/broadcast buffering in hardware

But I have a question about it, the flag IEEE80211_TXCTL_SEND_AFTER_DTIM
indicates that the frame should be send after the beacon because of PS buffering,
but doesn't that mean the same thing as using the queue id:
	IEEE80211_TX_QUEUE_AFTER_BEACON
(Which for rt2x00 resolves to using the ATIM queue...)

Ivo
