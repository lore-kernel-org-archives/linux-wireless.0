Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:56978 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755085AbdLGNaG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Dec 2017 08:30:06 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v3] mwifiex: do not support change AP interface to station mode
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1511333731-23474-1-git-send-email-huxm@marvell.com>
References: <1511333731-23474-1-git-send-email-huxm@marvell.com>
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
Message-Id: <20171207133005.6E4516022C@smtp.codeaurora.org> (sfid-20171207_143026_886832_5FAFA8A7)
Date: Thu,  7 Dec 2017 13:30:05 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Xinming Hu <huxm@marvell.com> wrote:

> Firmware do not support change interface from micro-ap mode
> to station mode, forbid this operation
> 
> Signed-off-by: Cathy Luo <cluo@marvell.com>
> Signed-off-by: Xinming Hu <huxm@marvell.com>

Patch applied to wireless-drivers-next.git, thanks.

71121e420d75 mwifiex: do not support change AP interface to station mode

-- 
https://patchwork.kernel.org/patch/10069839/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
