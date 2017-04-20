Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:40436 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966241AbdDTG73 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Apr 2017 02:59:29 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath9k: Add Dell Wireless 1601 with wowlan capability
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170414115333.64abcba2@anakin>
References: <20170414115333.64abcba2@anakin>
To: =?utf-8?q?Damien_Th=C3=A9bault?= <damien@dtbo.net>
Cc: linux-wireless@vger.kernel.org,
        QCA ath9k Development <ath9k-devel@qca.qualcomm.com>
Message-Id: <20170420065928.8CC38610DB@smtp.codeaurora.org> (sfid-20170420_090114_531550_0B900EC3)
Date: Thu, 20 Apr 2017 06:59:28 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Damien Thébault wrote:
> Hello,
> 
> Sorry about this, but when I first sent this patch it didn't reach the
> maintainers in Cc because of spam filters. My MX IP is now in spamhaus
> PBL whitelist so this should work this time.
> 
> 
> Add the Dell Wireless 1601 card as an AR9462 in the ath9k pci list.
> Note that the wowlan feature is supported and has been tested
> successfully.
> 
> Signed-off-by: Damien Thébault <damien@dtbo.net>

Actually the previous did make it to the list (and patchwork) and is now
applied:

https://patchwork.kernel.org/patch/9666923/

Patch set to Superseded.

-- 
https://patchwork.kernel.org/patch/9680957/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
