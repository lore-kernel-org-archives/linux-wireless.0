Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:56596 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759451Ab0J1Xgz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Oct 2010 19:36:55 -0400
Message-ID: <4CCA0908.6000105@candelatech.com>
Date: Thu, 28 Oct 2010 16:36:40 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Felix Fietkau <nbd@openwrt.org>
CC: =?ISO-8859-1?Q?Bj=F6rn_Smedman?= <bjorn.smedman@venatech.se>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	"ath9k-devel@venema.h4ckr.net" <ath9k-devel@venema.h4ckr.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [ath9k-devel] [RFC] ath9k: Insert wmb before linking dma descriptors
References: <alpine.DEB.2.00.1010042059130.29449@vtdt3>	<20101005131744.GB4074@tuxdriver.com>	<20101005195039.GD11831@tux> <AANLkTikxayNdakE-MrCQWS10nZ3ZQk1pnEcHC+sMck1p@mail.gmail.com> <4CB0890D.3050208@openwrt.org>
In-Reply-To: <4CB0890D.3050208@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/09/2010 08:23 AM, Felix Fietkau wrote:
> On 2010-10-09 5:19 PM, Björn Smedman wrote:
>> On Tue, Oct 5, 2010 at 9:50 PM, Luis R. Rodriguez
>> <lrodriguez@atheros.com>  wrote:
>>> Felix is more familiar with this area so I'll let him chime with
>>> his ACK/NACK.
>>>
>>>   Luis
>>
>> So Felix, what do you think? I realize it may not be a common problem
>> on any currently popular platform, but don't you agree it is in
>> principle unsafe to write to the ds_link field of dma descriptors
>> without a guarantee that those writes will be performed in the
>> intended order?
> Haven't had time to review this in detail yet. I'll take another look at
> it later...

Had a chance to look at it?  I've been carrying this in my
tree and it hasn't caused any obvious problems, for what that's
worth...

Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

