Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:51773 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752970Ab1HMDIV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Aug 2011 23:08:21 -0400
Received: by gwaa12 with SMTP id a12so2374315gwa.19
        for <linux-wireless@vger.kernel.org>; Fri, 12 Aug 2011 20:08:20 -0700 (PDT)
Message-ID: <4E45EA54.5010500@gmail.com> (sfid-20110813_050828_131511_C7D54CFE)
Date: Fri, 12 Aug 2011 23:07:00 -0400
From: Roman Krylov <volyrkr@gmail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Re: rtl8192* wifi driver
References: <4E45A973.6060305@gmail.com> <4E45AF82.5040407@lwfinger.net> <4E45D65F.6000306@gmail.com> <4E45DCB2.5020905@lwfinger.net>
In-Reply-To: <4E45DCB2.5020905@lwfinger.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> What do you see in the NM log file? It should be at /var/log/NetworkManager?
>
> I would also like to see the output of the 'iwlist scan' command when run as 
> root.
>
> Larry
Aug 12 21:26:11 volyrkr NetworkManager: <info>  Activation (wlan3/wireless): 
connection 'Auto bhn 310' has security, and secrets exist.  No new secrets needed.
Aug 12 21:26:11 volyrkr NetworkManager: <info>  Config: added 'ssid' value 'bhn 310'
Aug 12 21:26:11 volyrkr NetworkManager: <info>  Config: added 'scan_ssid' value '1'
Aug 12 21:26:11 volyrkr NetworkManager: <info>  Config: added 'key_mgmt' value 
'NONE'
Aug 12 21:26:11 volyrkr NetworkManager: <info>  Config: added 'auth_alg' value 
'OPEN'
Aug 12 21:26:11 volyrkr NetworkManager: <info>  Config: added 'wep_key0' value 
'<omitted>'
Aug 12 21:26:11 volyrkr NetworkManager: <info>  Config: added 'wep_key1' value 
'<omitted>'
Aug 12 21:26:11 volyrkr NetworkManager: <info>  Config: added 'wep_tx_keyidx' 
value '0'
Aug 12 21:26:11 volyrkr NetworkManager: <info>  Activation (wlan3) Stage 2 of 5 
(Device Configure) complete.
Aug 12 21:26:11 volyrkr NetworkManager: <info>  Config: set interface ap_scan to 1
Aug 12 21:26:11 volyrkr NetworkManager: <info>  (wlan3): supplicant connection 
state:  inactive -> scanning
Aug 12 21:26:36 volyrkr NetworkManager: <info>  Activation (wlan3/wireless): 
association took too long.
Aug 12 21:26:36 volyrkr NetworkManager: <info>  (wlan3): device state change: 5 
-> 9 (reason 7)
Aug 12 21:26:36 volyrkr NetworkManager: <info>  Activation (wlan3) failed for 
access point (bhn 310)

Roman.

