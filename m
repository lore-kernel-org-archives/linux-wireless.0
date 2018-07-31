Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:54908 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731785AbeGaIwu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 31 Jul 2018 04:52:50 -0400
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
Message-Id: <20180731071357.6CA8B60769@smtp.codeaurora.org> (sfid-20180731_091426_466576_3D74E5F8)
Date: Tue, 31 Jul 2018 07:13:57 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

roman.stratiienko@globallogic.com wrote:

> From: Roman Stratiienko <roman.stratiienko@globallogic.com>
> 
> Mwifiex firmware inserts only Microsoft information element
> Allow other vendor specific IEs to pass from userspace
> 
> Signed-off-by: Roman Stratiienko <roman.stratiienko@globallogic.com>

Patch applied to wireless-drivers-next.git, thanks.

bfc83ea196ad mwifiex: Fix skipped vendor specific IEs

-- 
https://patchwork.kernel.org/patch/10541923/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
