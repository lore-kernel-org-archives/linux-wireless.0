Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:44892 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754086AbcGHLBK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jul 2016 07:01:10 -0400
Date: Fri, 8 Jul 2016 16:30:53 +0530
From: Mohammed Shafi Shajakhan <mohammed@codeaurora.org>
To: Ben Greear <greearb@candelatech.com>
Cc: "Valo, Kalle" <kvalo@qca.qualcomm.com>,
	"Raja, Tamizh Chelvam" <c_traja@qti.qualcomm.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	"Shajakhan, Mohammed Shafi (Mohammed Shafi)"
	<mohammed@qti.qualcomm.com>
Subject: Re: [PATCH 2/2] ath10k: Fix sending NULL/ Qos NULL data frames for
 QCA99X0 and later
Message-ID: <20160708110053.GA19841@atheros-ThinkPad-T61> (sfid-20160708_130115_310554_6094B037)
References: <1466700001-4883-1-git-send-email-mohammed@qca.qualcomm.com>
 <1466700001-4883-2-git-send-email-mohammed@qca.qualcomm.com>
 <576C1861.7020402@candelatech.com>
 <20160625185350.GA25330@atheros-ThinkPad-T61>
 <576F2165.3010109@candelatech.com>
 <8760sr6kj8.fsf@kamboji.qca.qualcomm.com>
 <577BD05D.6000607@candelatech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <577BD05D.6000607@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Michal / Kalle / Ben,

is this patch is good to go (or) should i re-work  ?
I had replied to Michal's comment of introducing a new firmware
feature flag will not address the issue in older firmware / code.
Let me know if i had missed something very obvious.


On Tue, Jul 05, 2016 at 08:21:01AM -0700, Ben Greear wrote:
> On 06/30/2016 03:25 AM, Valo, Kalle wrote:
> >Ben Greear <greearb@candelatech.com> writes:
> >
> >>Is there a better way than posting to the ath10k mailing list?  There are quite
> >>a few more of my patches that are stuck in pending or ignored state.  If you
> >>could review some of them and add them to your testing trees then it might help
> >>them go upstream.
> >
> >Yes, as you seem to test with your custom ath10k and custom firmware
> >review and testing feedback from others is more than welcome. That way I
> >can have more confidence that the patch really works with the mainline
> >version.
> >
> >The problem with your patches is that you dump more responsibility on
> >me. I have no idea if they work with the mainline kernel, or if they
> >break something, so I need to personally test the patch and that takes
> >time. Basically I have a rule if that I need to use more than two
> >minutes on a patch it goes to the Deferred queue and I'll go through
> >that less often than the normal patch queue.
> 
> I can do some testing with stock firmware, but stock firmware is often quite limited
> so I cannot do the more interesting test cases that we use internally.
> Some of my patches are for fixing edge cases that cannot be easily reproduced,
> and that code really needs to be reviewed for correctness more by looking at
> the code than by trying to run some exhaustive test case.
> 
> I think if there were a specific maintainer for ath10k that could take a more
> active role, especially with regard to keeping a fairly wide variety of test rigs
> around to run regression tests, then it would help all involved.  I think this person
> needs access to firmware source so that they can more easily verify the driver
> matches the firmware:  Many of the regressions and bug fixes, for instance with
> stats, would be much easier to clean up if you look at firmware while developing
> the driver bits.
>

regards,
shafi
