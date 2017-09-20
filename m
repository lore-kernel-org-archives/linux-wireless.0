Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:54810 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751554AbdITMtM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Sep 2017 08:49:12 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [2/2] mwifiex: use get_random_mask_addr() helper
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1505720537-13362-1-git-send-email-gbhat@marvell.com>
References: <1505720537-13362-1-git-send-email-gbhat@marvell.com>
To: Ganapathi Bhat <gbhat@marvell.com>
Cc: <linux-wireless@vger.kernel.org>,
        Brian Norris <briannorris@chromium.org>,
        Cathy Luo <cluo@marvell.com>, Xinming Hu <huxm@marvell.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        James Cao <jcao@marvell.com>,
        Mangesh Malusare <mmangesh@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>
Message-Id: <20170920124911.5773C60C68@smtp.codeaurora.org> (sfid-20170920_144914_812969_49874496)
Date: Wed, 20 Sep 2017 12:49:10 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ganapathi Bhat <gbhat@marvell.com> wrote:

> Avoid calculating random MAC address in driver. Instead make
> use of 'get_random_mask_addr()' function.
> 
> Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>
> Reviewed-by: Brian Norris <briannorris@chromium.org>

Patch applied to wireless-drivers-next.git, thanks.

e9a3846afaa4 mwifiex: use get_random_mask_addr() helper

-- 
https://patchwork.kernel.org/patch/9955631/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
