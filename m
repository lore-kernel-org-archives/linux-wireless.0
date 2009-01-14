Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.187]:16436 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755143AbZANQGN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Jan 2009 11:06:13 -0500
Received: by mu-out-0910.google.com with SMTP id g7so305301muf.1
        for <linux-wireless@vger.kernel.org>; Wed, 14 Jan 2009 08:06:10 -0800 (PST)
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Message-Id: <9B9048F0-7AA4-43AE-A2D8-72E0EAA55457@gmail.com> (sfid-20090114_170617_411465_3AB84CE2)
From: Lorenzo Nava <navalorenx@gmail.com>
To: "Buran Ayuthia" <the.ayuthias@googlemail.com>
In-Reply-To: <30c8a83c0901140757w5ee3c859wd0685d0b5f3a2e29@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: Re: [b43] opensource firmware
Date: Wed, 14 Jan 2009 17:06:08 +0100
References: <9FB118DA-845D-4708-84F3-4D51837D8C68@gmail.com> <30c8a83c0901140757w5ee3c859wd0685d0b5f3a2e29@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Great!

Thank you very much for the help... qos=0 parameter was still needed,  
so it is correct.

cheers

Lorenzo Nava.

On Jan 14, 2009, at 4:57 PM, Buran Ayuthia wrote:

> My 4311 rev 01 card still works with the new initvals and firmware
> using WPA2-personal (both TKIP and CCMP) and without encyrption.  I am
> still loading the module using modprobe b43 qos=0.
>
> Buran Ayuthia
>
> On Wed, Jan 14, 2009 at 9:30 AM, Lorenzo Nava <navalorenx@gmail.com>  
> wrote:
>> Hello everybody,
>>
>> we completed the 1st version of initvals. They are available at http://www.ing.unibs.it/openfwwf
>> . Currently only binary version is available: don't worry, we will
>> publish source code as soon as possible!! This first version is a
>> "test version": please try it and let us know if everythink is ok...
>>
>> Today we have also tested a new firmware version that works with  
>> WPA2-
>> personal (both TKIP and CCMP) and WPA2-enterprise (EAP-TTLS) (tested
>> on 4306 and 4318 PCI device). If anybody was interested please try  
>> new
>> firmware with encryption and let us know if it works correctly,  
>> thanks!
>>
>> Initvals and new firmware version can be found at http://www.ing.unibs.it/openfwwf
>>
>> Cheers
>>
>> Lorenzo Nava
>> Francesco Gringoli
>>
>>
>> _______________________________________________
>> Bcm43xx-dev mailing list
>> Bcm43xx-dev@lists.berlios.de
>> https://lists.berlios.de/mailman/listinfo/bcm43xx-dev
>>

