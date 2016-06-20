Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:33025 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754273AbcFTUlL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Jun 2016 16:41:11 -0400
Subject: Re: ath9k: Support 4.9Ghz channels on AR9580 adapter.
To: Kalle Valo <kvalo@qca.qualcomm.com>
References: <300e3070916441609ff73ea8e06ddb77@euamsexm01a.eu.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
From: Ben Greear <greearb@candelatech.com>
Message-ID: <576854E5.5030206@candelatech.com> (sfid-20160620_224131_439949_979E2C1C)
Date: Mon, 20 Jun 2016 13:41:09 -0700
MIME-Version: 1.0
In-Reply-To: <300e3070916441609ff73ea8e06ddb77@euamsexm01a.eu.qualcomm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/20/2016 01:34 PM, Kalle Valo wrote:
> Ben Greear <greearb@candelatech.com> wrote:
>> From: Ben Greear <greearb@candelatech.com>
>>
>> NOTE:  These channels must not be used in most regulatory
>> domains unless you have a license from the FCC or similar!
>>
>> A proper regulatory database is also required to actually use
>> these channels.
>>
>> Signed-off-by: Ben Greear <greearb@candelatech.com>
>
> I feel that the license is a problem and this doesn't belong to the kernel.
> The patch has been dropped.

It's not a lot different from having to be in normal FCC regulations w/regard to
DFS channels, tx power, and such, but maybe having driver support is considered to make it
too easy for users to hack around restrictions?

Another part of this is that Cisco APs, at least, use fractional center
frequencies (4942.5, for instance) when using 5Mhz bandwidths on 4.9Ghz
channels, and that requires more patches that I don't think I even bothered
to post.

I'll keep this in my trees, someone needing it can just clone it and/or borrow
patches as needed.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

