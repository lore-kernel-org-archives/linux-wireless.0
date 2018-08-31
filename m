Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:49648 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727286AbeHaTg3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 31 Aug 2018 15:36:29 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [PATCH] mt76x2: fix always true condition warning reported by
 static checker
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <a7bac1a6a98a3b937fdb4bd5de4ae6337817b08d.1534759721.git.lorenzo.bianconi@redhat.com>
References: <a7bac1a6a98a3b937fdb4bd5de4ae6337817b08d.1534759721.git.lorenzo.bianconi@redhat.com>
To: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc: nbd@nbd.name, linux-wireless@vger.kernel.org,
        dan.carpenter@oracle.com
Message-Id: <20180831152828.DD23460445@smtp.codeaurora.org> (sfid-20180831_172833_257500_71B6A2F8)
Date: Fri, 31 Aug 2018 15:28:28 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Lorenzo Bianconi <lorenzo.bianconi@redhat.com> wrote:

> Fix following warning reported by static checker:
> 
> drivers/net/wireless/mediatek/mt76/mt76x2_tx_common.c:35 mt76x2_tx()
> warn: always true condition '(wcid->hw_key_idx != -1) => (0-255 != (-1))'
> 
> Fixes: 23405236460b ("mt76: fix transmission of encrypted mgmt frames")
> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>

Dropping this as I take Geert's version

Patch set to Rejected.

-- 
https://patchwork.kernel.org/patch/10570555/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
