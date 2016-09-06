Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:39573
        "EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755737AbcIFMMk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 6 Sep 2016 08:12:40 -0400
Subject: Re: mwifiex: propagate error if IRQ request fails in
 mwifiex_sdio_of()
To: Kalle Valo <kvalo@codeaurora.org>
References: <20160903103520.8C69C6201B@smtp.codeaurora.org>
Cc: linux-kernel@vger.kernel.org,
        Amitkumar Karwar <akarwar@marvell.com>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org,
        Nishant Sarmukadam <nishants@marvell.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
From: Javier Martinez Canillas <javier@osg.samsung.com>
Message-ID: <66735eb5-c831-8e06-337b-80ccfc392061@osg.samsung.com> (sfid-20160906_141302_371384_9A7E9E05)
Date: Tue, 6 Sep 2016 14:12:33 +0200
MIME-Version: 1.0
In-Reply-To: <20160903103520.8C69C6201B@smtp.codeaurora.org>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Kalle,

On 09/03/2016 12:35 PM, Kalle Valo wrote:
> Javier Martinez Canillas <javier@osg.samsung.com> wrote:
>> If request_irq() fails in mwifiex_sdio_probe_of(), only an error message
>> is printed but the actual error is not propagated to the caller function.
>>
>> Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
> 
> What's the conclusion with this patch? Should I drop it or take it?
> 
> (The discussion is available from the patchwork link in the signature.)
> 

My understanding is that Arend agrees with the patch and that the question
raised was caused by looking at an older kernel version. IOW, the patch is
OK and should be picked.

I'm adding Arend to cc, so can comment in case I misunderstood him though.

Best regards,
-- 
Javier Martinez Canillas
Open Source Group
Samsung Research America
