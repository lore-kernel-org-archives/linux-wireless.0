Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:45458 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731227AbeHIRib (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 9 Aug 2018 13:38:31 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [PATCH] mt76: fix build for MediaTek MT7610U USB wireless dongle
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <145751.1533759414@turing-police.cc.vt.edu>
References: <145751.1533759414@turing-police.cc.vt.edu>
To: Valdis Kletnieks <valdis.kletnieks@vt.edu>
Cc: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Message-Id: <20180809151309.980EC60BEA@smtp.codeaurora.org> (sfid-20180809_171319_984259_105E03A3)
Date: Thu,  9 Aug 2018 15:13:09 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Valdis Kletnieks <valdis.kletnieks@vt.edu> wrote:

> The mt76x0 driver requires the mt76 core driver to actually function.
> So add a 'select' to avoid embarrassing 'symbol unknown' errors
> when attempting to modprobe it in a module tree that doesn't
> include mt76.ko
> 
> Signed-off-by: Valdis Kletnieks <valdis.kletnieks@vt.edu>

Patch applied to wireless-drivers-next.git, thanks.

1ec49a236565 mt76: fix build for MediaTek MT7610U USB wireless dongle

-- 
https://patchwork.kernel.org/patch/10560477/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
