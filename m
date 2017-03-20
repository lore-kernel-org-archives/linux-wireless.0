Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:49380 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753230AbdCTRG4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 20 Mar 2017 13:06:56 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2,1/3] mwifiex: add qualifier to firmware structures
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1489048577-11293-2-git-send-email-gbhat@marvell.com>
References: <1489048577-11293-2-git-send-email-gbhat@marvell.com>
To: Ganapathi Bhat <gbhat@marvell.com>
Cc: <linux-wireless@vger.kernel.org>,
        Amitkumar Karwar <akarwar@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Karthik Ananthapadmanabha <karthida@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>
Message-Id: <20170320170603.3373460854@smtp.codeaurora.org> (sfid-20170320_180751_834456_BF89B5C9)
Date: Mon, 20 Mar 2017 17:06:03 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ganapathi Bhat <gbhat@marvell.com> wrote:
> From: Karthik Ananthapadmanabha <karthida@marvell.com>
> 
> Adding qualifier "__packed" indicates that no padding should be
> performed on the qualified object for alignment.
> This patch adds qualifier __packed to the required firmware
> structures in mwifiex driver.
> 
> Signed-off-by: Karthik Ananthapadmanabha <karthida@marvell.com>
> Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>

3 patches applied to wireless-drivers-next.git, thanks.

5c0b87987432 mwifiex: add qualifier to firmware structures
5653c6462f56 mwifiex: Use accessors routines for unaligned values
92c70a958b0b mwifiex: fix for unaligned reads

-- 
https://patchwork.kernel.org/patch/9612875/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
