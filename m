Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:50696 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755807AbdERNdt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 18 May 2017 09:33:49 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [4/4] mwifiex: pcie: de-duplicate buffer allocation code
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170311013924.73348-5-briannorris@chromium.org>
References: <20170311013924.73348-5-briannorris@chromium.org>
To: Brian Norris <briannorris@chromium.org>
Cc: Amitkumar Karwar <akarwar@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rajat Jain <rajatja@google.com>,
        Brian Norris <briannorris@chromium.org>
Message-Id: <20170518133348.54D3A60F5E@smtp.codeaurora.org> (sfid-20170518_153434_532387_33C9265C)
Date: Thu, 18 May 2017 13:33:48 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Brian Norris <briannorris@chromium.org> wrote:
> This code was duplicated as part of the PCIe FLR code added to this
> driver. Let's de-duplicate it to:
> 
>  * make things easier to read (mwifiex_pcie_free_buffers() now has a
>    corresponding mwifiex_pcie_alloc_buffers())
>  * reduce likelihood of bugs
>  * make error logging equally verbose
>  * save lines of code!
> 
> Also drop some of the commentary that isn't really needed.
> 
> Signed-off-by: Brian Norris <briannorris@chromium.org>

Failed to apply:

fatal: sha1 information is lacking or useless (drivers/net/wireless/marvell/mwifiex/pcie.c).
error: could not build fake ancestor
Applying: mwifiex: pcie: de-duplicate buffer allocation code
Patch failed at 0001 mwifiex: pcie: de-duplicate buffer allocation code
The copy of the patch that failed is found in: .git/rebase-apply/patch

Patch set to Changes Requested.

-- 
https://patchwork.kernel.org/patch/9618309/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
