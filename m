Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yorgi.telenet-ops.be ([195.130.133.69]:47015 "EHLO
	yorgi.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411AbYHMAEU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Aug 2008 20:04:20 -0400
Received: from wilson.telenet-ops.be (wilson.telenet-ops.be [195.130.132.42])
	by yorgi.telenet-ops.be (Postfix) with ESMTP id A258B588514
	for <linux-wireless@vger.kernel.org>; Wed, 13 Aug 2008 02:04:18 +0200 (CEST)
Message-ID: <48A224E3.90307@telenet.be> (sfid-20080813_020423_478855_9B110A31)
Date: Wed, 13 Aug 2008 02:03:47 +0200
From: Ian Schram <ischram@telenet.be>
MIME-Version: 1.0
To: Maxim Levitsky <maximlevitsky@gmail.com>
CC: ipw3945-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
Subject: Re: [ipw3945-devel] Few questions about the wireless stack
References: <48A07709.80306@gmail.com> <48A206A0.6020709@gmail.com>
In-Reply-To: <48A206A0.6020709@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



Maxim Levitsky wrote:
> Maxim Levitsky wrote:
>> Hi,
>>
>> I am trying to understand the relationship between
>> wireless interfaces (wlan0, mon0,..) and wireless driver.
>>
>> The most important question I am after, is what types of interfaces I can
>> run simultaneously? (I know that I can run station and monitor, but 
>> what are other  combinations ?)
>>
>> I noticed that in monitor mode iwl3945 appends so called 'radiotap' 
>> header to received packets, but
>> it seems that mac80211 strips this header, and appends its own,
>> for monitor interfaces, if so, then why to append it?
>>
>>
>> And lastly, when you expect AP code to be released?
>>
> 
> I would be glad to hear about this, I have absolutely no free time to 
> dig that out.
> 

Last i can remember about the subject was Tomas
some months ago.

iirc the statement was something similar to:
- 3945 is a mini PCIe card, and hence not deployed in embedded? devices,
therefore master mode support isn't planned for 3945
- patches are welcome

http://osdir.com/ml/linux.drivers.ipw3945.devel/2007-11/threads.html#00177

cheers
> 
> Maxim Levitsky
> -- 
> To unsubscribe from this list: send the line "unsubscribe 
> linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
