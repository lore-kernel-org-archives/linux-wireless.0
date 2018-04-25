Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:48946 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750941AbeDYISz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 25 Apr 2018 04:18:55 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/2] mwifiex: uap: filter duplicate ERP IE
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1522672283-1860-1-git-send-email-huxm@marvell.com>
References: <1522672283-1860-1-git-send-email-huxm@marvell.com>
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
Message-Id: <20180425081855.321DB60556@smtp.codeaurora.org> (sfid-20180425_101902_330624_C187B626)
Date: Wed, 25 Apr 2018 08:18:55 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Xinming Hu <huxm@marvell.com> wrote:

> Firmware parse and attach ERP IE from bss configuration,
> do not set again from tail IE.
> 
> Signed-off-by: Xinming Hu <huxm@marvell.com>

2 patches applied to wireless-drivers-next.git, thanks.

d6c38be09af0 mwifiex: uap: filter duplicate ERP IE
c1003538bf6b mwifiex: uap: support cfg80211 ignore_broadcast_ssid=2

-- 
https://patchwork.kernel.org/patch/10319683/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
