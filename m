Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:51474 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757183AbcH2L2b (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 29 Aug 2016 07:28:31 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-firmware@kernel.org,
        Xose Vazquez Perez <xose.vazquez@gmail.com>,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH linux-firmware] rt2870sta: Update rt3071.bin to match rt2870.bin
References: <20160828223730.GD10601@decadent.org.uk>
Date: Mon, 29 Aug 2016 14:28:27 +0300
In-Reply-To: <20160828223730.GD10601@decadent.org.uk> (Ben Hutchings's message
        of "Sun, 28 Aug 2016 23:37:30 +0100")
Message-ID: <87zinv3jc4.fsf@purkki.adurom.net> (sfid-20160829_132853_078334_014F08CF)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ben Hutchings <ben@decadent.org.uk> writes:

> rt3071.bin is a copy of the second firmware image in rt2870.bin,
> used only by the old rt2870sta driver.
>
> Update it to version 0.36.
>
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> ---
> The rt2870sta driver used rt3070.bin and rt3071.bin from version
> 2.6.34 to 2.6.38 inclusive.  But that might be old enough that we
> could reasonably remove them now.
>
> If I don't hear objections, I'll apply this in a few days.
>
> Ben.
>
>  rt3071.bin | Bin 4096 -> 4096 bytes
>  1 file changed, 0 insertions(+), 0 deletions(-)

Please CC linux-wireless on wireless related changes. Not everyone
follow lkml.

-- 
Kalle Valo
