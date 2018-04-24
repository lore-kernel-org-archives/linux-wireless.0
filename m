Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:36804 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751492AbeDXReE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 24 Apr 2018 13:34:04 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: mt76x2: fix TXD_INFO bitmask definition
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180416230559.11268-1-lorenzo.bianconi@redhat.com>
References: <20180416230559.11268-1-lorenzo.bianconi@redhat.com>
To: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc: nbd@nbd.name, linux-wireless@vger.kernel.org
Message-Id: <20180424173403.E94306090E@smtp.codeaurora.org> (sfid-20180424_193412_990979_582FB31F)
Date: Tue, 24 Apr 2018 17:34:03 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Lorenzo Bianconi <lorenzo.bianconi@redhat.com> wrote:

> Despite this issue is not harmful since it is not actually used in
> mt76 driver, fix DMA txinfo bitmask definition
> 
> Fixes: 7bc04215a66b ('mt76: add driver code for MT76x2e')
> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>

Patch applied to wireless-drivers-next.git, thanks.

cc6603aaeebf mt76x2: fix TXD_INFO bitmask definition

-- 
https://patchwork.kernel.org/patch/10344019/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
