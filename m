Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:48214 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728834AbeHIHjR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 9 Aug 2018 03:39:17 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: valdis.kletnieks@vt.edu
Cc: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] fix build for MediaTek MT7610U USB wireless dongle
References: <145751.1533759414@turing-police.cc.vt.edu>
Date: Thu, 09 Aug 2018 08:16:12 +0300
In-Reply-To: <145751.1533759414@turing-police.cc.vt.edu> (valdis kletnieks's
        message of "Wed, 08 Aug 2018 16:16:54 -0400")
Message-ID: <87wot02k83.fsf@kamboji.qca.qualcomm.com> (sfid-20180809_071630_919802_D77D0AD5)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

valdis.kletnieks@vt.edu writes:

> The mt76x0 driver requires the mt76 core driver to actually function.
> So add a 'select' to avoid embarrassing 'symbol unknown' errors
> when attempting to modprobe it in a module tree that doesn't
> include mt76.ko
>
> Signed-off-by: Valdis Kletnieks <valdis.kletnieks@vt.edu>

I'll add "mt76:" prefix to the title and queue this for 4.19.

> Still need to figure out why it totally fails to see the 5gz band,
> it works find on 2.4 but ends up locked at 72mbits/sec. Works
> OK otherwise...

Great, thanks for the feedback.

-- 
Kalle Valo
