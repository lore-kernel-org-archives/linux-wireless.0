Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp2-g21.free.fr ([212.27.42.2]:48199 "EHLO smtp2-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754455AbZLDUUu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Dec 2009 15:20:50 -0500
Received: from smtp2-g21.free.fr (localhost [127.0.0.1])
	by smtp2-g21.free.fr (Postfix) with ESMTP id 0AA464B00E6
	for <linux-wireless@vger.kernel.org>; Fri,  4 Dec 2009 21:20:51 +0100 (CET)
Received: from [192.168.1.189] (cac94-1-81-57-151-96.fbx.proxad.net [81.57.151.96])
	by smtp2-g21.free.fr (Postfix) with ESMTP id 16A644B00FD
	for <linux-wireless@vger.kernel.org>; Fri,  4 Dec 2009 21:20:49 +0100 (CET)
Message-ID: <4B196F20.2020005@free.fr>
Date: Fri, 04 Dec 2009 21:20:48 +0100
From: matthieu castet <castet.matthieu@free.fr>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: status of rt2870 support
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I downloaded the compat-wireless-2009-12-03 and tried it on my d-link rt2870 usb dongle.

After doing a ifconfig up, I start a scaning.
And the scaning show weird stuff :
- there is lot's of "IE: Unknown". [1]
- not all AP are showed. Even those with very good signal.

Is that normal ?


Matthieu

[1]
          Cell 03 - Address: 0E:58:1C:E3:D7:BA
                    Channel:10
                    Frequency:2.457 GHz (Channel 10)
                    Quality=70/70  Signal level=35 dBm  
                    Encryption key:off
                    ESSID:"FreeWifi"
                    Bit Rates:1 Mb/s; 2 Mb/s; 5.5 Mb/s; 11 Mb/s; 9 Mb/s
                              18 Mb/s; 36 Mb/s; 54 Mb/s
                    Bit Rates:6 Mb/s; 12 Mb/s; 24 Mb/s; 48 Mb/s
                    Mode:Master
                    Extra:tsf=000000138750bbcf
                    Extra: Last beacon: 200ms ago
                    IE: Unknown: 00084672656557696669
                    IE: Unknown: 010882848B961224486C
                    IE: Unknown: 03010A
                    IE: Unknown: 2A0104
                    IE: Unknown: 32040C183060
                    IE: Unknown: 2D1A6E1017FFFF000001000000000000000000000000000000000000
                    IE: Unknown: 3D160A070000000000000000000000000000000000000000
                    IE: Unknown: 3E0100
                    IE: Unknown: DD180050F2020101000003A4000027A4000042435E0062322F00
                    IE: Unknown: 7F0101
                    IE: Unknown: DD07000C4300000000
                    IE: Unknown: DD1E00904C336E1017FFFF000001000000000000000000000000000000000000
                    IE: Unknown: DD1A00904C340A070000000000000000000000000000000000000000
