Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:42636 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754268AbdIRNRM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 18 Sep 2017 09:17:12 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Ganapathi Bhat <gbhat@marvell.com>
Cc: <linux-wireless@vger.kernel.org>,
        Brian Norris <briannorris@chromium.org>,
        Cathy Luo <cluo@marvell.com>, Xinming Hu <huxm@marvell.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        James Cao <jcao@marvell.com>,
        Mangesh Malusare <mmangesh@marvell.com>
Subject: Re: [PATCH 2/2] mwifiex: use get_random_mask_addr() helper
References: <1505720537-13362-1-git-send-email-gbhat@marvell.com>
Date: Mon, 18 Sep 2017 16:17:07 +0300
In-Reply-To: <1505720537-13362-1-git-send-email-gbhat@marvell.com> (Ganapathi
        Bhat's message of "Mon, 18 Sep 2017 13:12:17 +0530")
Message-ID: <87o9q8kuy4.fsf@purkki.adurom.net> (sfid-20170918_151715_643732_26937645)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ganapathi Bhat <gbhat@marvell.com> writes:

> Avoid calculating random MAC address in driver. Instead make
> use of 'get_random_mask_addr()' function.
>
> Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>

I don't see 1/2 anywhere. Did it get lost?

-- 
Kalle Valo
