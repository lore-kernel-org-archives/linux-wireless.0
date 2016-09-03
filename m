Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:56250 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752270AbcICJz6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 3 Sep 2016 05:55:58 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [-next] wlcore: spi: fix non static symbol warning
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1469196488-21050-1-git-send-email-weiyj.lk@gmail.com>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: "Andrew F. Davis" <afd@ti.com>, Arnd Bergmann <arnd@arndb.de>,
        Igor Grinberg <grinberg@compulab.co.il>,
        Uri Mashiach <uri.mashiach@compulab.co.il>,
        Rob Herring <robh@kernel.org>, "Reizer, Eyal" <eyalr@ti.com>,
        Wei Yongjun <weiyj.lk@gmail.com>,
        linux-wireless@vger.kernel.org
Message-Id: <20160903095557.F023661ADF@smtp.codeaurora.org> (sfid-20160903_115601_597781_1B52F54F)
Date: Sat,  3 Sep 2016 09:55:57 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Wei Yongjun <weiyj.lk@gmail.com> wrote:
> Fixes the following sparse warning:
> 
> drivers/net/wireless/ti/wlcore/spi.c:87:34: warning:
>  symbol 'wilink_data' was not declared. Should it be static?
> 
> Signed-off-by: Wei Yongjun <weiyj.lk@gmail.com>

Thanks, 1 patch applied to wireless-drivers-next.git:

4ad0579a28c0 wlcore: spi: fix non static symbol warning

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9243695/
