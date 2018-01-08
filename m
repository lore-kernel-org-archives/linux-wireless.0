Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:49182 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753476AbeAHRh4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Jan 2018 12:37:56 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v5,
 1/3] mwifiex: refactor device dump code to make it generic for usb
 interface
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1513064293-9400-1-git-send-email-huxm@marvell.com>
References: <1513064293-9400-1-git-send-email-huxm@marvell.com>
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
Message-Id: <20180108173755.B25B260215@smtp.codeaurora.org> (sfid-20180108_183803_035440_87243017)
Date: Mon,  8 Jan 2018 17:37:55 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Xinming Hu <huxm@marvell.com> wrote:

> This patch refactor current device dump code to make it generic
> for subsequent implementation on usb interface.
> 
> Signed-off-by: Xinming Hu <huxm@marvell.com>
> Signed-off-by: Cathy Luo <cluo@marvell.com>
> Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>

3 patches applied to wireless-drivers-next.git, thanks.

d0e2b44ef328 mwifiex: refactor device dump code to make it generic for usb interface
f5ecd02a8b20 mwifiex: device dump support for usb interface
18d605013357 mwifiex: debugfs: trigger device dump for usb interface

-- 
https://patchwork.kernel.org/patch/10106407/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
