Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from khc.piap.pl ([195.187.100.11]:34268 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755430AbYB2XII (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Feb 2008 18:08:08 -0500
To: linux-wireless@vger.kernel.org
Subject: ath5k in ad-hoc mode and encryption
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Sat, 01 Mar 2008 00:08:06 +0100
Message-ID: <m3k5kn9x9l.fsf@maximus.localdomain> (sfid-20080229_230835_636600_BCA926E1)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A simple question I hope.

I want to experiment with point-point encrypted wifi link. Have 2
machines with AR5212, 5213, 5213A+RF2112A or something like that.

iwlist enc / iwlist keys says:
wlan0     2 key sizes : 40, 104bits                                             
          4 keys available :                                                    
                [1]: off                                                        
                [2]: off                                                        
                [3]: off                                                        
                [4]: off                                                        
          Current Transmit Key: [1]                                             

iwlist auth:
wlan0     Authentication capabilities :                                         
                WPA                                                             
                WPA2                                                            
                CIPHER-TKIP                                                     
                CIPHER-CCMP                                                     
          Current Authentication algorithm :                                    
                open                                                            
                shared-key   

iwlist wpakeys:                                                
wlan0     2 key sizes : 40, 104bits                                             
          4 keys available :                                                    
Error reading wpa keys (SIOCGIWENCODEEXT): Operation not supported              


Now, is it possible to use, for example, CCMP cipher with 256-bit key?
How do I set the key and CCMP mode?

Or, how do I set 104-bit and WPA+TKIP?

IOW, how do I set it up?


I noticed "iwconfig wlan0 key XXXXX" (104 bits) make the transmitting
card encrypt data, but the receiving card doesn't seem to decrypt them
(tcpdump shows encrypted traffic on receiving wlan0 and nothing
works).

Perhaps there is some faq or example?
-- 
Krzysztof Halasa
