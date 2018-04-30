Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:60348 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751300AbeD3KYP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 30 Apr 2018 06:24:15 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/3] mwifiex: make firmware mac address consistent with host
 configuration
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1524649094-20069-1-git-send-email-huxm@marvell.com>
References: <1524649094-20069-1-git-send-email-huxm@marvell.com>
To: Xinming Hu <huxm@marvell.com>
Cc: Linux Wireless <linux-wireless@vger.kernel.org>,
        Brian Norris <briannorris@chromium.org>,
        Dmitry Torokhov <dtor@google.com>, <rajatja@google.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        Tim Song <songtao@marvell.com>, Cathy Luo <cluo@marvell.com>,
        James Cao <jcao@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Ellie Reeves <ellierevves@gmail.com>,
        Xinming Hu <huxm@marvell.com>
Message-Id: <20180430102414.C648560767@smtp.codeaurora.org> (sfid-20180430_122418_374260_D88D4CD6)
Date: Mon, 30 Apr 2018 10:24:14 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Xinming Hu <huxm@marvell.com> wrote:

> For user configurated mac address, directly set to firmware with no change.
> 
> Signed-off-by: Xinming Hu <huxm@marvell.com>

3 patches applied to wireless-drivers-next.git, thanks.

307857db47eb mwifiex: make firmware mac address consistent with host configuration
c3b2a34b82db mwifiex: always configure firmware mac address during changing virtual interface
7cce13954f0e mwifiex: keep user configured mac address during changing virtual interface

-- 
https://patchwork.kernel.org/patch/10362107/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
