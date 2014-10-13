Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail1.bemta8.messagelabs.com ([216.82.243.206]:34790 "EHLO
	mail1.bemta8.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754765AbaJMDA5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 Oct 2014 23:00:57 -0400
Message-ID: <543B4053.5060708@netcommwireless.com> (sfid-20141013_050120_788767_FA692BF2)
Date: Mon, 13 Oct 2014 14:00:35 +1100
From: Sourav <sourav.chakraborty@netcommwireless.com>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Clients can't connect even though hostapd is running
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Even though hostapd process is running on our router still clients can't 
connect to it via WiFi....error logs are as follows --

Oct 13 13:49:31 ntc_140wx daemon.info hostapd: wlan0: STA 
20:64:32:57:76:e7 IEEE 802.11: authenticated
Oct 13 13:49:31 ntc_140wx daemon.info hostapd: wlan0: STA 
20:64:32:57:76:e7 IEEE 802.11: authenticated
Oct 13 13:49:31 ntc_140wx daemon.info hostapd: wlan0: STA 
20:64:32:57:76:e7 IEEE 802.11: authenticated
Oct 13 13:49:31 ntc_140wx daemon.info hostapd: wlan0: STA 
20:64:32:57:76:e7 IEEE 802.11: authenticated
Oct 13 13:49:31 ntc_140wx daemon.info hostapd: wlan0: STA 
20:64:32:57:76:e7 IEEE 802.11: authenticated
Oct 13 13:49:31 ntc_140wx daemon.info hostapd: wlan0: STA 
20:64:32:57:76:e7 IEEE 802.11: authenticated
Oct 13 13:49:31 ntc_140wx daemon.info hostapd: wlan0: STA 
20:64:32:57:76:e7 IEEE 802.11: authenticated
Oct 13 13:49:31 ntc_140wx daemon.info hostapd: wlan0: STA 
20:64:32:57:76:e7 IEEE 802.11: associated (aid 1)
Oct 13 13:49:31 ntc_140wx daemon.info hostapd: wlan0: STA 
20:64:32:57:76:e7 IEEE 802.11: associated (aid 1)
Oct 13 13:49:31 ntc_140wx daemon.info hostapd: wlan0: STA 
20:64:32:57:76:e7 IEEE 802.11: associated (aid 1)
Oct 13 13:49:31 ntc_140wx daemon.info hostapd: wlan0: STA 
20:64:32:57:76:e7 IEEE 802.11: associated (aid 1)
Oct 13 13:49:31 ntc_140wx daemon.info hostapd: wlan0: STA 
20:64:32:57:76:e7 IEEE 802.11: associated (aid 1)
Oct 13 13:49:31 ntc_140wx daemon.info hostapd: wlan0: STA 
20:64:32:57:76:e7 IEEE 802.11: associated (aid 1)
Oct 13 13:49:31 ntc_140wx daemon.info hostapd: wlan0: STA 
20:64:32:57:76:e7 IEEE 802.11: associated (aid 1)
Oct 13 13:49:31 ntc_140wx daemon.info hostapd: wlan0: STA 
20:64:32:57:76:e7 IEEE 802.11: authenticated
Oct 13 13:49:31 ntc_140wx daemon.info hostapd: wlan0: STA 
20:64:32:57:76:e7 IEEE 802.11: authenticated
Oct 13 13:49:31 ntc_140wx daemon.info hostapd: wlan0: STA 
20:64:32:57:76:e7 IEEE 802.11: authenticated
Oct 13 13:49:31 ntc_140wx daemon.info hostapd: wlan0: STA 
20:64:32:57:76:e7 IEEE 802.11: authenticated
Oct 13 13:49:31 ntc_140wx daemon.info hostapd: wlan0: STA 
20:64:32:57:76:e7 IEEE 802.11: authenticated
Oct 13 13:49:31 ntc_140wx daemon.info hostapd: wlan0: STA 
20:64:32:57:76:e7 IEEE 802.11: authenticated
Oct 13 13:49:31 ntc_140wx daemon.info hostapd: wlan0: STA 
20:64:32:57:76:e7 IEEE 802.11: authenticated
Oct 13 13:49:31 ntc_140wx daemon.info hostapd: wlan0: STA 
20:64:32:57:76:e7 IEEE 802.11: authenticated
Oct 13 13:49:31 ntc_140wx daemon.info hostapd: wlan0: STA 
20:64:32:57:76:e7 IEEE 802.11: authenticated
Oct 13 13:49:31 ntc_140wx daemon.info hostapd: wlan0: STA 
20:64:32:57:76:e7 IEEE 802.11: authenticated
Oct 13 13:49:31 ntc_140wx daemon.info hostapd: wlan0: STA 
20:64:32:57:76:e7 IEEE 802.11: authenticated
Oct 13 13:49:31 ntc_140wx daemon.info hostapd: wlan0: STA 
20:64:32:57:76:e7 IEEE 802.11: authenticated

Please suggest a solution to overcome this.

-- 
Warm Regards,
Sourav


______________________________________________________________________
This communication contains information which may be confidential or privileged. The information is intended solely for the use of the individual or entity named above.  If you are not the intended recipient, be aware that any disclosure, copying, distribution or use of the contents of this information is prohibited.  If you have received this communication in error, please notify me by telephone immediately.
______________________________________________________________________
