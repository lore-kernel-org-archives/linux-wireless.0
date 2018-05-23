Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:33924 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754289AbeEWIBF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 23 May 2018 04:01:05 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: mwifiex: correct histogram data with appropriate index
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1526629134-10049-1-git-send-email-huxm@marvell.com>
References: <1526629134-10049-1-git-send-email-huxm@marvell.com>
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
Message-Id: <20180523080104.A5D4760618@smtp.codeaurora.org> (sfid-20180523_100310_408365_BB1496F8)
Date: Wed, 23 May 2018 08:01:04 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Xinming Hu <huxm@marvell.com> wrote:

> Correct snr/nr/rssi data index to avoid possible buffer underflow.
> 
> Signed-off-by: Xinming Hu <huxm@marvell.com>

Patch applied to wireless-drivers-next.git, thanks.

30bfce0b63fa mwifiex: correct histogram data with appropriate index

-- 
https://patchwork.kernel.org/patch/10408353/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
