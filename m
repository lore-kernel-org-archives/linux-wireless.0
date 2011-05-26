Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2866 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752228Ab1EZO31 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 May 2011 10:29:27 -0400
Message-ID: <4DDE63B4.4030309@broadcom.com> (sfid-20110526_162951_088182_EADED082)
Date: Thu, 26 May 2011 16:29:08 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
cc: "gregkh@suse.de" <gregkh@suse.de>
Subject: %d in wlan log messages
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[  563.120590] wlan%d: authenticate with c0:c1:c0:04:b8:2c (try 1)
[  563.128143] wlan%d: authenticated
[  563.131517] wlan%d: associate with c0:c1:c0:04:b8:2c (try 1)
[  563.140933] wlan%d: RX AssocResp from c0:c1:c0:04:b8:2c (capab=0x411 
status=0 aid=4)
[  563.148714] wlan%d: associated
[  563.177019] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready

On latest staging-next I noticed above mentioned log messages. I assume 
these message are from cfg80211 or mac80211. Has this been reported?

Gr. AvS

-- 
Almost nobody dances sober, unless they happen to be insane.
-- H.P. Lovecraft --


