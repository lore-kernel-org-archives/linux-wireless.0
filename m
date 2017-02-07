Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:33012 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753104AbdBGID7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 7 Feb 2017 03:03:59 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: mwifiex: Avoid skipping WEP key deletion for AP
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1486126822-21958-1-git-send-email-akarwar@marvell.com>
References: <1486126822-21958-1-git-send-email-akarwar@marvell.com>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: <linux-wireless@vger.kernel.org>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Amitkumar Karwar <akarwar@marvell.com>
Message-Id: <20170207080358.C6EE7609F2@smtp.codeaurora.org> (sfid-20170207_090406_119711_81B507D7)
Date: Tue,  7 Feb 2017 08:03:58 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Amitkumar Karwar <akarwar@marvell.com> wrote:
> From: Ganapathi Bhat <gbhat@marvell.com>
> 
> This patch fixes the issue specific to AP. AP is started with WEP
> security and external station is connected to it. Data path works
> in this case. Now if AP is restarted with WPA/WPA2 security,
> station is able to connect but ping fails.
> 
> Driver skips the deletion of WEP keys if interface type is AP.
> Removing that redundant check resolves the issue.
> 
> Fixes: e57f1734d87a ("mwifiex: add key material v2 support")
> Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>

Patch applied to wireless-drivers-next.git, thanks.

a5b60de6972d mwifiex: Avoid skipping WEP key deletion for AP

-- 
https://patchwork.kernel.org/patch/9554057/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
