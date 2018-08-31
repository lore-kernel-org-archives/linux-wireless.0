Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:39672 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728875AbeHaUBg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 31 Aug 2018 16:01:36 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [PATCH] mt76x2u: run device cleanup routine if resume fails
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <61ca93f6c7f8fae2714b7265cb84bc36469eecb4.1535098373.git.lorenzo.bianconi@redhat.com>
References: <61ca93f6c7f8fae2714b7265cb84bc36469eecb4.1535098373.git.lorenzo.bianconi@redhat.com>
To: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc: nbd@nbd.name, linux-wireless@vger.kernel.org
Message-Id: <20180831155328.714756044E@smtp.codeaurora.org> (sfid-20180831_175340_040020_C64E2AF6)
Date: Fri, 31 Aug 2018 15:53:28 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Lorenzo Bianconi <lorenzo.bianconi@redhat.com> wrote:

> Cleanup {tx,rx} and mcu queues if resume operation fails
> 
> Fixes: ee676cd5017c ("mt76: add driver code for MT76x2u based devices")
> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>

Patch applied to wireless-drivers-next.git, thanks.

9b2fd48d36e2 mt76x2u: run device cleanup routine if resume fails

-- 
https://patchwork.kernel.org/patch/10574897/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
