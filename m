Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:37108 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751361Ab2LFUPn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Dec 2012 15:15:43 -0500
Message-ID: <50C0FCE0.2090507@candelatech.com> (sfid-20121206_211546_676714_FDC98399)
Date: Thu, 06 Dec 2012 12:15:28 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Stanislaw Gruszka <sgruszka@redhat.com>
CC: =?ISO-8859-1?Q?Bj=F8rn_Mork?= <bjorn@mork.no>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] wireless:  Fix ethtool stats and other ops.
References: <1354729192-22945-1-git-send-email-greearb@candelatech.com> <87a9ts4c1q.fsf@nemi.mork.no> <50BF8C18.9060504@candelatech.com> <20121206122528.GG2502@redhat.com>
In-Reply-To: <20121206122528.GG2502@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/06/2012 04:25 AM, Stanislaw Gruszka wrote:

>>> Won't this break drivers which for some reason have their own
>>> ethtool_ops?
>>
>> I guess it will.  What a mess.
>>
>> Maybe we could assign individual method pointers in the ethtool_ops
>> struct if it already exists (and if those pointers are NULL)?
>
> We should probably assing ethtool_ops before wireless core will
> call alloc_netdev.
>
> Stanislaw
>

I don't have time to work on this today...maybe not tomorrow either.

So, if someone else feels like fixing it, please feel free.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

