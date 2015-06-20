Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:36050 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753604AbbFTSds (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Jun 2015 14:33:48 -0400
Received: by wicnd19 with SMTP id nd19so44234805wic.1
        for <linux-wireless@vger.kernel.org>; Sat, 20 Jun 2015 11:33:46 -0700 (PDT)
Received: from [192.168.178.34] (ip-95-223-84-79.hsi16.unitymediagroup.de. [95.223.84.79])
        by mx.google.com with ESMTPSA id cd9sm22478408wjc.34.2015.06.20.11.33.45
        for <linux-wireless@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 20 Jun 2015 11:33:46 -0700 (PDT)
Message-ID: <5585B209.3040406@gmail.com> (sfid-20150620_203351_628480_DE645477)
Date: Sat, 20 Jun 2015 20:33:45 +0200
From: Blue Glacier <blueglacier414@gmail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: "No association and the time event is over already..."
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

my Intel Wireless 7265 chip suddenly stopped working. The Network 
Manager shows that I am connected, but I cannot even ping to my home 
router. I didn't change anything on my system.

The output of dmesg looks interesting:

[  507.737606] wlan0: Connection to AP c0:25:06:ce:d2:e9 lost
[  507.806070] cfg80211: Calling CRDA for country: DE
[  508.379770] cfg80211: Calling CRDA for country: DE
[  511.332818] wlan0: authenticate with c0:25:06:ce:d2:e9
[  511.338625] wlan0: send auth to c0:25:06:ce:d2:e9 (try 1/3)
[  511.341600] wlan0: authenticated
[  511.343813] wlan0: associate with c0:25:06:ce:d2:e9 (try 1/3)
[  511.350128] wlan0: RX AssocResp from c0:25:06:ce:d2:e9 (capab=0x431 
status=0 aid=8)
[  511.353700] wlan0: associated
[  511.645582] iwlwifi 0000:03:00.0: No association and the time event 
is over already...
[  511.645642] wlan0: Connection to AP c0:25:06:ce:d2:e9 lost
[  511.688174] cfg80211: Calling CRDA to update world regulatory domain

(repeated numerous times)

I am using Debian 8 Jessie (stable) together with the firmware from your 
server (iwlwifi-7265-9.ucode). The Kernel Version is 3.16.0-4-amd64.

Any idea how to fix this?

Jens
--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
