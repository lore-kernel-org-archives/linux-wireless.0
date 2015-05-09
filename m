Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fopen.at ([151.236.7.194]:52138 "EHLO fopen.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750909AbbEIQSF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 May 2015 12:18:05 -0400
From: Florian Achleitner <flo@fopen.at>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Maithili Hinge <maithili@marvell.com>
Subject: Re: [PATCH] mwifiex: Trigger a card reset on "DNLD_CMD: host to card failed".
Date: Sat, 09 May 2015 18:18:02 +0200
Message-ID: <5773845.ktey5e8Qlm@flobuntu> (sfid-20150509_181812_713279_621F96E5)
In-Reply-To: <87egmpnabc.fsf@kamboji.qca.qualcomm.com>
References: <3169170.GKjfvNuGRf@r90b40zn> <2350188.9S0zOEq5AR@r90b40zn> <87egmpnabc.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 09 May 2015 16:35:03 Kalle Valo wrote:
> Florian Achleitner <flo@fopen.at> writes:
> > Whenever this problem occurs, the driver can not continue. Thus,
> > trigger a card reset to restart the module firmware. Other firmware
> > communication issues are resolved by this last resort.
> > Also dump registers, to eventually allow some diagnostics.
> > 
> > Signed-off-by: Florian Achleitner <flo@fopen.at>
> 
> Doesn't apply to wireless-drivers-next.git. Can you rebase, please?

Please drop my patch! We agreed that it likely tries to fix a problem actually 
caused in MMC system.

Florian
