Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:36980 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751346AbdFAJvT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Jun 2017 05:51:19 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: mwifiex: simplify the code around ra_list
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1495762909-46795-1-git-send-email-shawn.lin@rock-chips.com>
References: <1495762909-46795-1-git-send-email-shawn.lin@rock-chips.com>
To: Shawn Lin <shawn.lin@rock-chips.com>
Cc: Amitkumar Karwar <amitkarwar@gmail.com>,
        Xinming Hu <huxm@marvell.com>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Shawn Lin <shawn.lin@rock-chips.com>
Message-Id: <20170601095059.D42C86077A@smtp.codeaurora.org> (sfid-20170601_115127_488381_6FA9B444)
Date: Thu,  1 Jun 2017 09:50:59 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Shawn Lin <shawn.lin@rock-chips.com> wrote:

> We don't need to check if the list is empty separately
> as we could use list_first_entry_or_null to cover it.
> 
> Signed-off-by: Shawn Lin <shawn.lin@rock-chips.com>
> Reviewed-by: Brian Norris <briannorris@chromium.org>

Patch applied to wireless-drivers-next.git, thanks.

01926202b34b mwifiex: simplify the code around ra_list

-- 
https://patchwork.kernel.org/patch/9749573/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
