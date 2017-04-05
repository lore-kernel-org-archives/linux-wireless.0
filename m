Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:40516 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753339AbdDEMip (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Apr 2017 08:38:45 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2] mwifiex: Support USB interrupt endpoint for command
 response/event
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1490619464-14844-1-git-send-email-gbhat@marvell.com>
References: <1490619464-14844-1-git-send-email-gbhat@marvell.com>
To: Ganapathi Bhat <gbhat@marvell.com>
Cc: <linux-wireless@vger.kernel.org>,
        Amitkumar Karwar <akarwar@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>
Message-Id: <20170405123845.476AB60DAD@smtp.codeaurora.org> (sfid-20170405_144107_531837_48525540)
Date: Wed,  5 Apr 2017 12:38:45 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ganapathi Bhat <gbhat@marvell.com> wrote:
> USB firmware added support for sending command response/event through
> interrupt endpoint, to enhance RX throughput. Added corresponding changes
> required to support this feature. This change takes care of backward
> compatibility with older firmware.
> 
> Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>

Patch applied to wireless-drivers-next.git, thanks.

182f56966054 mwifiex: Support USB interrupt endpoint for command response/event

-- 
https://patchwork.kernel.org/patch/9646607/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
