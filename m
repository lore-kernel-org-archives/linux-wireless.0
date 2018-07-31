Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:48470 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727135AbeGaIhY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 31 Jul 2018 04:37:24 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [PATCH] mwifiex: Fix skipped vendor specific IEs
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1532432847-2885-1-git-send-email-roman.stratiienko@globallogic.com>
References: <1532432847-2885-1-git-send-email-roman.stratiienko@globallogic.com>
To: roman.stratiienko@globallogic.com
Cc: akarwar@marvell.com, nishants@marvell.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, sergei.shtylyov@cogentembedded.com,
        Roman Stratiienko <roman.stratiienko@globallogic.com>
Message-Id: <20180731065835.0027C606DD@smtp.codeaurora.org> (sfid-20180731_085848_730389_52563C16)
Date: Tue, 31 Jul 2018 06:58:34 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

roman.stratiienko@globallogic.com wrote:

> From: Roman Stratiienko <roman.stratiienko@globallogic.com>
> 
> Mwifiex firmware inserts only Microsoft information element
> Allow other vendor specific IEs to pass from userspace
> 
> Signed-off-by: Roman Stratiienko <roman.stratiienko@globallogic.com>

When you submit a new version fo a patch please always add a version number to
the title and include a changelog:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches#patch_version_missing

But this is for the future, no need to resend this patch.

-- 
https://patchwork.kernel.org/patch/10541923/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
