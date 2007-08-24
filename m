Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from frosty.hhs.nl ([145.52.2.15]:60487 "EHLO frosty.hhs.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757726AbXHXJ5v (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Aug 2007 05:57:51 -0400
Received: from exim (helo=frosty)
	by frosty.hhs.nl with local-smtp (Exim 4.62)
	(envelope-from <j.w.r.degoede@hhs.nl>)
	id 1IOVvJ-0007Vd-D0
	for linux-wireless@vger.kernel.org; Fri, 24 Aug 2007 11:57:49 +0200
Received: from [145.52.8.13] (port=33441 helo=hhs.nl)
	by frosty.hhs.nl with esmtp (Exim 4.62)
	(envelope-from <j.w.r.degoede@hhs.nl>)
	id 1IOVvI-0007V9-J4
	for linux-wireless@vger.kernel.org; Fri, 24 Aug 2007 11:57:48 +0200
Message-ID: <46CEA8A2.3040906@hhs.nl>
Date: Fri, 24 Aug 2007 11:45:06 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: Chr <chunkeey@web.de>
CC: Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
Subject: Re: Recent linux-wireless git changes have broken my prism54pci card
References: <46BFF10B.1090307@hhs.nl> <200708231643.43741.chunkeey@web.de> <46CE018B.3000707@hhs.nl> <200708240100.17820.chunkeey@web.de>
In-Reply-To: <200708240100.17820.chunkeey@web.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Chr wrote:
> On Thursday, 23. August 2007, Hans de Goede wrote:
>> Okay, I've given this a test together with your remvoe QOS and other advanced 
>> features patch and it seems to work well (as good as the versiono of the driver 
>> I'm currently using).
>>
>> I've tried using all other firmwares from here:
>> http://jbnote.free.fr/prism54usb/data/firmwares/
>>
>> But none of them work, except for the (identical) 2.4.12.0 one. the others 
>> either don't boot or can't read the eeprom.
>>
> 
> Thanks for testing! Let's see if I can write something over the weekend.
> Since you have said in your previous post that your Sitecom adapter is cheap
> and common ... can you please tell me which one is it?
> 

Its a Sitecom WL-140 V2 (small letters at the bottom right of the front of the 
box) aka the Sitecom Nitro XM 140G+

Note I think that the V2 is important to get the same one as mine, otherwise 
you probably get an older fullmac version (if they still sell that anyware).

Regards,

Hans


