Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from will39.synserver.de ([212.40.172.10]:55368 "EHLO willies.info"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751014AbYHKWS7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Aug 2008 18:18:59 -0400
Received: from dslb-088-070-146-197.pools.arcor-ip.net ([88.70.146.197] helo=[192.168.1.228])
	by willies.info with esmtpsa (TLS-1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.63)
	(envelope-from <jan@willies.info>)
	id 1KSfj6-00049s-VK
	for linux-wireless@vger.kernel.org; Tue, 12 Aug 2008 00:18:57 +0200
Message-ID: <48A0BAD9.2080001@willies.info> (sfid-20080812_001904_529060_7063C3F4)
Date: Tue, 12 Aug 2008 00:19:05 +0200
From: Jan Willies <jan@willies.info>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
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

