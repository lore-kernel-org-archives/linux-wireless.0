Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3560 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752031Ab1F3VWx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jun 2011 17:22:53 -0400
Message-ID: <4E0CE91D.10702@broadcom.com> (sfid-20110630_232257_224234_73DAE0B8)
Date: Thu, 30 Jun 2011 14:22:37 -0700
From: "Henry Ptasinski" <henryp@broadcom.com>
MIME-Version: 1.0
To: "Luciano Coelho" <coelho@ti.com>
cc: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	"gregkh@suse.de" <gregkh@suse.de>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Roland Vossen" <rvossen@broadcom.com>,
	"Arend Van Spriel" <arend@broadcom.com>,
	"Brett Rudley" <brudley@broadcom.com>,
	"Henry Ptasinski" <henryp@broadcom.com>
Subject: Re: [PATCH 000/119] staging: brcm80211: more code cleanup and
 bug fixed
References: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
 <BANLkTikPBWvYiNc1rZEwPJTck=AzUsLncA@mail.gmail.com>
 <4E0CB587.3000209@broadcom.com> <1309464979.1514.177.camel@cumari>
In-Reply-To: <1309464979.1514.177.camel@cumari>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/30/2011 01:16 PM, Luciano Coelho wrote:
> Hi Henry,
>
> On Thu, 2011-06-30 at 10:42 -0700, Henry Ptasinski wrote:
>> On 06/29/2011 11:29 PM, Rafał Miłecki wrote:
>>> 2011/6/30 Franky Lin<frankyl@broadcom.com>:
>>>> Most of these patches are brcmfmac cleanup.
>>>
>>>
>>> Hm, interesting improvement in your "Release early, release often" strategy.
>>>
>>
>> Yea, we were waiting for the previous series to get applied.  Not sure
>> how to make this work better.  Any process suggestions would be appreciated.
>
> Keep sending them in small batches, I think it is just normal to apply
> the batches one after the other, no need to keep waiting.  If there are
> no conflicts, everything should go smoothly.  And if it doesn't, someone
> will ping you. ;)
>

That's what we had been doing, but along the way a patch or two got 
dropped and that caused a train wreck.

We were hoping that switching to a more batch-oriented mode would help, 
but obviously that approach has it's own problems.

- Henry



