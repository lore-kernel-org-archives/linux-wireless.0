Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:43671 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751140AbcJCNEM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 3 Oct 2016 09:04:12 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2] mwifiex: report wakeup for wowlan
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1475027104-17423-1-git-send-email-rajatja@google.com>
References: <1475027104-17423-1-git-send-email-rajatja@google.com>
To: Rajat Jain <rajatja@google.com>
Cc: Amitkumar Karwar <akarwar@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Rajat Jain <rajatja@google.com>,
        Wei-Ning Huang <wnhuang@google.com>,
        Brian Norris <briannorris@google.com>,
        Eric Caruso <ejcaruso@chromium.org>, rajatxjain@gmail.com
Message-Id: <20161003130411.68CD2618B2@smtp.codeaurora.org> (sfid-20161003_150419_964442_7D4B7CF7)
Date: Mon,  3 Oct 2016 13:04:11 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rajat Jain <rajatja@google.com> wrote:
> Enable notifying wakeup source to the PM core in case of
> a wake on wireless LAN event.
> 
> Signed-off-by: Wei-Ning Huang <wnhuang@google.com>
> Signed-off-by: Rajat Jain <rajatja@google.com>
> Tested-by: Wei-Ning Huang <wnhuang@chromium.org>
> Reviewed-by: Eric Caruso <ejcaruso@chromium.org>
> Acked-by: Amitkumar Karwar <akarwar@marvell.com>

The commit log doesn't give any background info. Does this fix a bug or
why is it needed?

Patch set to Changes Requested.

-- 
https://patchwork.kernel.org/patch/9353051/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
