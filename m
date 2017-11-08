Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:51026 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752265AbdKHMFh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 8 Nov 2017 07:05:37 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [1/7] brcmfmac: handle FWHALT mailbox indication
References: <5A02DCC0.8000406@broadcom.com>
Date: Wed, 08 Nov 2017 14:05:33 +0200
In-Reply-To: <5A02DCC0.8000406@broadcom.com> (Arend van Spriel's message of
        "Wed, 8 Nov 2017 11:30:24 +0100")
Message-ID: <8760algelu.fsf@codeaurora.org> (sfid-20171108_130540_941436_8E82150A)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend van Spriel <arend.vanspriel@broadcom.com> writes:

> Hi Kalle,
>
> I was preparing a new patch series and got a bit confused. Turns out
> there was a series still pending in patchwork.
>
> https://patchwork.kernel.org/patch/9948825/

That's not pending, it's in "Changes Requested" meaning that I have
dropped them:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches#checking_state_of_patches_from_patchwork

"Deferred" is the state when patch is pending an action from me. Yes,
patchwork state names suck :)

> So I applied the pending series on wireless-drivers-next and it
> compiles fine. So what I think happened is that the series depended on
> a patch that was submitted to wireless-drivers at that time. Can these
> patches be taken now or do I need to resubmit.

To keep things simple I would prefer you resubmit them. I'm at Netdev
2.2 right now so on a quite tight schedule to get everything ready
before the weekend when the merge window opens.

-- 
Kalle Valo
