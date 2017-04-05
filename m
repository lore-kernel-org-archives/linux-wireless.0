Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:16324 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753655AbdDEHjI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Apr 2017 03:39:08 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath10k: Remove obselete Copy Engine comments
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1490961644-375-1-git-send-email-mohammed@qca.qualcomm.com>
References: <1490961644-375-1-git-send-email-mohammed@qca.qualcomm.com>
To: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <mohammed@codeaurora.org>,
        <linux-wireless@vger.kernel.org>,
        Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
Message-ID: <d80356c70d454a3a8d4decd85ff8033d@euamsexm01a.eu.qualcomm.com> (sfid-20170405_093911_187072_3A5C5EAF)
Date: Wed, 5 Apr 2017 09:39:00 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com> wrote:
> From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
> 
> Remove obselete Copy Engine comments referring to the function
> ath10k_ce_sendlist_send as this function was removed long time back
> by the commit 2e761b5a5222 ("ath10k: remove ce_sendlist_send").
> 
> Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>

Patch applied to ath-next branch of ath.git, thanks.

fb7fa766a8cf ath10k: remove obselete Copy Engine comments

-- 
https://patchwork.kernel.org/patch/9656117/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
