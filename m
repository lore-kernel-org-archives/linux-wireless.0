Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:37811 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754186AbcJLIAn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 12 Oct 2016 04:00:43 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: Revert "rtlwifi: rtl818x: constify local structures"
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20161010152520.9812-1-Larry.Finger@lwfinger.net>
References: <20161010152520.9812-1-Larry.Finger@lwfinger.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Stable <stable@vger.kernel.org>,
        Julia Lawall <Julia.Lawall@lip6.fr>
Message-Id: <20161012080042.4623A61822@smtp.codeaurora.org> (sfid-20161012_100046_710766_61155882)
Date: Wed, 12 Oct 2016 08:00:42 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> wrote:
> This reverts commit d86e64768859fca82c78e52877ceeba04e25d27a.
> 
> For drivers rtl8188ee, rtl8192ce, rtl8192ee, rtl8723ae, and rtl8821ae,
> the Coccinelle script missed the fact that the code changes the firmware
> name. When that happens, the kernel issues a BUG splat because
> it is unable to overwrite the old name.
> 
> Although this bug only affects 5 of the 8 drivers it touched, I decided to
> revert the entire patch. Continuing to constantify the other three could
> too easily lead to introduction of future bugs.
> 
> Fixes: d86e64768859 ("rtlwifi: rtl818x: constify local structures")
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Stable <stable@vger.kernel.org> 
> Cc: Julia Lawall <Julia.Lawall@lip6.fr>

Dropping as requested.

Patch set to Superseded.

-- 
https://patchwork.kernel.org/patch/9369621/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
