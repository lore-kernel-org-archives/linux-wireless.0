Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:37504 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750998AbdEaNzZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 31 May 2017 09:55:25 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v4,1/5] mwifiex: use variable interface header length
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1495523554-30753-1-git-send-email-huxinming820@gmail.com>
References: <1495523554-30753-1-git-send-email-huxinming820@gmail.com>
To: Xinming Hu <huxinming820@gmail.com>
Cc: Linux Wireless <linux-wireless@vger.kernel.org>,
        Kalle Valo <kvalo@qca.qualcomm.com>,
        Brian Norris <briannorris@google.com>,
        Dmitry Torokhov <dtor@google.com>, rajatja@google.com,
        Zhiyuan Yang <yangzy@marvell.com>,
        Cathy Luo <cluo@marvell.com>, Xinming Hu <huxm@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>
Message-Id: <20170531135514.B1B166074D@smtp.codeaurora.org> (sfid-20170531_155536_058864_9245A341)
Date: Wed, 31 May 2017 13:55:14 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Xinming Hu <huxinming820@gmail.com> wrote:

> From: Xinming Hu <huxm@marvell.com>
> 
> Usb tx aggregation feature will utilize 4-bytes bus interface header,
> otherwise it will be set to zero in default case.
> 
> Signed-off-by: Xinming Hu <huxm@marvell.com>
> Signed-off-by: Cathy Luo <cluo@marvell.com>
> Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>

5 patches applied to wireless-drivers-next.git, thanks.

f4c5d5991590 mwifiex: use variable interface header length
42d1abb50ffc mwifiex: usb: kill urb before free its memory
c59942938c6a mwifiex: usb: transmit aggregation packets
a2ca85ad721d mwifiex: usb: add timer to flush aggregation packets
822446d4ff2b mwifiex: check next packet length for usb tx aggregation

-- 
https://patchwork.kernel.org/patch/9741991/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
