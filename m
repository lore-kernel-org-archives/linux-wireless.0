Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:39458 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934238AbeAKTya (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 11 Jan 2018 14:54:30 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2] b43: Replace mdelay with usleep_range in
 b43_radio_2057_init_post
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1515462006-6144-1-git-send-email-baijiaju1990@gmail.com>
References: <1515462006-6144-1-git-send-email-baijiaju1990@gmail.com>
To: Jia-Ju Bai <baijiaju1990@gmail.com>
Cc: Larry.Finger@lwfinger.net, kstewart@linuxfoundation.org,
        johannes.berg@intel.com, tiwai@suse.de, gregkh@linuxfoundation.org,
        colin.king@canonical.com, andrew.zaborowski@intel.com,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, b43-dev@lists.infradead.org,
        Jia-Ju Bai <baijiaju1990@gmail.com>
Message-Id: <20180111195429.CDE4660BEA@smtp.codeaurora.org> (sfid-20180111_205450_931870_5B576BB2)
Date: Thu, 11 Jan 2018 19:54:29 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jia-Ju Bai <baijiaju1990@gmail.com> wrote:

> b43_radio_2057_init_post is not called in an interrupt handler
> nor holding a spinlock.
> The function mdelay in it can be replaced with usleep_range, 
> to reduce busy wait.
> 
> Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
> Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

Patch applied to wireless-drivers-next.git, thanks.

4330b53e9662 b43: Replace mdelay with usleep_range in b43_radio_2057_init_post

-- 
https://patchwork.kernel.org/patch/10150845/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
