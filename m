Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from will39.synserver.de ([212.40.172.10]:55369 "EHLO willies.info"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751005AbYHKWTz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Aug 2008 18:19:55 -0400
Message-ID: <48A0B006.6080704@gmail.com> (sfid-20080812_002012_782125_8793C21A)
Date: Mon, 11 Aug 2008 23:32:54 +0200
From: loswillios <loswillios@gmail.com>
MIME-Version: 1.0
To: Ivo van Doorn <ivdoorn@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: unable to associate with WPA-AP - rt2x00-2.1.8
References: <489FF6A8.9030204@willies.info> <200808112017.58980.IvDoorn@gmail.com> <48A084F7.6070206@willies.info>
In-Reply-To: <48A084F7.6070206@willies.info>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jan Willies wrote:
> Ivo van Doorn wrote:
>> On Monday 11 August 2008, Jan Willies wrote:
>>> I'm using Fedore9 and since the last update I cannot associate my rt2500pci card anymore, it's running into a timeout. I'm not seeing any log entries on the AP.
>>>
>>> rt2500pci is version 2.1.8
>> I think this should have been fixed by patch:
>> http://lkml.org/lkml/2008/7/31/35
>>
>> But I don't know if John has merged that patch to FC9 yet.
> 
> I tried compat-wireless from today which doesn't have the patch, and it didn't work. Applying the fix from above results in a not-compiling compat-wireless:

Ok, I did not see the other mail in the thread. It compiles fine now, but the result is still the same :/


- Jan
