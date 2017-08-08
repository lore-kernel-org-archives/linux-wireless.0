Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:46117 "EHLO
        sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752003AbdHHLGU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 8 Aug 2017 07:06:20 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v3] ath10k: ath10k_htt_rx_amsdu_allowed() use ath10k_dbg()
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <20170719191955.11518-1-nix.or.die@gmail.com>
References: <20170719191955.11518-1-nix.or.die@gmail.com>
To: Gabriel C <nix.or.die@gmail.com>
CC: <ath10k@lists.infradead.org>, <ryanhsu@qti.qualcomm.com>,
        <joe@perches.com>, <linux-wireless@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        Gabriel Craciunescu <nix.or.die@gmail.com>
Message-ID: <b458726452224508b342d1ab932e1fa2@euamsexm01a.eu.qualcomm.com> (sfid-20170808_130653_300731_0E5C55E2)
Date: Tue, 8 Aug 2017 13:06:11 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Gabriel C <nix.or.die@gmail.com> wrote:

> Each time we get disconnected from AP we get flooded with messages like:
> 
> ...
> ath10k_pci 0000:03:00.0: no channel configured; ignoring frame(s)!
> <until ratelimit kicks in>
> ath10k_warn: 155 callbacks suppressed
> ...
> 
> Use ath10k_dbg() here too.
> 
> Signed-off-by: Gabriel Craciunescu <nix.or.die@gmail.com>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

Patch applied to ath-next branch of ath.git, thanks.

984eb9053280 ath10k: ath10k_htt_rx_amsdu_allowed() use ath10k_dbg()

-- 
https://patchwork.kernel.org/patch/9853129/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
