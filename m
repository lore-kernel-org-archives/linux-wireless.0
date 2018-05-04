Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:59534 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751269AbeEDMmT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 4 May 2018 08:42:19 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: mt76x2: fix avg_rssi estimation
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <62914ffe8256eb60af815fca6591473d67f5a639.1525254116.git.lorenzo.bianconi@redhat.com>
References: <62914ffe8256eb60af815fca6591473d67f5a639.1525254116.git.lorenzo.bianconi@redhat.com>
To: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc: nbd@nbd.name, linux-wireless@vger.kernel.org
Message-Id: <20180504124218.937EF60B23@smtp.codeaurora.org> (sfid-20180504_144222_659287_A479479C)
Date: Fri,  4 May 2018 12:42:18 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Lorenzo Bianconi <lorenzo.bianconi@redhat.com> wrote:

> Add leftover filter coefficients in IIR rssi estimation
> 
> Fixes: 7bc04215a66b ("mt76: add driver code for MT76x2e")
> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
> Acked-by: Felix Fietkau <nbd@nbd.name>

Patch applied to wireless-drivers-next.git, thanks.

c990affd5abc mt76x2: fix avg_rssi estimation

-- 
https://patchwork.kernel.org/patch/10375267/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
