Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:53524 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751590AbdITMsY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Sep 2017 08:48:24 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: mwifiex: avoid storing random_mac in private
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1505717702-10342-1-git-send-email-gbhat@marvell.com>
References: <1505717702-10342-1-git-send-email-gbhat@marvell.com>
To: Ganapathi Bhat <gbhat@marvell.com>
Cc: <linux-wireless@vger.kernel.org>,
        Brian Norris <briannorris@chromium.org>,
        Cathy Luo <cluo@marvell.com>, Xinming Hu <huxm@marvell.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        James Cao <jcao@marvell.com>,
        Mangesh Malusare <mmangesh@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>
Message-Id: <20170920124823.1608660C52@smtp.codeaurora.org> (sfid-20170920_144827_047954_C1A30411)
Date: Wed, 20 Sep 2017 12:48:22 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ganapathi Bhat <gbhat@marvell.com> wrote:

> Application will keep track of whether MAC address randomization
> is enabled or not during scan. But at present driver is storing
> 'random_mac' in mwifiex_private which implies even after scan is
> done driver has some reference to the earlier 'scan request'. To
> avoid this, make use of 'mac_addr' variable in 'scan_request' to
> store 'random_mac'. This structure will be freed by cfg80211 once
> scan is done.
> 
> Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>
> Reviewed-by: Brian Norris <briannorris@chromium.org>

Patch applied to wireless-drivers-next.git, thanks.

e251a882c0ba mwifiex: avoid storing random_mac in private

-- 
https://patchwork.kernel.org/patch/9955573/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
