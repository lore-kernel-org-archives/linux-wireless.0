Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:57752 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751591AbdCHP3r (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 8 Mar 2017 10:29:47 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: bcma: gpio: set of_node regardless of the host type
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170214220346.10479-1-zajec5@gmail.com>
References: <20170214220346.10479-1-zajec5@gmail.com>
To: =?utf-8?b?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Message-Id: <20170308150528.8572A6076A@smtp.codeaurora.org> (sfid-20170308_163026_206835_72DA372E)
Date: Wed,  8 Mar 2017 15:05:28 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rafał Miłecki wrote:
> From: Rafał Miłecki <rafal@milecki.pl>
> 
> DT allows describing many device types, not only platform ones. If e.g.
> bcma is hosted on PCI(e) and it has its of_node, let's pass it to the
> GPIO subsystem. This allows GPIO code to handle more hardware details
> not only for bcma on a SoC.
> 
> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>

Patch applied to wireless-drivers-next.git, thanks.

a4bb5b1b47cb bcma: gpio: set of_node regardless of the host type

-- 
https://patchwork.kernel.org/patch/9572997/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
