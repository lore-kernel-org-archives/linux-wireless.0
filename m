Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:48551 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751537Ab0FJFgf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jun 2010 01:36:35 -0400
Received: by pwj5 with SMTP id 5so2258357pwj.19
        for <linux-wireless@vger.kernel.org>; Wed, 09 Jun 2010 22:36:35 -0700 (PDT)
Message-ID: <4C1079E0.6090605@yatharthgupta.com>
Date: Wed, 09 Jun 2010 22:36:32 -0700
From: Yatharth <y@yatharthgupta.com>
MIME-Version: 1.0
To: Sujith <Sujith.Manoharan@atheros.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: issues while attempting ath9k_htc to work with ubuntu 10.04,
 device TL-WN721N
References: <4C107563.3010709@yatharthgupta.com>	<19472.30680.855993.112084@gargle.gargle.HOWL>	<4C1078D4.3070604@yatharthgupta.com> <19472.31157.569068.781531@gargle.gargle.HOWL>
In-Reply-To: <19472.31157.569068.781531@gargle.gargle.HOWL>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/09/2010 10:35 PM, Sujith wrote:
> Yatharth wrote:
>    
>> I had checked earlier to ensure that everything was unloaded.
>>
>> But I've done it again to make sure.
>> Step 1 :  'sudo make unload'
>> Step 2 : 'lsmod | grep ath'  [Returns Nothing, thus indicating none of
>> these modules are loaded]
>>
>> If I do 'modprobe ath9k_htc' after this, I still get the same error
>>      
> What does 'modinfo ath9k_hw' show ?
>
> Sujith
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>    
Here is the output of 'modinfo ath9k_hw'

Ubu-VM:~/tmp/compat-wireless-2010-06-05$ modinfo ath9k_hw
filename:       /lib/modules/2.6.32-22-generic/updates/cw/ath9k_hw.ko
license:        Dual BSD/GPL
description:    Support for Atheros 802.11n wireless LAN cards.
author:         Atheros Communications
srcversion:     0946B41CE1566D09C4B08F1
depends:        ath
vermagic:       2.6.32-22-generic SMP mod_unload modversions 586

