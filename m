Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:48524 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754825AbeF0QFu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 27 Jun 2018 12:05:50 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: mt76x2: fix mrr idx/count estimation in
 mt76x2_mac_fill_tx_status()
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <b69193d3a01564778b9824ebb07cb4e677e3462a.1528098972.git.lorenzo.bianconi@redhat.com>
References: <b69193d3a01564778b9824ebb07cb4e677e3462a.1528098972.git.lorenzo.bianconi@redhat.com>
To: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc: nbd@nbd.name, linux-wireless@vger.kernel.org
Message-Id: <20180627160549.EE25660AD8@smtp.codeaurora.org> (sfid-20180627_180554_968160_4E1C290D)
Date: Wed, 27 Jun 2018 16:05:49 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Lorenzo Bianconi <lorenzo.bianconi@redhat.com> wrote:

> Fix mcs and attempt count estimation in mt76x2_mac_fill_tx_status routine
> if the number of tx retries reported by the hw is grater than
> IEEE80211_TX_MAX_RATES
> 
> Fixes: 7bc04215a66b ("mt76: add driver code for MT76x2e")
> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>

Patch applied to wireless-drivers-next.git, thanks.

2d1e9be00162 mt76x2: fix mrr idx/count estimation in mt76x2_mac_fill_tx_status()

-- 
https://patchwork.kernel.org/patch/10446149/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
