Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:64478 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752852AbYHJOMy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Aug 2008 10:12:54 -0400
Message-ID: <489EF765.8050000@lwfinger.net> (sfid-20080810_161258_556639_69E794B8)
Date: Sun, 10 Aug 2008 09:12:53 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: postfix@au-79.de
CC: linux-wireless@vger.kernel.org
Subject: Re: Problems with Belkin F5D7010 PCMCIA 1799:701f while trying WPA
 connection
References: <489EAA04.8070203@au-79.de>
In-Reply-To: <489EAA04.8070203@au-79.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Robert Goldner wrote:
> Wireless event: cmd=0x8b19 len=8
> Received 0 bytes of scan results (0 BSSes)
> CTRL-EVENT-SCAN-RESULTS
> Selecting BSS from priority group 0
> Try to find WPA-enabled AP
> Try to find non-WPA AP
> No suitable AP found.
> Setting scan request: 5 sec 0 usec
> Starting AP scan (specific SSID)
> Scan SSID - hexdump_ascii(len=8):
>      64 69 64 65 6c 64 75 6d                           dideldum
> Scan requested (ret=0) - scan timeout 30 seconds
> ...
> ...
> ...
> 
> The config-file is running well with a rt73, rtl8187 and a b43 card. So 
> it seems, that the pcmcia-card itself is the problem.
> 
> 
> 
> Any hints?

You are not getting any scan results in your wpa_supplicant output? 
Does the output of ifconfig show wlan0 to be up? If so, what does the 
output of 'iwlist wlan0 scan' show?

Larry
