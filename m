Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:46864 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753719AbdDEMwS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Apr 2017 08:52:18 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: mwifiex: add missing IEs related to TDLS operation
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1491230210-28489-1-git-send-email-gbhat@marvell.com>
References: <1491230210-28489-1-git-send-email-gbhat@marvell.com>
To: Ganapathi Bhat <gbhat@marvell.com>
Cc: <linux-wireless@vger.kernel.org>, Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Karthik Ananthapadmanabha <karthida@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>
Message-Id: <20170405125217.CAF6960DDB@smtp.codeaurora.org> (sfid-20170405_152717_195220_8298B264)
Date: Wed,  5 Apr 2017 12:52:17 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ganapathi Bhat <gbhat@marvell.com> wrote:
> From: Karthik Ananthapadmanabha <karthida@marvell.com>
> 
> In mwifiex,IEs such as supported channels, supported operating classes
> 20/40 BSS COexistence are missing and also extra QOS capabilities IE
> is added during TDLS discovery response, TDLS setup request and
> TDLS setupresponse.
> This patch adds require IEs and also removes extra IE.
> 
> Signed-off-by: Karthik Ananthapadmanabha <karthida@marvell.com>
> Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>

Patch applied to wireless-drivers-next.git, thanks.

38c51d03cef4 mwifiex: add missing IEs related to TDLS operation

-- 
https://patchwork.kernel.org/patch/9659629/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
