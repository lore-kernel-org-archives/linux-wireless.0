Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:54038 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725891AbeHRJRB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 18 Aug 2018 05:17:01 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Nye Liu <nyet@nyet.org>
Cc: Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH] Fix Bug 199967 - change WARN_ON(1) to IWL_ERR()
References: <20180818033555.18110-1-nyet@nyet.org>
Date: Sat, 18 Aug 2018 09:10:28 +0300
In-Reply-To: <20180818033555.18110-1-nyet@nyet.org> (Nye Liu's message of
        "Fri, 17 Aug 2018 20:35:55 -0700")
Message-ID: <87tvnstdbf.fsf@kamboji.qca.qualcomm.com> (sfid-20180818_081525_134912_CD5DE523)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

+ linux-wireless

Nye Liu <nyet@nyet.org> writes:

> The TX_STATUS_FAIL_DEST_PS case fills logs with full backtraces, which
> are pretty useless. Just do IWL_ERR() printk.
>
> Signed-off-by: Nye Liu <nyet@nyet.org>
> ---
>  drivers/net/wireless/intel/iwlwifi/mvm/tx.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)

Please use prefix "iwlwifi: " and Cc linux-wireless.

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches#commit_title_is_wrong

-- 
Kalle Valo
