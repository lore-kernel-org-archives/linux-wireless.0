Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:22046 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751743AbcL3JRE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 30 Dec 2016 04:17:04 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath10k: Remove passing unused argument for ath10k_mac_tx
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1482845555-6076-1-git-send-email-mohammed@qca.qualcomm.com>
References: <1482845555-6076-1-git-send-email-mohammed@qca.qualcomm.com>
To: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <mohammed@codeaurora.org>,
        <linux-wireless@vger.kernel.org>,
        Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
Message-ID: <b2b7af5ce38243759cfe7a171962c9da@euamsexm01a.eu.qualcomm.com> (sfid-20161230_101707_233281_6BBC8356)
Date: Fri, 30 Dec 2016 10:16:56 +0100
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com> wrote:
> From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
> 
> 'ath10k_mac_tx' does not seems to use the per station table
> entry pointer 'sta' (struct ieee80211_sta), hence remove passing
> this unused argument
> 
> Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>

Patch applied to ath-next branch of ath.git, thanks.

a7773b5db155 ath10k: Remove passing unused argument for ath10k_mac_tx

-- 
https://patchwork.kernel.org/patch/9489231/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
