Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:37660 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751001AbeC0ID5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Mar 2018 04:03:57 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: mwifiex: remove warnings in mwifiex_cmd_append_11n_tlv()
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1521094832-6311-1-git-send-email-gbhat@marvell.com>
References: <1521094832-6311-1-git-send-email-gbhat@marvell.com>
To: Ganapathi Bhat <gbhat@marvell.com>
Cc: <linux-wireless@vger.kernel.org>,
        Brian Norris <briannorris@chromium.org>,
        Cathy Luo <cluo@marvell.com>, Xinming Hu <huxm@marvell.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        James Cao <jcao@marvell.com>,
        Mangesh Malusare <mmangesh@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>
Message-Id: <20180327080356.DF970607E4@smtp.codeaurora.org> (sfid-20180327_100401_851797_B84636C7)
Date: Tue, 27 Mar 2018 08:03:56 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ganapathi Bhat <gbhat@marvell.com> wrote:

> Fix the following sparse warning in mwifiex_cmd_append_11n_tlv:
> 
> drivers/net/wireless/marvell/mwifiex/11n.c:358:65: warning: invalid assignment: &=
> drivers/net/wireless/marvell/mwifiex/11n.c:358:65:    left side has type restricted __le16
> drivers/net/wireless/marvell/mwifiex/11n.c:358:65:    right side has type int
> drivers/net/wireless/marvell/mwifiex/11n.c:360:65: warning: invalid assignment: &=
> drivers/net/wireless/marvell/mwifiex/11n.c:360:65:    left side has type restricted __le16
> drivers/net/wireless/marvell/mwifiex/11n.c:360:65:    right side has type int
> drivers/net/wireless/marvell/mwifiex/11n.c:366:65: warning: invalid assignment: &=
> drivers/net/wireless/marvell/mwifiex/11n.c:366:65:    left side has type restricted __le16
> drivers/net/wireless/marvell/mwifiex/11n.c:366:65:    right side has type int
> drivers/net/wireless/marvell/mwifiex/11n.c:368:65: warning: invalid assignment: &=
> drivers/net/wireless/marvell/mwifiex/11n.c:368:65:    left side has type restricted __le16
> drivers/net/wireless/marvell/mwifiex/11n.c:368:65:    right side has type int
> 
> Fixes: 77423fa73927 ("mwifiex: fix incorrect ht capability problem")
> Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>

Patch applied to wireless-drivers-next.git, thanks.

6c20495b7deb mwifiex: remove warnings in mwifiex_cmd_append_11n_tlv()

-- 
https://patchwork.kernel.org/patch/10283921/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
