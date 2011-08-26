Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:50110 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754462Ab1HZJLD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Aug 2011 05:11:03 -0400
Received: by pzk37 with SMTP id 37so3943292pzk.1
        for <linux-wireless@vger.kernel.org>; Fri, 26 Aug 2011 02:11:02 -0700 (PDT)
Subject: can't understand the process of RX
From: pangyunong <029012@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 26 Aug 2011 17:09:54 +0800
Message-ID: <1314349794.3030.15.camel@Yunong> (sfid-20110826_111116_675659_1229D6DB)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all, 
  I have some difficulty to understand the RX process in ath9k and
mac80211, I wonder if you can explain me some or tell me which mail list
should I ask to. 


----------------By the mac80211 overview--------------------------------
• packet received by driver
• passed to mac80211’s rx function (ieee80211_rx) with
rx status info

for each interface that the packet might belong to
        • RX handlers are invoked
        • data: converted to 802.3, delivered to networking stack
        • management: delivered to MLME
------------------------------------------------------------------------

My question is which function actually identifies the types of frame and
transmit to RX, data handler and MLME.


Yunong Pang
Regards,



