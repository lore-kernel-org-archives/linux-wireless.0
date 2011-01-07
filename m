Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:39441 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753657Ab1AGBD6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Jan 2011 20:03:58 -0500
Message-ID: <4D266679.50504@candelatech.com>
Date: Thu, 06 Jan 2011 17:03:53 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net,
	Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [ath9k-devel] [PATCH 1/3] ath9k: Decrease skb size to fit into
 one page.
References: <1294361165-15308-1-git-send-email-greearb@candelatech.com> <AANLkTin2YS4akjJpAhagqesoNO-5D=ngbMJLOqS8-yQu@mail.gmail.com>
In-Reply-To: <AANLkTin2YS4akjJpAhagqesoNO-5D=ngbMJLOqS8-yQu@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/06/2011 04:57 PM, Luis R. Rodriguez wrote:
> On Thu, Jan 6, 2011 at 4:46 PM,<greearb@candelatech.com>  wrote:
>> From: Ben Greear<greearb@candelatech.com>
>>
>> Patch is from Eric Dumazet, as described here:
>> https://patchwork.kernel.org/patch/104271/
>>
>> Reported-by: Michael Guntsche<mike@it-loops.com>
>> Signed-off-by: Eric Dumazet<eric.dumazet@gmail.com>
>
> Did he SOB it?

I guess not explicitly.  But, it's a small little patch that has been
languishing for 6 months.  Please put the fix in one way or another.
I don't care that I get any credit what-so-ever.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

