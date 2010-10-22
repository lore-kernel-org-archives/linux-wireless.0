Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:44679 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751838Ab0JVEvY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Oct 2010 00:51:24 -0400
Message-ID: <4CC11840.4060709@candelatech.com>
Date: Thu, 21 Oct 2010 21:51:12 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
CC: Bruno Randolf <br1@einfach.org>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 0/6] ath9k: fix RX poison issue
References: <1287616028-12547-1-git-send-email-lrodriguez@atheros.com> <4CC07CA9.4040808@candelatech.com> <201010220930.01071.br1@einfach.org> <AANLkTi=wTsFnVZ=GGck_ArP6ubT_dOB41ut13od7biwT@mail.gmail.com>
In-Reply-To: <AANLkTi=wTsFnVZ=GGck_ArP6ubT_dOB41ut13od7biwT@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/21/2010 05:32 PM, Luis R. Rodriguez wrote:
> On Thu, Oct 21, 2010 at 5:30 PM, Bruno Randolf<br1@einfach.org>  wrote:
>> On Fri October 22 2010 02:47:21 Ben Greear wrote:
>>> I tested this code when it was combined into a single patch.
>>> There were still some issues, but I have no reason to believe
>>> this patch set caused them.  This patch set significantly
>>> improved stability in my testing with 130+ STA interfaces.
>>
>> one question: do you see similar issues with ath5k? i remember one bug is
>> filed with a rx poision issue.
>
> Hardware is similar so the I'd do the same locking.

We did similar testing with ath5k, and did not see any obvious
problems.  But, maybe we were just getting lucky.

Thanks,
Ben

>
>    Luis


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
