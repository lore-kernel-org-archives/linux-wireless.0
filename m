Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:48383 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754003Ab1IQXtB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Sep 2011 19:49:01 -0400
Received: by gyg10 with SMTP id 10so3519697gyg.19
        for <linux-wireless@vger.kernel.org>; Sat, 17 Sep 2011 16:49:00 -0700 (PDT)
Message-ID: <4E7531E9.8010708@lwfinger.net> (sfid-20110918_014916_302392_8291EE5E)
Date: Sat, 17 Sep 2011 18:48:57 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: James <bjlockie@lockie.ca>
CC: linux-wireless Mailing List <linux-wireless@vger.kernel.org>
Subject: Re: did my hardware die?
References: <4E7521C9.5060801@lockie.ca> <4E752B9A.6000509@lockie.ca>
In-Reply-To: <4E752B9A.6000509@lockie.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/17/2011 06:22 PM, James wrote:
> On 09/17/11 18:40, James wrote:
>> Does it mean my hardware died since dmesg shows nothing related to ath?
>>
>> # dmesg | grep ath
>>
>> # lspci
>> 02:09.0 Network controller: Atheros Communications Inc. AR5008 Wireless
>> Network Adapter (rev 01)
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at http://vger.kernel.org/majordomo-info.html
>>
> Kernel 3.6.36.4 sees the hardware:
>
> ath9k 0000:02:08.0: PCI INT A -> Link[LNKA] -> GSI 18 (level, low) -> IRQ 18
> ath: EEPROM regdomain: 0x10
> ath: EEPROM indicates we should expect a direct regpair map
> ath: Country alpha2 being used: CO
> ath: Regpair used: 0x10
> ieee80211 phy0: Selected rate control algorithm 'ath9k_rate_control'
> Registered led device: ath9k-phy0
>
> Kernel-3.0.4 does not.

What are the PCI ID's for that device? That comes from 'lspci -nn'.

What is the source of your 3.0.4 kernel?

Larry

