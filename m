Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4247 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751603Ab2E2NDy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 May 2012 09:03:54 -0400
Message-ID: <4FC4C92A.6010109@broadcom.com> (sfid-20120529_150359_697903_AFC06A64)
Date: Tue, 29 May 2012 15:03:38 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Seth Forshee" <seth.forshee@canonical.com>
cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Subject: Re: [RFC PATCH 3/8] brcm80211: smac: clean up channel.c
References: <1334607462-5387-1-git-send-email-seth.forshee@canonical.com>
 <1334607462-5387-4-git-send-email-seth.forshee@canonical.com>
 <4FC008A1.9060005@broadcom.com> <20120526171749.GB11759@ubuntu-mba>
 <4FC215B9.3060605@broadcom.com> <20120529124648.GA28007@thinkpad-t410>
In-Reply-To: <20120529124648.GA28007@thinkpad-t410>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/29/2012 02:46 PM, Seth Forshee wrote:
> On Sun, May 27, 2012 at 01:53:29PM +0200, Arend van Spriel wrote:
>> On 05/26/2012 07:17 PM, Seth Forshee wrote:
>>> On Sat, May 26, 2012 at 12:33:05AM +0200, Arend van Spriel wrote:
>>>> We are not supporting 40MHz right now, but it is on our roadmap. I would
>>>> prefer to keep it, but git can recover it for me when that roadmap item
>>>> is due.
>>>
>>> The argument against keeping it is that it will be utterly broken by all
>>> of the other changes. I could try to rework it along with the rest of
>>> the code I guess, but I'd obviously be unable to test it.
>>>
>>> I'll keep it in if you prefer, but I should probably add a comment
>>> warning that the code needs some attention before it can be used.
>>>
>>>
>>
>> Could you get rid of 40MHz stuff with a separate commit for my
>> convenience when 40MHz is added.
> 
> Yes, I'll do that.
>
> 

Appreciated.

Gr. AvS

