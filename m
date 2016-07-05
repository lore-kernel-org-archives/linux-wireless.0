Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:57855 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544AbcGEPVF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jul 2016 11:21:05 -0400
Message-ID: <577BD05D.6000607@candelatech.com> (sfid-20160705_172110_707788_A87E5F01)
Date: Tue, 05 Jul 2016 08:21:01 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "Valo, Kalle" <kvalo@qca.qualcomm.com>
CC: Mohammed Shafi Shajakhan <mohammed@codeaurora.org>,
	"Raja, Tamizh Chelvam" <c_traja@qti.qualcomm.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	"Shajakhan, Mohammed Shafi (Mohammed Shafi)"
	<mohammed@qti.qualcomm.com>
Subject: Re: [PATCH 2/2] ath10k: Fix sending NULL/ Qos NULL data frames for
 QCA99X0 and later
References: <1466700001-4883-1-git-send-email-mohammed@qca.qualcomm.com>	<1466700001-4883-2-git-send-email-mohammed@qca.qualcomm.com>	<576C1861.7020402@candelatech.com>	<20160625185350.GA25330@atheros-ThinkPad-T61>	<576F2165.3010109@candelatech.com> <8760sr6kj8.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <8760sr6kj8.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/30/2016 03:25 AM, Valo, Kalle wrote:
> Ben Greear <greearb@candelatech.com> writes:
>
>> Is there a better way than posting to the ath10k mailing list?  There are quite
>> a few more of my patches that are stuck in pending or ignored state.  If you
>> could review some of them and add them to your testing trees then it might help
>> them go upstream.
>
> Yes, as you seem to test with your custom ath10k and custom firmware
> review and testing feedback from others is more than welcome. That way I
> can have more confidence that the patch really works with the mainline
> version.
>
> The problem with your patches is that you dump more responsibility on
> me. I have no idea if they work with the mainline kernel, or if they
> break something, so I need to personally test the patch and that takes
> time. Basically I have a rule if that I need to use more than two
> minutes on a patch it goes to the Deferred queue and I'll go through
> that less often than the normal patch queue.

I can do some testing with stock firmware, but stock firmware is often quite limited
so I cannot do the more interesting test cases that we use internally.
Some of my patches are for fixing edge cases that cannot be easily reproduced,
and that code really needs to be reviewed for correctness more by looking at
the code than by trying to run some exhaustive test case.

I think if there were a specific maintainer for ath10k that could take a more
active role, especially with regard to keeping a fairly wide variety of test rigs
around to run regression tests, then it would help all involved.  I think this person
needs access to firmware source so that they can more easily verify the driver
matches the firmware:  Many of the regressions and bug fixes, for instance with
stats, would be much easier to clean up if you look at firmware while developing
the driver bits.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

