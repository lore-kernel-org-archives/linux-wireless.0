Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:54221 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754163AbXJJNri (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Oct 2007 09:47:38 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1Ifbto-0004U6-JI
	for linux-wireless@vger.kernel.org; Wed, 10 Oct 2007 13:46:56 +0000
Received: from dslc-082-082-164-062.pools.arcor-ip.net ([82.82.164.62])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 10 Oct 2007 13:46:56 +0000
Received: from feldmann_markus by dslc-082-082-164-062.pools.arcor-ip.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 10 Oct 2007 13:46:56 +0000
To: linux-wireless@vger.kernel.org
From: Markus Feldmann <feldmann_markus@gmx.de>
Subject: Re: Patch for Kernel and Ath5k
Date: Wed, 10 Oct 2007 15:45:50 +0200
Message-ID: <feil2d$hn2$1@sea.gmane.org> (sfid-20071010_144802_157263_88481644)
References: <feieb9$nvg$1@sea.gmane.org> <feietp$qf4$1@sea.gmane.org> <40f31dec0710100637w3bfddc67ta32fa244d2cd7343@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
In-Reply-To: <40f31dec0710100637w3bfddc67ta32fa244d2cd7343@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Nick Kossifidis schrieb:
> 2007/10/10, Markus Feldmann <feldmann_markus@gmx.de>:
>> Markus Feldmann schrieb:
>>> Hi All,
>>>
>>> i tried to patch the Kernel to get the ATH5k Driver to work but without
>>> success.
>>>
>>> It seems i miss some scripts like check.sh
>>>
>>> Anybody knows how to get my Problem solved?
>>>
>>> bye Markus
>>>
>> Sorry i forgot to say that i am using the kernel Source 2.6.23-rc8 and
>> wanna patch this with a Andrew Morton Patch,
>> 2.6.23-rc8-mm1
>> 2.6.23-rc8-mm2
>>
>> Can anybody write what i have to do?
>>
>> I am on Debian Etch. I have got an Atheros Wlan Chip with the ID
>> 168c:001c (rev 01).
>>
>> Thank you and
>> bye
> 
> 001c wont work anyway it uses the newer 5.3 EEPROM that we don't yet support ;-(
> 
> 
No Problem. Is there a need for Debugging? I would send you the debug.
So maybe in the future it will work.

