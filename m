Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:37312 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751396AbdFAJvn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Jun 2017 05:51:43 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: mwifiex: uap: process remain on channel expired event
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1495781833-25585-1-git-send-email-huxinming820@gmail.com>
References: <1495781833-25585-1-git-send-email-huxinming820@gmail.com>
To: Xinming Hu <huxinming820@gmail.com>
Cc: Linux Wireless <linux-wireless@vger.kernel.org>,
        Brian Norris <briannorris@google.com>,
        Dmitry Torokhov <dtor@google.com>, rajatja@google.com,
        Zhiyuan Yang <yangzy@marvell.com>,
        Cathy Luo <cluo@marvell.com>, Xinming Hu <huxm@marvell.com>
Message-Id: <20170601095142.4895C60720@smtp.codeaurora.org> (sfid-20170601_115146_402968_FC2A1548)
Date: Thu,  1 Jun 2017 09:51:42 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Xinming Hu <huxinming820@gmail.com> wrote:

> From: Xinming Hu <huxm@marvell.com>
> 
> AP interface need process remain-on-channel firmware event and notify
> cfg80211, this will be used in the listen-stage of p2p find procedure.
> 
> Signed-off-by: Xinming Hu <huxm@marvell.com>

Patch applied to wireless-drivers-next.git, thanks.

1f7171995142 mwifiex: uap: process remain on channel expired event

-- 
https://patchwork.kernel.org/patch/9749789/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
