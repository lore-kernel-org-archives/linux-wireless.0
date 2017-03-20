Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:52476 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753819AbdCTRMo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 20 Mar 2017 13:12:44 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [4.12,1/2] bcma: use helper function to set core dev's parent
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170303103415.5188-1-zajec5@gmail.com>
References: <20170303103415.5188-1-zajec5@gmail.com>
To: =?utf-8?b?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Message-Id: <20170320171231.22896609A1@smtp.codeaurora.org> (sfid-20170320_181316_535929_B1D86047)
Date: Mon, 20 Mar 2017 17:12:30 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rafał Miłecki wrote:
> From: Rafał Miłecki <rafal@milecki.pl>
> 
> A tiny code deduplication thanks to the bcma_bus_get_host_dev.
> 
> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>

2 patches applied to wireless-drivers-next.git, thanks.

5e48a4cd2ee9 bcma: use helper function to set core dev's parent
f825f6ed20e3 bcma: fill core OF info independently of bus type

-- 
https://patchwork.kernel.org/patch/9602507/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
