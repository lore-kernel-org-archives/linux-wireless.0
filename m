Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from p15195424.pureserver.info ([82.165.34.74]:45312 "EHLO
	p15195424.pureserver.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752356Ab3H0WGz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Aug 2013 18:06:55 -0400
Message-ID: <521D22C5.9060709@ilande.co.uk> (sfid-20130828_000658_205579_DB4D290F)
Date: Tue, 27 Aug 2013 23:05:57 +0100
From: Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: linux-wireless@vger.kernel.org
References: <5217B01D.4000609@ilande.co.uk> <521B9A74.60603@ilande.co.uk> <521CD266.5010801@lwfinger.net> <521D0EA2.2070105@ilande.co.uk> <521D17C7.2070105@lwfinger.net>
In-Reply-To: <521D17C7.2070105@lwfinger.net>
Subject: Re: Problems associating to AP with rtl8192cu driver
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 27/08/13 22:19, Larry Finger wrote:

Hi Larry,

>> The rtl8192cu firmware is that supplied with Debian Wheezy, while the AP
>> firmware should also be reasonably up-to-date. Access to all APs is
>> fine using
>> an Android phone, the zd1211rw desktop PC and a laptop with an iwlwifi
>> driver.
>> The APs are set to advertise both WPA and WPA2 encryption.
>
> The accepted firmware has an md5sum of 943e9b714a926e630b8152d7aad91d2e
> for /lib/firmware/rtlwifi/rtl8192cufw.bin.

Yes - that agrees with what I have here:

mca@kentang:~$ md5sum /lib/firmware/rtlwifi/rtl8192cufw.bin
943e9b714a926e630b8152d7aad91d2e  /lib/firmware/rtlwifi/rtl8192cufw.bin

>>> Do you still have the wireshark file from the failed attempt? If so,
>>> could you filter out the traffic from APs and stations other than the
>>> units trying to make the connection, and send me (privately) the trimmed
>>> file?
>>
>> Yes - I'm not sure if it's exactly that attempt, but I do have a
>> representative
>> wireshark trace of this which I will send to you privately.
>>
>>> For completeness, I have tested WPA2 with Netgear WNDR3300 and WNDR3400
>>> running standard firmware, WPA1 with a Linksys WRT54GL running openWRT
>>> Kamikaze fw, and WEP with a Linksys WRT54G V5 running standard fw.
>>
>> Okay. So perhaps there is something slightly different about this
>> particular
>> WiFi dongle...
>
> Neither rtl8192cu nor 8192cu (the vendor driver) work with the 2x2
> configuration such as found in a TP-Link TL-WN8200ND V1.0. That was
> reported to Realtek, but I have had no response from them.

Understood. All of the O2 wireless box, desktop PC and Netgear AP I used 
in my tests here are b/g only, so I'm guessing that shouldn't be an issue?


ATB,

Mark.
