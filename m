Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:58178 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751572AbeCMQx2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Mar 2018 12:53:28 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: mwifiex: correct antenna number with high bits reserved
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1520488442-10729-1-git-send-email-huxm@marvell.com>
References: <1520488442-10729-1-git-send-email-huxm@marvell.com>
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
Message-Id: <20180313165328.71704600C1@smtp.codeaurora.org> (sfid-20180313_175353_831054_39A262C7)
Date: Tue, 13 Mar 2018 16:53:28 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Xinming Hu <huxm@marvell.com> wrote:

> High bits of antenna number are reserved in hardware spec,
> using low 4 bits represent supported antenna.
> 
> Signed-off-by: Cathy Luo <cluo@marvell.com>
> Signed-off-by: Xinming Hu <huxm@marvell.com>

Patch applied to wireless-drivers-next.git, thanks.

eaab43e505d0 mwifiex: correct antenna number with high bits reserved

-- 
https://patchwork.kernel.org/patch/10266469/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
