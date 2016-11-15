Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:34696 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752305AbcKOO6U (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 Nov 2016 09:58:20 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath9k_htc: fix minor mistakes in dev_err messages
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <20161031151247.18127-1-colin.king@canonical.com>
References: <20161031151247.18127-1-colin.king@canonical.com>
To: Colin Ian King <colin.king@canonical.com>
CC: QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Message-ID: <b7cc9960ad9d4227bf4388d05a6d8dad@euamsexm01a.eu.qualcomm.com> (sfid-20161115_155847_791505_F78E8001)
Date: Tue, 15 Nov 2016 15:58:11 +0100
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Colin Ian King <colin.king@canonical.com> wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> Add missing space in a dev_err message and join wrapped text so
> it does not span multiple lines.  Fix spelling mistake on "unknown".
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Patch applied to ath-next branch of ath.git, thanks.

14acebc33e6d ath9k_htc: fix minor mistakes in dev_err messages

-- 
https://patchwork.kernel.org/patch/9405663/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
