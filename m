Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:58580 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751361AbeD3KVR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 30 Apr 2018 06:21:17 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: mt76x2: fix is_mt7612 routine
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180417222718.17039-1-lorenzo.bianconi@redhat.com>
References: <20180417222718.17039-1-lorenzo.bianconi@redhat.com>
To: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc: nbd@nbd.name, linux-wireless@vger.kernel.org
Message-Id: <20180430102116.A66FF60767@smtp.codeaurora.org> (sfid-20180430_122121_245751_005F3FAB)
Date: Mon, 30 Apr 2018 10:21:16 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Lorenzo Bianconi <lorenzo.bianconi@redhat.com> wrote:

> Fix is_mt7612 routine since asic version is set in mt76_dev revision
> field and not in mt76x2_dev one.
> Moreover remove mt76x2_dev rev field since it is never used in the
> driver
> 
> Fixes: 7bc04215a66b ('mt76: add driver code for MT76x2e')
> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
> Acked-by: Felix Fietkau <nbd@nbd.name>

Patch applied to wireless-drivers-next.git, thanks.

97389373d555 mt76x2: fix is_mt7612 routine

-- 
https://patchwork.kernel.org/patch/10346967/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
