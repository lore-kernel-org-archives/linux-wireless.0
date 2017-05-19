Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:46640 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751871AbdESGBh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 19 May 2017 02:01:37 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2] mwifiex: pcie: de-duplicate buffer allocation code
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170518163447.29496-1-briannorris@chromium.org>
References: <20170518163447.29496-1-briannorris@chromium.org>
To: Brian Norris <briannorris@chromium.org>
Cc: Amitkumar Karwar <amitkarwar@gmail.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Brian Norris <briannorris@chromium.org>
Message-Id: <20170519060136.CA44A60EC7@smtp.codeaurora.org> (sfid-20170519_080149_166324_E6E2212E)
Date: Fri, 19 May 2017 06:01:36 +0000 (UTC)
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

Patch applied to wireless-drivers-next.git, thanks.

d41bf5c1c0ed mwifiex: pcie: de-duplicate buffer allocation code

-- 
https://patchwork.kernel.org/patch/9734777/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
