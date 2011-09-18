Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nexicom.net ([216.168.96.13]:54908 "EHLO smtp.nexicom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751079Ab1IRFNb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Sep 2011 01:13:31 -0400
Received: from mail.lockie.ca (dyn-dsl-mb-216-168-118-207.nexicom.net [216.168.118.207])
	by smtp.nexicom.net (8.13.6/8.13.4) with ESMTP id p8I5DTW0010358
	for <linux-wireless@vger.kernel.org>; Sun, 18 Sep 2011 01:13:30 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by mail.lockie.ca (Postfix) with ESMTP id BF0101E007D
	for <linux-wireless@vger.kernel.org>; Sun, 18 Sep 2011 01:13:28 -0400 (EDT)
Message-ID: <4E757E70.9000400@lockie.ca> (sfid-20110918_071336_065016_E25E4F7E)
Date: Sun, 18 Sep 2011 01:15:28 -0400
From: James <bjlockie@lockie.ca>
MIME-Version: 1.0
To: linux-wireless Mailing List <linux-wireless@vger.kernel.org>
Subject: Re: did my hardware die?
References: <4E7521C9.5060801@lockie.ca> <4E752B9A.6000509@lockie.ca> <4E7531E9.8010708@lwfinger.net>
In-Reply-To: <4E7531E9.8010708@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/17/11 19:48, Larry Finger wrote:
> On 09/17/2011 06:22 PM, James wrote:
>> On 09/17/11 18:40, James wrote:
>>> Does it mean my hardware died since dmesg shows nothing related to ath?
>>>
>>> # dmesg | grep ath
>>>
>>> # lspci
>>> 02:09.0 Network controller: Atheros Communications Inc. AR5008 Wireless
>>> Network Adapter (rev 01)
>>> -- 
>>> To unsubscribe from this list: send the line "unsubscribe 
>>> linux-wireless" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at http://vger.kernel.org/majordomo-info.html
>>>
>> Kernel 3.6.36.4 sees the hardware:
>>
>> ath9k 0000:02:08.0: PCI INT A -> Link[LNKA] -> GSI 18 (level, low) -> 
>> IRQ 18
>> ath: EEPROM regdomain: 0x10
>> ath: EEPROM indicates we should expect a direct regpair map
>> ath: Country alpha2 being used: CO
>> ath: Regpair used: 0x10
>> ieee80211 phy0: Selected rate control algorithm 'ath9k_rate_control'
>> Registered led device: ath9k-phy0
>>
>> Kernel-3.0.4 does not.
>
> What are the PCI ID's for that device? That comes from 'lspci -nn'.
>
> What is the source of your 3.0.4 kernel?
>
> Larry
I recompiled 3.0.4 and it works.
I took out ath9k debugging (and maybe other stuff) and put it back.
I got the kernel directly from kernel.org a while ago.

