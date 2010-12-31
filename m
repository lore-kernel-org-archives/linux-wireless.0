Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nexicom.net ([216.168.96.13]:34584 "EHLO smtp.nexicom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751261Ab0LaExC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Dec 2010 23:53:02 -0500
Received: from mail.lockie.ca (dyn-dsl-mb-216-168-118-36.nexicom.net [216.168.118.36])
	by smtp.nexicom.net (8.13.6/8.13.4) with ESMTP id oBV4qvTZ005766
	for <linux-wireless@vger.kernel.org>; Thu, 30 Dec 2010 23:52:58 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by mail.lockie.ca (Postfix) with ESMTP id D6A719850B
	for <linux-wireless@vger.kernel.org>; Thu, 30 Dec 2010 23:52:52 -0500 (EST)
Message-ID: <4D1D61A1.9090309@lockie.ca>
Date: Thu, 30 Dec 2010 23:52:49 -0500
From: James <bjlockie@lockie.ca>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: iwconfig and iwlist
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

iwconfig says my Encryption key is off but iwlist says it is on (it is
on :-)).
Everything works so that is a minor thing.

$ sudo iwconfig
wlan1     IEEE 802.11bgn  ESSID:"me"  
          Mode:Managed  Frequency:2.462 GHz  Access Point:
00:0F:B5:12:F5:EA   
          Bit Rate=54 Mb/s   Tx-Power=20 dBm   
          Retry  long limit:7   RTS thr:off   Fragment thr:off
          Encryption key:off
          Power Management:off
          Link Quality=51/70  Signal level=-59 dBm  
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0


$ sudo iwlist wlan1 scan
          Cell 10 - Address: 00:0F:B5:12:F5:EA
                    Channel:11
                    Frequency:2.462 GHz (Channel 11)
                    Quality=51/70  Signal level=-59 dBm 
                    Encryption key:on
                    ESSID:"me"
                    Bit Rates:1 Mb/s; 2 Mb/s; 5.5 Mb/s; 11 Mb/s
                    Bit Rates:6 Mb/s; 9 Mb/s; 12 Mb/s; 18 Mb/s; 24 Mb/s
                              36 Mb/s; 48 Mb/s; 54 Mb/s
                    Mode:Master
                    Extra:tsf=000000005899a294
                    Extra: Last beacon: 49ms ago
                    IE: Unknown: 000C54656B53617676792E636F6D
                    IE: Unknown: 010482848B96
                    IE: Unknown: 03010B
                    IE: Unknown: 2A0102
                    IE: Unknown: 32088C129824B048606C
                    IE: WPA Version 1
                        Group Cipher : TKIP
                        Pairwise Ciphers (1) : TKIP
                        Authentication Suites (1) : PSK
