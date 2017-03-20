Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:5073 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751972AbdCTP2g (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 20 Mar 2017 11:28:36 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath10k: remove redundant check of len with buf_len
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <20170315163641.17052-1-colin.king@canonical.com>
References: <20170315163641.17052-1-colin.king@canonical.com>
To: Colin Ian King <colin.king@canonical.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kernel-janitors@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Message-ID: <a669166e00c5481e880f6cfbb28fea7f@euamsexm01a.eu.qualcomm.com> (sfid-20170320_163208_609385_695FD781)
Date: Mon, 20 Mar 2017 16:25:19 +0100
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Colin Ian King <colin.king@canonical.com> wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The check of len > buf_len is redundant as len is initialized
> to 0 and buf_len to 4096, so this comparison is always false.
> Remove it.
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Patch applied to ath-next branch of ath.git, thanks.

eed4721fb617 ath10k: remove redundant check of len with buf_len

-- 
https://patchwork.kernel.org/patch/9626131/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
