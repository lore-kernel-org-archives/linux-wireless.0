Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:58394 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933175AbdEXIgt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 May 2017 04:36:49 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Xinming Hu <huxinming820@gmail.com>
Cc: Linux Wireless <linux-wireless@vger.kernel.org>,
        Brian Norris <briannorris@google.com>,
        Dmitry Torokhov <dtor@google.com>, rajatja@google.com,
        Zhiyuan Yang <yangzy@marvell.com>,
        Cathy Luo <cluo@marvell.com>, Xinming Hu <huxm@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>
Subject: Re: [PATCH v4 1/5] mwifiex: use variable interface header length
References: <1495523554-30753-1-git-send-email-huxinming820@gmail.com>
Date: Wed, 24 May 2017 11:36:26 +0300
In-Reply-To: <1495523554-30753-1-git-send-email-huxinming820@gmail.com>
        (Xinming Hu's message of "Tue, 23 May 2017 07:12:30 +0000")
Message-ID: <8737buslbp.fsf@kamboji.qca.qualcomm.com> (sfid-20170524_103847_086424_60F1BC1E)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Xinming Hu <huxinming820@gmail.com> writes:

> From: Xinming Hu <huxm@marvell.com>
>
> Usb tx aggregation feature will utilize 4-bytes bus interface header,
> otherwise it will be set to zero in default case.
>
> Signed-off-by: Xinming Hu <huxm@marvell.com>
> Signed-off-by: Cathy Luo <cluo@marvell.com>
> Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>
> ---
> Drop 5/6 patch in v3
> v4: same as v1,v2,v3

BTW, I would prefer that you don't use my qualcomm.com address when
submitting patches. Using codeaurora.org or not CCing me at all (as I
take all patches from patchwork anyway) is much better for me.

-- 
Kalle Valo
