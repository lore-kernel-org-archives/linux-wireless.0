Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:39436 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750965AbdG0GRs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Jul 2017 02:17:48 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Ian Molton <ian@mnementh.co.uk>
Cc: linux-wireless@vger.kernel.org, arend.vanspriel@broadcom.com,
        franky.lin@broadcom.com, hante.meuleman@broadcom.com
Subject: Re: Patch v4: Clean up brcmfmac driver
References: <20170726202557.15632-1-ian@mnementh.co.uk>
Date: Thu, 27 Jul 2017 09:17:44 +0300
In-Reply-To: <20170726202557.15632-1-ian@mnementh.co.uk> (Ian Molton's message
        of "Wed, 26 Jul 2017 21:25:23 +0100")
Message-ID: <878tjaxv1z.fsf@purkki.adurom.net> (sfid-20170727_081751_804488_779C1D57)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ian Molton <ian@mnementh.co.uk> writes:

> Here's a v4 of the cleanup patchset - checkpatch clean(er - I have purposely
> left some warnings unaddressed).
>
> I also dropped an accidental adjustment of a debug macro from v3.

Like I said already last time, please split the patchset into reasonable
sizes (and submit one patchset at a time). I will automatically drop
patchbombs like this.

-- 
Kalle Valo
