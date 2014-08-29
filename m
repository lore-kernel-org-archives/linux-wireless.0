Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f41.google.com ([74.125.82.41]:51772 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985AbaH2UqJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Aug 2014 16:46:09 -0400
Received: by mail-wg0-f41.google.com with SMTP id l18so2728718wgh.24
        for <linux-wireless@vger.kernel.org>; Fri, 29 Aug 2014 13:46:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1409310171.4577.13.camel@jlt4.sipsolutions.net>
References: <1406556148-3924-1-git-send-email-lorenzo.bianconi83@gmail.com>
	<1406556148-3924-2-git-send-email-lorenzo.bianconi83@gmail.com>
	<1407770081.9844.12.camel@jlt4.sipsolutions.net>
	<CAA2SeNLg3mktDY0u4=ksHr4QvXewx4koeGkCAW8upqrS6gMg0g@mail.gmail.com>
	<1409310171.4577.13.camel@jlt4.sipsolutions.net>
Date: Fri, 29 Aug 2014 22:46:07 +0200
Message-ID: <CAA2SeNKcF37iC0e+n8nrtabT8qwYE9tqD3RCGsSeiBmyxJjhjQ@mail.gmail.com> (sfid-20140829_224613_399894_3FAA76BB)
Subject: Re: [PATCHv4 1/2] cfg80211: enable dynack through nl80211
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>,
	Christian Lamparter <chunkeey@googlemail.com>,
	Nick Kossifidis <mickflemm@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Hi,
>
> Sorry for the delay.
>
>> dynack is disable by default at bootstrap and it is automatically
>> disabled as soon as you set coverage_class (coverage_class >= 0) after
>> dynack has been enabled (coverage_class = -1). E.g:
>>
>> - iw phy phy0 set distance auto (to enable dynack)
>>
>> - iw phy phy0 set distance x (to set coverage class and disable dynack)
>>
>>
>> This logic is implemented in dynack code. Is it fine for you?
>
> Ok, I guess that's reasonable. The default coverage class is 0 I guess?

Yes, dynack is disabled at bootstrap and default coverage class is 0

>
>> Anyway documentation should be clearer on that stuff. :)
>
> Please extend it then? :)
>

I will send a new patchset with more comments on that stuff :)

> johannes
>

Regards,
Lorenzo

-- 
UNIX is Sexy: who | grep -i blonde | talk; cd ~; wine; talk; touch;
unzip; touch; strip; gasp; finger; gasp; mount; fsck; more; yes; gasp;
umount; make clean; sleep
