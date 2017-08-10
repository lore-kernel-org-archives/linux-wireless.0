Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:47350 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752342AbdHJI7D (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 10 Aug 2017 04:59:03 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: mwifiex: uap: enable 11d based on userspace configruation
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1502245903-22246-1-git-send-email-huxinming820@gmail.com>
References: <1502245903-22246-1-git-send-email-huxinming820@gmail.com>
To: Xinming Hu <huxinming820@gmail.com>
Cc: Linux Wireless <linux-wireless@vger.kernel.org>,
        Brian Norris <briannorris@google.com>,
        Dmitry Torokhov <dtor@google.com>, rajatja@google.com,
        Zhiyuan Yang <yangzy@marvell.com>,
        Tim Song <songtao@marvell.com>, Cathy Luo <cluo@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Xinming Hu <huxm@marvell.com>
Message-Id: <20170810085903.6F655601D8@smtp.codeaurora.org> (sfid-20170810_105909_389575_8266793E)
Date: Thu, 10 Aug 2017 08:59:03 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Xinming Hu <huxinming820@gmail.com> wrote:

> From: Xinming Hu <huxm@marvell.com>
> 
> This patch check whether userspace beacon data include country
> ie, if so then download command to enable 11d setup in firmeare
> accordingly.
> 
> Signed-off-by: Xinming Hu <huxm@marvell.com>
> Signed-off-by: Cathy Luo <cluo@marvell.com>

Patch applied to wireless-drivers-next.git, thanks.

f18bbe5c86fd mwifiex: uap: enable 11d based on userspace configruation

-- 
https://patchwork.kernel.org/patch/9889453/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
