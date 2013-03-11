Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hub022-nj-2.exch022.serverdata.net ([206.225.164.185]:29457
	"EHLO HUB022-nj-2.exch022.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750923Ab3CKPV2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Mar 2013 11:21:28 -0400
Message-ID: <513DF675.3000800@posedge.com> (sfid-20130311_162132_473900_26A3F87E)
Date: Mon, 11 Mar 2013 20:51:25 +0530
From: Mahesh Palivela <maheshp@posedge.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mac80211: Enable sw scan with chan context
References: <513DE4BB.9010104@posedge.com> <1363012784.5284.5.camel@jlt4.sipsolutions.net>
In-Reply-To: <1363012784.5284.5.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 3/11/2013 8:09 PM, Johannes Berg wrote:
> On Mon, 2013-03-11 at 19:35 +0530, Mahesh Palivela wrote:
>> From: Mahesh Palivela <maheshp@posedge.com>
>>
>> Enable software scan with channel context in use.
>
> I don't think this will even work, but even if it did I think it's too
> painful with off-channel etc.
>

I tested this patch. scan works. Anyways chan context is a WIP.
There is no driver which is using the chan ctx work yet.
I will continue adding code for chan ctx.

> johannes
>

-- 
Thanks,
Mahesh
