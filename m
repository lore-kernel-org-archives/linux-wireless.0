Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ik-out-1112.google.com ([66.249.90.179]:31448 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752240AbYHMDha (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Aug 2008 23:37:30 -0400
Received: by ik-out-1112.google.com with SMTP id c28so3172168ika.5
        for <linux-wireless@vger.kernel.org>; Tue, 12 Aug 2008 20:37:28 -0700 (PDT)
Message-ID: <48A256F4.2000506@gmail.com> (sfid-20080813_053753_768138_0D388664)
Date: Wed, 13 Aug 2008 06:37:24 +0300
From: Maxim Levitsky <maximlevitsky@gmail.com>
MIME-Version: 1.0
To: Ian Schram <ischram@telenet.be>
CC: ipw3945-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
Subject: Re: [ipw3945-devel] Few questions about the wireless stack
References: <48A07709.80306@gmail.com> <48A206A0.6020709@gmail.com> <48A224E3.90307@telenet.be>
In-Reply-To: <48A224E3.90307@telenet.be>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ian Schram wrote:
> 
> 
> Maxim Levitsky wrote:
>> Maxim Levitsky wrote:
>>> Hi,
>>>
>>> I am trying to understand the relationship between
>>> wireless interfaces (wlan0, mon0,..) and wireless driver.
>>>
>>> The most important question I am after, is what types of interfaces I 
>>> can
>>> run simultaneously? (I know that I can run station and monitor, but 
>>> what are other  combinations ?)
>>>
>>> I noticed that in monitor mode iwl3945 appends so called 'radiotap' 
>>> header to received packets, but
>>> it seems that mac80211 strips this header, and appends its own,
>>> for monitor interfaces, if so, then why to append it?
>>>
>>>
>>> And lastly, when you expect AP code to be released?
>>>
>>
>> I would be glad to hear about this, I have absolutely no free time to 
>> dig that out.
>>
> 
> Last i can remember about the subject was Tomas
> some months ago.
> 
> iirc the statement was something similar to:
> - 3945 is a mini PCIe card, and hence not deployed in embedded? devices,
> therefore master mode support isn't planned for 3945
> - patches are welcome
> 
> http://osdir.com/ml/linux.drivers.ipw3945.devel/2007-11/threads.html#00177
> 
> cheers
>>
>> Maxim Levitsky
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe 
>> linux-wireless" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>


What do we need from the hardware to enable master mode?

I think that the best solution is to unite 3945 and rest of the driver code, 
since it is all the same.

You say that 4965 is pci express. does that mean I can buy a standalone version of it?


Regards,
	Maxim Levitsky

