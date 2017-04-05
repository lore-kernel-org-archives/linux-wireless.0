Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:37382 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933097AbdDEKrL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Apr 2017 06:47:11 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [3/3] mwifiex: pcie: avoid hardcode wifi-only firmware name
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1490865547-10208-3-git-send-email-huxinming820@gmail.com>
References: <1490865547-10208-3-git-send-email-huxinming820@gmail.com>
To: Xinming Hu <huxinming820@gmail.com>
Cc: Linux Wireless <linux-wireless@vger.kernel.org>,
        Kalle Valo <kvalo@qca.qualcomm.com>,
        Brian Norris <briannorris@google.com>,
        Dmitry Torokhov <dtor@google.com>, rajatja@google.com,
        Amitkumar Karwar <akarwar@marvell.com>,
        Cathy Luo <cluo@marvell.com>, Xinming Hu <huxm@marvell.com>
Message-Id: <20170405104711.32CD460DA5@smtp.codeaurora.org> (sfid-20170405_125045_357555_D197F3E1)
Date: Wed,  5 Apr 2017 10:47:11 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Xinming Hu <huxinming820@gmail.com> wrote:
> From: Xinming Hu <huxm@marvell.com>
> 
> Wifi-only firmware name should be chipset specific.
> 
> Signed-off-by: Xinming Hu <huxm@marvell.com>
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>

The commit log is not telling anything. Why are you changing this? And how does
the functionality change from user space point of view?

-- 
https://patchwork.kernel.org/patch/9653387/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
