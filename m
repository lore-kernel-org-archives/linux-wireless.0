Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:42109 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857AbcASNI1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jan 2016 08:08:27 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Arend van Spriel <arend@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [GIT] Networking
References: <20160112.215136.850414372508130298.davem@davemloft.net>
	<56978094.4050302@arm.com> <87k2n97n5e.fsf@kamboji.qca.qualcomm.com>
	<569CCCD2.4040105@arm.com> <569D61BA.8020701@broadcom.com>
	<569DFA0A.6070900@arm.com>
Date: Tue, 19 Jan 2016 15:08:20 +0200
In-Reply-To: <569DFA0A.6070900@arm.com> (Marc Zyngier's message of "Tue, 19
	Jan 2016 08:55:38 +0000")
Message-ID: <87r3hd4szf.fsf@kamboji.qca.qualcomm.com> (sfid-20160119_140851_122840_D05245C0)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Marc Zyngier <marc.zyngier@arm.com> writes:

>>>> Should we revert the patch or can you Hante fix this? The revert doesn't
>>>> seem to be trivial so I would appreciate if someone could send a patch.
>>>
>>> I've worked out a partial revert (see below) that allows my system to
>>> boot, but I'd rather see a proper fix from the maintainer of this code.
>> 
>> Hi Marc,
>> 
>> Thanks for the patch, but Hante has created a different patch basically
>> deferring the allocation of the sgtable. Feel free to give it a spin on
>> your box and share the results.
>
> Hi Arend,
>
> This patch fixes indeed the problem, thanks (I had to undo the mangling
> your mailer had done, though). So feel free to add my:
>
> Reported-by: Marc Zyngier <marc.zyngier@arm.com>
> Tested-by: Marc Zyngier <marc.zyngier@arm.com>
>
> It would be good if this could make it in -rc1.

I doubt it makes it to -rc1, most likely to -rc2. But let's see.

-- 
Kalle Valo
