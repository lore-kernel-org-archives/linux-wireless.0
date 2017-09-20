Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:49266 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751663AbdITMqJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Sep 2017 08:46:09 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: mwifiex: notify cfg80211 about scan abort
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1504121915-2063-1-git-send-email-gbhat@marvell.com>
References: <1504121915-2063-1-git-send-email-gbhat@marvell.com>
To: Ganapathi Bhat <gbhat@marvell.com>
Cc: <linux-wireless@vger.kernel.org>,
        Brian Norris <briannorris@chromium.org>,
        Cathy Luo <cluo@marvell.com>, Xinming Hu <huxm@marvell.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        James Cao <jcao@marvell.com>,
        Mangesh Malusare <mmangesh@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>
Message-Id: <20170920124609.3172460725@smtp.codeaurora.org> (sfid-20170920_144612_533309_E4653577)
Date: Wed, 20 Sep 2017 12:46:09 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ganapathi Bhat <gbhat@marvell.com> wrote:

> Driver sends a series of scan commands to firmware to serve a
> user scan request. If an intermediate scan command fails, driver
> aborts the scan but it is not being informed to cfg80211. This
> will cause issues in applications performing periodic scans.
> Fix this by informing scan abort.
> 
> Signed-off-by: Cathy Luo <cluo@marvell.com>
> Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>

Patch applied to wireless-drivers-next.git, thanks.

31726ff20190 mwifiex: notify cfg80211 about scan abort

-- 
https://patchwork.kernel.org/patch/9930689/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
