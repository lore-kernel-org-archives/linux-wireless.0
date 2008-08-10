Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:51055 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753452AbYHJUgr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Aug 2008 16:36:47 -0400
Received: from agathe (dslb-088-065-133-075.pools.arcor-ip.net [88.65.133.75])
	by post.webmailer.de (klopstock mo60) (RZmta 16.47)
	with ESMTP id x03853k7AG2OTK for <linux-wireless@vger.kernel.org>;
	Sun, 10 Aug 2008 22:36:46 +0200 (MEST)
	(envelope-from: <postfix@au-79.de>)
Received: from localhost (agathe [127.0.0.1])
	by agathe (Postfix) with ESMTP id D3ECF1BFE2
	for <linux-wireless@vger.kernel.org>; Sun, 10 Aug 2008 22:36:45 +0200 (CEST)
Received: from agathe ([127.0.0.1])
	by localhost (agathe.au-79.intra [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id A3ATDxEe-H5m for <linux-wireless@vger.kernel.org>;
	Sun, 10 Aug 2008 22:36:41 +0200 (CEST)
Received: from [192.168.23.124] (sixtus.au-79.intra [192.168.23.124])
	by agathe (Postfix) with ESMTP id 718FB1BFC3
	for <linux-wireless@vger.kernel.org>; Sun, 10 Aug 2008 22:36:41 +0200 (CEST)
Message-ID: <489F5158.9090705@au-79.de> (sfid-20080810_223704_701543_5E752575)
Date: Sun, 10 Aug 2008 22:36:40 +0200
From: Robert Goldner <postfix@au-79.de>
Reply-To: postfix@au-79.de
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Re: Problems with Belkin F5D7010 PCMCIA 1799:701f while trying WPA
 connection
References: <489EAA04.8070203@au-79.de> <489EF765.8050000@lwfinger.net>
In-Reply-To: <489EF765.8050000@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger schrieb:
> Robert Goldner wrote:
>> Wireless event: cmd=0x8b19 len=8
>> Received 0 bytes of scan results (0 BSSes)
>> CTRL-EVENT-SCAN-RESULTS
>> Selecting BSS from priority group 0
>> Try to find WPA-enabled AP
>> Try to find non-WPA AP
>> No suitable AP found.
>> Setting scan request: 5 sec 0 usec
>> Starting AP scan (specific SSID)
>> Scan SSID - hexdump_ascii(len=8):
>>      64 69 64 65 6c 64 75 6d                           dideldum
>> Scan requested (ret=0) - scan timeout 30 seconds
>> ...
>> ...
>> ...
>>
>> The config-file is running well with a rt73, rtl8187 and a b43 card. 
>> So it seems, that the pcmcia-card itself is the problem.
>>
>>
>>
>> Any hints?
> 
> You are not getting any scan results in your wpa_supplicant output? Does 
> the output of ifconfig show wlan0 to be up? If so, what does the output 
> of 'iwlist wlan0 scan' show?
> 
> Larry
> -- 
> To unsubscribe from this list: send the line "unsubscribe 
> linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
 >
Hi Larry,

very good point. There is a German saying like:
"who is able to read, has clear advantages..."

The ifconfig output seems good (like other working wlan cards), and the 
interface is up. But iwlist wlan0 scan does not find any wlan-network. 
Very strange, because I made this test very close to the access-point 
(about 30 cm distance). With other wlan-cards I get signal levels of 
~80% of maximum. So maybe the receiving part is broken. I can not test 
the hardware with the windows-driver, because I don't have a 
windows-installation.


Robert
