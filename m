Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:34726 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751365AbcKYJzf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 25 Nov 2016 04:55:35 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: mwifiex: Disable adhoc feature based on firmware capability
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1479730744-8964-1-git-send-email-akarwar@marvell.com>
References: <1479730744-8964-1-git-send-email-akarwar@marvell.com>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: <linux-wireless@vger.kernel.org>, Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Karthik D A <karthida@marvell.com>,
        Amitkumar Karwar <akarwar@marvell.com>
Message-Id: <20161125095535.21E1D613D3@smtp.codeaurora.org> (sfid-20161125_105540_306773_90C161FF)
Date: Fri, 25 Nov 2016 09:55:35 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Amitkumar Karwar <akarwar@marvell.com> wrote:
> From: Karthik D A <karthida@marvell.com>
> 
> We will read fw_cap_info filled by firmware to check whether to
> skip ADHOC related commands or not. Also, IBSS_COALESCING_STATUS
> command has been moved from init path to adhoc network creation
> path.
> 
> Signed-off-by: Karthik D A <karthida@marvell.com>
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>

Patch applied to wireless-drivers-next.git, thanks.

e267e71e68ae mwifiex: Disable adhoc feature based on firmware capability

-- 
https://patchwork.kernel.org/patch/9439379/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
