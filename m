Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:41002 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751770AbeCOM7S (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Mar 2018 08:59:18 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Ganapathi Bhat <gbhat@marvell.com>
Cc: <linux-wireless@vger.kernel.org>,
        Brian Norris <briannorris@chromium.org>,
        Cathy Luo <cluo@marvell.com>, Xinming Hu <huxm@marvell.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        James Cao <jcao@marvell.com>,
        Mangesh Malusare <mmangesh@marvell.com>
Subject: Re: [PATCH] mwifiex: remove warnings in mwifiex_cmd_append_11n_tlv()
References: <1521094832-6311-1-git-send-email-gbhat@marvell.com>
Date: Thu, 15 Mar 2018 14:59:14 +0200
In-Reply-To: <1521094832-6311-1-git-send-email-gbhat@marvell.com> (Ganapathi
        Bhat's message of "Thu, 15 Mar 2018 11:50:32 +0530")
Message-ID: <87y3itxzod.fsf@purkki.adurom.net> (sfid-20180315_135922_765787_59E510F2)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ganapathi Bhat <gbhat@marvell.com> writes:

> Fix the following sparse warning in mwifiex_cmd_append_11n_tlv:
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
> This is a follow up to commit 77423fa73927
> ("mwifiex: fix incorrect ht capability problem")

I'll replace this sentence with:

Fixes: 77423fa73927 ("mwifiex: fix incorrect ht capability problem")

-- 
Kalle Valo
