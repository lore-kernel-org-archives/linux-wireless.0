Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:52253 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003AbbEINfL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 May 2015 09:35:11 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Florian Achleitner <flo@fopen.at>
Cc: linux-wireless@vger.kernel.org,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Maithili Hinge <maithili@marvell.com>
Subject: Re: [PATCH] mwifiex: Trigger a card reset on "DNLD_CMD: host to card failed".
References: <3169170.GKjfvNuGRf@r90b40zn> <2350188.9S0zOEq5AR@r90b40zn>
Date: Sat, 09 May 2015 16:35:03 +0300
In-Reply-To: <2350188.9S0zOEq5AR@r90b40zn> (Florian Achleitner's message of
	"Thu, 16 Apr 2015 11:14:48 +0200")
Message-ID: <87egmpnabc.fsf@kamboji.qca.qualcomm.com> (sfid-20150509_153515_861924_04D39E07)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Florian Achleitner <flo@fopen.at> writes:

> Whenever this problem occurs, the driver can not continue. Thus,
> trigger a card reset to restart the module firmware. Other firmware
> communication issues are resolved by this last resort.
> Also dump registers, to eventually allow some diagnostics.
>
> Signed-off-by: Florian Achleitner <flo@fopen.at>

Doesn't apply to wireless-drivers-next.git. Can you rebase, please?

-- 
Kalle Valo
