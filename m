Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:40092 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751866AbdHCKMK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 3 Aug 2017 06:12:10 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2,1/2] mwifiex: make addba request command clean
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1501551504-8560-1-git-send-email-huxinming820@gmail.com>
References: <1501551504-8560-1-git-send-email-huxinming820@gmail.com>
To: Xinming Hu <huxinming820@gmail.com>
Cc: Linux Wireless <linux-wireless@vger.kernel.org>,
        Brian Norris <briannorris@google.com>,
        Dmitry Torokhov <dtor@google.com>, rajatja@google.com,
        Zhiyuan Yang <yangzy@marvell.com>,
        Tim Song <songtao@marvell.com>, Cathy Luo <cluo@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Xinming Hu <huxm@marvell.com>
Message-Id: <20170803101209.A7229607C1@smtp.codeaurora.org> (sfid-20170803_121214_894952_5E84F46F)
Date: Thu,  3 Aug 2017 10:12:09 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Xinming Hu <huxinming820@gmail.com> wrote:

> From: Xinming Hu <huxm@marvell.com>
> 
> uninitilized variable, such as .add_req_result might be magic stack
> value. Initialize the structure to make it clean.
> 
> Signed-off-by: Xinming Hu <huxm@marvell.com>
> Signed-off-by: Cathy Luo <cluo@marvell.com>

2 patches applied to wireless-drivers-next.git, thanks.

e37f6483dc28 mwifiex: make addba request command clean
e7ece050113d mwifiex: pcie: compatible with wifi-only image while extract wifi-part fw

-- 
https://patchwork.kernel.org/patch/9873551/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
