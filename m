Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:56826 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934005AbeAXPRu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 Jan 2018 10:17:50 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2] mt76x2: init: disable all pending tasklets during device
 removal
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <612e527f5358f4d7d465f21fc72b5b649dce5f40.1516697336.git.lorenzo.bianconi@redhat.com>
References: <612e527f5358f4d7d465f21fc72b5b649dce5f40.1516697336.git.lorenzo.bianconi@redhat.com>
To: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc: nbd@nbd.name, linux-wireless@vger.kernel.org
Message-Id: <20180124151750.12E4B609D1@smtp.codeaurora.org> (sfid-20180124_161755_100927_985900AE)
Date: Wed, 24 Jan 2018 15:17:50 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Lorenzo Bianconi <lorenzo.bianconi@redhat.com> wrote:

> There is a possible race in mt76x2_stop_hardware() since pre_tbtt and
> dfs tasklets could run during driver cleanup. Fix it disabling all
> pending tasklets during device removal
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
> Acked-by: Felix Fietkau <nbd@nbd.name>

Patch applied to wireless-drivers-next.git, thanks.

ba9797b2a7a5 mt76x2: init: disable all pending tasklets during device removal

-- 
https://patchwork.kernel.org/patch/10179831/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
