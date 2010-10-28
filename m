Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:46332 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756171Ab0J1Xol (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Oct 2010 19:44:41 -0400
Message-ID: <4CCA0AE6.3040701@candelatech.com>
Date: Thu, 28 Oct 2010 16:44:38 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <lrodriguez@Atheros.com>
CC: "ath9k-devel@venema.h4ckr.net" <ath9k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [ath9k-devel] [PATCH] ath9k: Clear DMA addresses when buffers
 are freed.
References: <1287178199-7506-1-git-send-email-greearb@candelatech.com> <4CCA0848.7080001@candelatech.com> <20101028233636.GB2985@tux>
In-Reply-To: <20101028233636.GB2985@tux>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/28/2010 04:36 PM, Luis R. Rodriguez wrote:
> On Thu, Oct 28, 2010 at 04:33:28PM -0700, Ben Greear wrote:
>> On 10/15/2010 02:29 PM, greearb@candelatech.com wrote:
>>> From: Ben Greear<greearb@candelatech.com>
>>>
>>> Previous patches cleared the pointer to the SKB, but did not
>>> clear the DMA addresses.  This patch moves the clear logic into
>>> a method and makes sure that the DMA addresses are cleared as well.
>>>
>>> This does not obviously fix any bug, but may make it harder to
>>> cause bugs in the future.
>>
>> I wanted to follow up to see if there was any interest in this patch,
>> as it received no comment and has not been accepted upstream.
>
> I'd rather not introduce code unless you know
> for sure its doing something useful.

I don't think it makes any real difference, so we can just drop it.

Thanks,
Ben

>
>   Luis


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

