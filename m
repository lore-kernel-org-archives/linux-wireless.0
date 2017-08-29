Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([184.105.139.130]:36588 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751223AbdH2SFX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 Aug 2017 14:05:23 -0400
Date: Tue, 29 Aug 2017 11:05:22 -0700 (PDT)
Message-Id: <20170829.110522.1436661088715199000.davem@davemloft.net> (sfid-20170829_200540_545751_31E234D2)
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull-request: wireless-drivers-next 2017-08-28
From: David Miller <davem@davemloft.net>
In-Reply-To: <87val8ujvp.fsf@kamboji.qca.qualcomm.com>
References: <87val8ujvp.fsf@kamboji.qca.qualcomm.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kalle Valo <kvalo@codeaurora.org>
Date: Mon, 28 Aug 2017 12:22:34 +0300

> here's a pull request to net-next for 4.14. Because I pulled
> wireless-drivers (at least that's my suspicion) the diffstat was wrong
> again and I created it manually. I recall Linus somewhere saying that in
> certain cases this is normal and it's ok to create the diffstat
> manually, so I don't worry about this anymore.

Yeah, that's fine.

> In this pull request we also add SDIO_DEVICE_ID_CYPRESS_4373 to
> include/linux/mmc/sdio_ids.h which stands out in the diffstat.
> 
> Please let me know if there are any problems.

Pulled, thanks!
