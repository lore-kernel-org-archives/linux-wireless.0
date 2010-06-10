Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:57992 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753714Ab0FJGHi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jun 2010 02:07:38 -0400
Received: by pvg16 with SMTP id 16so2839394pvg.19
        for <linux-wireless@vger.kernel.org>; Wed, 09 Jun 2010 23:07:22 -0700 (PDT)
Message-ID: <4C108116.2060905@yatharthgupta.com>
Date: Wed, 09 Jun 2010 23:07:18 -0700
From: Yatharth <y@yatharthgupta.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: Sujith <Sujith.Manoharan@atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: issues while attempting ath9k_htc to work with ubuntu 10.04,
 	device TL-WN721N
References: <4C107563.3010709@yatharthgupta.com> <19472.30680.855993.112084@gargle.gargle.HOWL> 	<4C1078D4.3070604@yatharthgupta.com> <19472.31157.569068.781531@gargle.gargle.HOWL> 	<4C1079E0.6090605@yatharthgupta.com> <19472.32107.793016.762850@gargle.gargle.HOWL> <AANLkTimVqheuVKI3tCpSGoDHRaEcexDFwm77wj_9_QJU@mail.gmail.com>
In-Reply-To: <AANLkTimVqheuVKI3tCpSGoDHRaEcexDFwm77wj_9_QJU@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/09/2010 10:53 PM, Luis R. Rodriguez wrote:
> On Wed, Jun 9, 2010 at 10:51 PM, Sujith<Sujith.Manoharan@atheros.com>  wrote:
>    
>> Yatharth wrote:
>>      
>>> Here is the output of 'modinfo ath9k_hw'
>>>
>>> Ubu-VM:~/tmp/compat-wireless-2010-06-05$ modinfo ath9k_hw
>>> filename:       /lib/modules/2.6.32-22-generic/updates/cw/ath9k_hw.ko
>>>        
>> What is the 'cw' directory ?
>>      
> Its ubuntu's compat-wireless package, linux-backport-modules. Try to
> uninstall that or rm -rf it.
>
>    Luis
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>    

Thanks Sujith & Luis that fixed it. I can now see the device and use it 
correctly.

I remove the 'cw' directory and then

'sudo make install'
'sudo make unload'
'sudo modprobe ath9k_htc'

I did install the compat-wireless package, I believe I did it while 
self-debugging the issue without knowing the implications.
