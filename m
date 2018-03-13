Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:58654 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932637AbeCMQy3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Mar 2018 12:54:29 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/3] Revert "mwifiex: fix incorrect ht capability problem"
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1520619326-14888-2-git-send-email-gbhat@marvell.com>
References: <1520619326-14888-2-git-send-email-gbhat@marvell.com>
To: Ganapathi Bhat <gbhat@marvell.com>
Cc: <linux-wireless@vger.kernel.org>,
        Brian Norris <briannorris@chromium.org>,
        Cathy Luo <cluo@marvell.com>, Xinming Hu <huxm@marvell.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        James Cao <jcao@marvell.com>,
        Mangesh Malusare <mmangesh@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>
Message-Id: <20180313165429.7185360849@smtp.codeaurora.org> (sfid-20180313_175436_317849_ACAF8797)
Date: Tue, 13 Mar 2018 16:54:29 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ganapathi Bhat <gbhat@marvell.com> wrote:

> This reverts commit bcc920e8f08336cbbdcdba7c4449c27137e6b4b9.
> 
> Drivers gets hardware info and updates ht_cap field of
> wiphy->bands during initialization. Once updated during init,
> ht_cap must not be modified as it reflects the capability
> supported by hardwawre. Above patch tries to modify the ht_cap
> field and this results in wrongly advertising capabilities during
> association.
> 
> Signed-off-by: Cathy Luo <cluo@marvell.com>
> Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>

3 patches applied to wireless-drivers-next.git, thanks.

53a7094204b7 Revert "mwifiex: fix incorrect ht capability problem"
77423fa73927 mwifiex: fix incorrect ht capability problem
28bf8312a983 mwifiex: get_channel from firmware

-- 
https://patchwork.kernel.org/patch/10271595/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
