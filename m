Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:34378 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751974AbcBJReX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Feb 2016 12:34:23 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Emil Goode <emil.fsw@goode.io>
Cc: Shahar Patury <shaharp@ti.com>, Guy Mishol <guym@ti.com>,
	Igor Grinberg <grinberg@compulab.co.il>,
	Uri Mashiach <uri.mashiach@compulab.co.il>,
	Ross Green <rgkernel@gmail.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wlcore: Fix regression in wlcore_set_partition()
References: <20160210012216.GA18819@lianli>
Date: Wed, 10 Feb 2016 19:34:16 +0200
In-Reply-To: <20160210012216.GA18819@lianli> (Emil Goode's message of "Wed, 10
	Feb 2016 02:22:16 +0100")
Message-ID: <87k2mctqp3.fsf@kamboji.qca.qualcomm.com> (sfid-20160210_183445_234075_21CA58DE)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Emil Goode <emil.fsw@goode.io> writes:

> The below commit introduced a regression causing the wlcore
> to time out and go into recovery.
>
> commit 3719c17e1816695f415dd3b4ddcb679f7dc617c8
> ("wlcore/wl18xx: fw logger over sdio")
>
> Reverting the changes regarding write of the last partition size
> brings the module back to it's functional state.
>
> Reported-by: Ross Green <rgkernel@gmail.com>
> Signed-off-by: Emil Goode <emil.fsw@goode.io>

A proper "Fixes:" line is good to have, but I can add it.

I'm planning to queue this to 4.5.

-- 
Kalle Valo
