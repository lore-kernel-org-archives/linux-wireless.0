Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3974 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752373Ab2HMUGE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Aug 2012 16:06:04 -0400
Message-ID: <50295E22.2010705@broadcom.com> (sfid-20120813_220608_302434_DDDB5F47)
Date: Mon, 13 Aug 2012 22:05:54 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Vladimir Zapolskiy" <vz@mleia.com>,
	linux-wireless@vger.kernel.org, brcm80211-dev-list@broadcom.com
Subject: Re: [PATCH] brcm80211: smac: set interface down on reset
References: <1344115747-25627-1-git-send-email-vz@mleia.com>
 <50201D62.2020701@mleia.com> <50201EDD.30408@broadcom.com>
 <20120813185042.GD10529@tuxdriver.com>
In-Reply-To: <20120813185042.GD10529@tuxdriver.com>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/13/2012 08:50 PM, John W. Linville wrote:
> On Mon, Aug 06, 2012 at 09:45:33PM +0200, Arend van Spriel wrote:
>> On 08/06/2012 09:39 PM, Vladimir Zapolskiy wrote:
>>> Hi Arend,
>>>
>>> what do you think about the proposed change? For me the problem is
>>> quite severe, for the last several months I had to patch the kernel
>>> to have functional BCM43225 on my laptop, hopefully the fix should go to
>>> the
>>> stable branches as well.
>>>
>>
>> I have forwarded it to my colleagues. I may want to revise the fix  a
>> little and have it applied to stable as well. I was not aware that this
>> scenario occurs frequently. Thanks for addressing your issue so
>> proactively ;-)
> 
> Any word on the state of this fix?
> 
> John
> 

Hi John,

This change was briefly discussed internally. The patch will
reinitialize the entire driver and device. While this probably works it
may be overkill. OTOH it is better that than no solution. I suggest to
apply this and have us come up with a more definite fix later at which
we can move both patches to stable.

Gr. AvS


