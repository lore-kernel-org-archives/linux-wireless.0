Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:56108 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936456AbcKQRbS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 17 Nov 2016 12:31:18 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [TEST, V2, GIT-SEND-EMAIL,
 01/11] mwifiex: fix power save issue when suspend
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1477899763-10273-1-git-send-email-huxinming820@gmail.com>
References: <1477899763-10273-1-git-send-email-huxinming820@gmail.com>
To: Xinming Hu <huxinming820@gmail.com>
Cc: linux-wireless@vger.kernel.org, Shengzhen Li <szli@marvell.com>
Message-Id: <20161117124426.174D56162A@smtp.codeaurora.org> (sfid-20161117_183133_956312_89D3BE22)
Date: Thu, 17 Nov 2016 12:44:26 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Xinming Hu <huxinming820@gmail.com> wrote:
> From: Shengzhen Li <szli@marvell.com>
> 
> This patch fixes a corner case for "FROMLIST: mwifiex: fix corner case
> power save issue", main process will check the power save condition in
> PS_PRE_SLEEP status so the sleep handshake could continue.
> 
> Signed-off-by: Shengzhen Li <szli@marvell.com>

Seems to be a test mail of some sort so I'll just drop this.

Patch set to Not Applicable.

-- 
https://patchwork.kernel.org/patch/9405111/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
