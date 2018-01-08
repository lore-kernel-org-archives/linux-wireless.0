Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:43502 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756259AbeAHQV3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Jan 2018 11:21:29 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: b43: Replace mdelay with msleep in b43_radio_2057_init_post
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1514632107-14698-1-git-send-email-baijiaju1990@gmail.com>
References: <1514632107-14698-1-git-send-email-baijiaju1990@gmail.com>
To: Jia-Ju Bai <baijiaju1990@gmail.com>
Cc: colin.king@canonical.com, johannes.berg@intel.com, tiwai@suse.de,
        kstewart@linuxfoundation.org, gregkh@linuxfoundation.org,
        andrew.zaborowski@intel.com, linux-wireless@vger.kernel.org,
        b43-dev@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jia-Ju Bai <baijiaju1990@gmail.com>
Message-Id: <20180108162128.C4C9060B3B@smtp.codeaurora.org> (sfid-20180108_172710_123915_A9351198)
Date: Mon,  8 Jan 2018 16:21:28 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jia-Ju Bai <baijiaju1990@gmail.com> wrote:

> b43_radio_2057_init_post is not called in an interrupt handler 
> nor holding a spinlock.
> The function mdelay in it can be replaced with msleep, to reduce busy wait.
> 
> Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>

You submitted an identical patch a week earlier:

https://patchwork.kernel.org/patch/10137671/

How is this different? Also always add version number to the patch so that the
maintainers can follow the changes easily:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches#patch_version_missing

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches#changelog_missing

-- 
https://patchwork.kernel.org/patch/10137671/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
