Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:37446 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751510AbeEPNg0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 16 May 2018 09:36:26 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH V2 1/6] brcmfmac: move ALLFFMAC variable in flowring module
References: <1526472723-15758-1-git-send-email-arend.vanspriel@broadcom.com>
        <1526472723-15758-2-git-send-email-arend.vanspriel@broadcom.com>
Date: Wed, 16 May 2018 16:36:22 +0300
In-Reply-To: <1526472723-15758-2-git-send-email-arend.vanspriel@broadcom.com>
        (Arend van Spriel's message of "Wed, 16 May 2018 14:11:58 +0200")
Message-ID: <87lgcjlo2x.fsf@kamboji.qca.qualcomm.com> (sfid-20180516_153632_269379_7FA2926A)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend van Spriel <arend.vanspriel@broadcom.com> writes:

> The only user of ALLFFMAC is the flowring module so no need to
> expose it in a header file.
>
> Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
> Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
> Reviewed-by: Franky Lin <franky.lin@broadcom.com>
> Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> ---
> Hi Kalle,
>
> I recall Joe Perches posted patches dealing with broadcast address declarations,
> but don't know what happened with those. In patchwork [1] is says 'Not Applicable'
> whatever that means. I noticed Johannes set similar mac80211 change to
> 'Awaiting Upstream'. Anyway, when applying this patch the patch in [1] needs to
> be reworked.
>
> Regards,
> Arend
>
> [1] https://patchwork.kernel.org/patch/10318857/

'Not Applicable' means that I have assumed that the patch is not
suitable for my tree for whatever reason, I guess in this case because
it was part of a bigger patchset.

-- 
Kalle Valo
