Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from li271-223.members.linode.com ([178.79.152.223]:58423 "EHLO
	mail.mleia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751209Ab2HFUHC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Aug 2012 16:07:02 -0400
Message-ID: <502023DF.1020107@mleia.com>
Date: Mon, 06 Aug 2012 23:06:55 +0300
From: Vladimir Zapolskiy <vz@mleia.com>
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>
CC: linux-wireless@vger.kernel.org, brcm80211-dev-list@broadcom.com
Subject: Re: [PATCH] brcm80211: smac: set interface down on reset
References: <1344115747-25627-1-git-send-email-vz@mleia.com> <50201D62.2020701@mleia.com> <50201EDD.30408@broadcom.com>
In-Reply-To: <50201EDD.30408@broadcom.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06.08.2012 22:45, Arend van Spriel wrote:
> On 08/06/2012 09:39 PM, Vladimir Zapolskiy wrote:
>> Hi Arend,
>>
>> what do you think about the proposed change? For me the problem is
>> quite severe, for the last several months I had to patch the kernel
>> to have functional BCM43225 on my laptop, hopefully the fix should go to
>> the
>> stable branches as well.
>>
>
> I have forwarded it to my colleagues. I may want to revise the fix  a
> little and have it applied to stable as well. I was not aware that this
> scenario occurs frequently. Thanks for addressing your issue so
> proactively ;-)

Thank you in advance. If you need any additional info from my side,
feel free to contact me.

-- 
With best wishes,
Vladimir
