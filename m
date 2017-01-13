Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:8550 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751445AbdAMOEc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Jan 2017 09:04:32 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [3/5] ath10k: Remove unused wmi_p2p_noa_descriptor 'noa' in
 wmi-tlv
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <99d0ff42e57d5f62560e72d926b4d69d5d7c418b.1479974100.git.kirtika@chromium.org>
References: <99d0ff42e57d5f62560e72d926b4d69d5d7c418b.1479974100.git.kirtika@chromium.org>
To: Kirtika Ruchandani <kirtika.ruchandani@gmail.com>
CC: Arnd Bergmann <arnd@arndb.de>, <netdev@vger.kernel.org>,
        <linux-wireless@vger.kernel.org>,
        Raja Mani <rmani@qti.qualcomm.com>,
        "Michal Kazior" <michal.kazior@tieto.com>
Message-ID: <ab6e49f1d0f2446c8a411cfd688ab0e9@euamsexm01a.eu.qualcomm.com> (sfid-20170113_150436_111178_05F72C2E)
Date: Fri, 13 Jan 2017 15:01:57 +0100
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kirtika Ruchandani <kirtika.ruchandani@gmail.com> wrote:
> Commit ca996ec56608 (ath10k: implement wmi-tlv backend)
> introduced ath10k_wmi_tlv_op_gen_vdev_start() where
> 'struct wmi_p2p_noa_descriptor *noa' is defined and set but not used.
> Compiling with W=1 gives the following warning, fix it.
> drivers/net/wireless/ath/ath10k/wmi-tlv.c: In function ‘ath10k_wmi_tlv_op_gen_vdev_start’:
> drivers/net/wireless/ath/ath10k/wmi-tlv.c:1647:33: warning: variable ‘noa’ set but not used [-Wunused-but-set-variable]
> 
> Fixes: ca996ec56608 ("ath10k: implement wmi-tlv backend")
> Cc: Michal Kazior <michal.kazior@tieto.com>
> Cc: Kalle Valo <kvalo@qca.qualcomm.com>
> Signed-off-by: Kirtika Ruchandani <kirtika@chromium.org>

No response to Michal's comment by the author

Patch set to Changes Requested.

-- 
https://patchwork.kernel.org/patch/9444937/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
