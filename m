Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:42351 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751870AbbEKGfn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 May 2015 02:35:43 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Florian Achleitner <flo@fopen.at>
Cc: linux-wireless@vger.kernel.org,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Maithili Hinge <maithili@marvell.com>
Subject: Re: [PATCH] mwifiex: Trigger a card reset on "DNLD_CMD: host to card failed".
References: <3169170.GKjfvNuGRf@r90b40zn> <2350188.9S0zOEq5AR@r90b40zn>
	<87egmpnabc.fsf@kamboji.qca.qualcomm.com>
	<5773845.ktey5e8Qlm@flobuntu>
Date: Mon, 11 May 2015 09:35:35 +0300
In-Reply-To: <5773845.ktey5e8Qlm@flobuntu> (Florian Achleitner's message of
	"Sat, 09 May 2015 18:18:02 +0200")
Message-ID: <87fv73liyw.fsf@kamboji.qca.qualcomm.com> (sfid-20150511_083546_394521_6DC7199E)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Florian Achleitner <flo@fopen.at> writes:

> On Saturday 09 May 2015 16:35:03 Kalle Valo wrote:
>> Florian Achleitner <flo@fopen.at> writes:
>> > Whenever this problem occurs, the driver can not continue. Thus,
>> > trigger a card reset to restart the module firmware. Other firmware
>> > communication issues are resolved by this last resort.
>> > Also dump registers, to eventually allow some diagnostics.
>> > 
>> > Signed-off-by: Florian Achleitner <flo@fopen.at>
>> 
>> Doesn't apply to wireless-drivers-next.git. Can you rebase, please?
>
> Please drop my patch! We agreed that it likely tries to fix a problem actually 
> caused in MMC system.

Sorry, I had missed that as patchwork didn't contain anything. In the
future it's a good idea to reply to the patch and say something like
"Kalle, please drop this because of foo". That way I see it in
patchwork:

https://patchwork.kernel.org/patch/6224961/

-- 
Kalle Valo
