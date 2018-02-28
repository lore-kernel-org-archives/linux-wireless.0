Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:44828 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752436AbeB1Oyv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Feb 2018 09:54:51 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: mt76x2: remove warnings in mt76x2_mac_write_txwi()
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <39ba1292cb67ee2d4bf0f2813af63786f4241df1.1517443974.git.lorenzo.bianconi@redhat.com>
References: <39ba1292cb67ee2d4bf0f2813af63786f4241df1.1517443974.git.lorenzo.bianconi@redhat.com>
To: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc: nbd@nbd.name, linux-wireless@vger.kernel.org
Message-Id: <20180228145451.4063E602BA@smtp.codeaurora.org> (sfid-20180228_155455_308728_16DFB1EF)
Date: Wed, 28 Feb 2018 14:54:51 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Lorenzo Bianconi <lorenzo.bianconi@redhat.com> wrote:

> Fix following sparse warnings in mt76x2_mac_write_txwi:
> - drivers/net/wireless/mediatek/mt76/mt76x2_mac.c:201:26: warning:
>   incorrect type in assignment (different base types)
> - drivers/net/wireless/mediatek/mt76/mt76x2_mac.c:201:26: expected
>   restricted __le32 [usertype] iv
> - drivers/net/wireless/mediatek/mt76/mt76x2_mac.c:201:26: got unsigned
>   int [unsigned] [usertype] <noident>
> - drivers/net/wireless/mediatek/mt76/mt76x2_mac.c:202:27: warning:
>   incorrect type in assignment (different base types)
> - drivers/net/wireless/mediatek/mt76/mt76x2_mac.c:202:27: expected
>   restricted __le32 [usertype] eiv
> - drivers/net/wireless/mediatek/mt76/mt76x2_mac.c:202:27: got unsigned
>   int [unsigned] [usertype] <noident>
> 
> Fixes: 23405236460b ("mt76: fix transmission of encrypted management frames")
> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>

Patch applied to wireless-drivers-next.git, thanks.

09e93f28aa8d mt76x2: remove warnings in mt76x2_mac_write_txwi()

-- 
https://patchwork.kernel.org/patch/10194957/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
