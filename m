Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:35558 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753378AbdJMJiV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Oct 2017 05:38:21 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/2] mwifiex: kill useless list_empty checks
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1507043984-9832-1-git-send-email-gbhat@marvell.com>
References: <1507043984-9832-1-git-send-email-gbhat@marvell.com>
To: Ganapathi Bhat <gbhat@marvell.com>
Cc: <linux-wireless@vger.kernel.org>,
        Brian Norris <briannorris@chromium.org>,
        Cathy Luo <cluo@marvell.com>, Xinming Hu <huxm@marvell.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        James Cao <jcao@marvell.com>,
        Mangesh Malusare <mmangesh@marvell.com>,
        Douglas Anderson <dianders@chromium.org>,
        Ganapathi Bhat <gbhat@marvell.com>
Message-Id: <20171013093820.8458D61473@smtp.codeaurora.org> (sfid-20171013_113824_350503_DFBD1D47)
Date: Fri, 13 Oct 2017 09:38:20 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ganapathi Bhat <gbhat@marvell.com> wrote:

> From: Douglas Anderson <dianders@chromium.org>
> 
> There's absolutely no reason to check to see if a list is empty
> before iterating through it.  It's just like writing code like
> this:
> 
> if (count != 0) {
>   for (i = 0; i < count; i++) {
>      ...
>   }
> }
> 
> The loop will already be avoided if "count == 0" so there was no
> reason to check.
> 
> Signed-off-by: Douglas Anderson <dianders@chromium.org>
> Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>

2 patches applied to wireless-drivers-next.git, thanks.

40351051d022 mwifiex: kill useless list_empty checks
f0f7c2275fb9 mwifiex: minor cleanups w/ sta_list_spinlock in cfg80211.c

-- 
https://patchwork.kernel.org/patch/9983061/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
