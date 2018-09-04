Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:50840 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726170AbeIDIuB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Sep 2018 04:50:01 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [PATCH 1/3] debug: use common debug for ack timeout output
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1535997033-16330-1-git-send-email-pozega.tomislav@gmail.com>
References: <1535997033-16330-1-git-send-email-pozega.tomislav@gmail.com>
To: =?utf-8?q?Tomislav_Po=C5=BEega?= <pozega.tomislav@gmail.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com,
        ath9k_htc_fw@lists.infradead.org
Message-Id: <20180904042646.48B6E601D3@smtp.codeaurora.org> (sfid-20180904_062651_364483_A8A1AA74)
Date: Tue,  4 Sep 2018 04:26:46 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tomislav Požega wrote:

> Move ack debug code to common-debug and adjust
> ath9k/ath9k_htc debug for common ack output.
> 
> Signed-off-by: Tomislav Požega <pozega.tomislav@gmail.com>

Failed to build:

drivers/net/wireless/ath/ath9k/debug.c: In function 'ath9k_init_debug':
drivers/net/wireless/ath/ath9k/debug.c:1431:2: error: implicit declaration of function 'ath9k_cmn_dbg_ack_to'; did you mean 'ath9k_cmn_debug_ack_to'? [-Werror=implicit-function-declaration]
  ath9k_cmn_dbg_ack_to(sc->debug.debugfs_phy, sc->sc_ah);
  ^~~~~~~~~~~~~~~~~~~~
  ath9k_cmn_debug_ack_to
cc1: some warnings being treated as errors
make[5]: *** [drivers/net/wireless/ath/ath9k/debug.o] Error 1
make[5]: *** Waiting for unfinished jobs....
make[5]: *** wait: No child processes.  Stop.
make[4]: *** [drivers/net/wireless/ath/ath9k] Error 2
make[3]: *** [drivers/net/wireless/ath] Error 2
make[2]: *** [drivers/net/wireless] Error 2
make[1]: *** [drivers/net] Error 2
make: *** [drivers] Error 2

3 patches set to Changes Requested.

10586273 [1/3] debug: use common debug for ack timeout output
10586277 [2/3] ath9k_htc: enable ANI debug output
10586275 [3/3] ath9k_htc: increase number of configurable virtual interfaces

-- 
https://patchwork.kernel.org/patch/10586273/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
