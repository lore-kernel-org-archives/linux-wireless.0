Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:20819 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755731AbcLOIpG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Dec 2016 03:45:06 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath9k: Turn ath_txq_lock/unlock() into static inlines.
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <20161128102024.14925-1-toke@toke.dk>
References: <20161128102024.14925-1-toke@toke.dk>
To: =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
CC: <linux-wireless@vger.kernel.org>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Message-ID: <e6018d145f4249219bddae9740a276b9@euamsexm01a.eu.qualcomm.com> (sfid-20161215_094509_885943_6C81FDF5)
Date: Thu, 15 Dec 2016 09:44:36 +0100
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Toke Høiland-Jørgensen wrote:
> These are one-line functions that just call spin_lock/unlock_bh(); turn
> them into static inlines to avoid the function call overhead.
> 
> Signed-off-by: Toke Høiland-Jørgensen <toke@toke.dk>

Patch applied to ath-next branch of ath.git, thanks.

5c4607ebaabe ath9k: Turn ath_txq_lock/unlock() into static inlines.

-- 
https://patchwork.kernel.org/patch/9449285/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
