Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:56660 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753884AbeAHRkS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Jan 2018 12:40:18 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/2] rt2x00: pause almost full queue early
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1513683236-13402-1-git-send-email-sgruszka@redhat.com>
References: <1513683236-13402-1-git-send-email-sgruszka@redhat.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        Enrico Mioso <mrkiko.rs@gmail.com>,
        Daniel Golle <daniel@makrotopia.org>,
        Felix Fietkau <nbd@nbd.name>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Message-Id: <20180108174017.A371C60818@smtp.codeaurora.org> (sfid-20180108_184022_631247_433003DA)
Date: Mon,  8 Jan 2018 17:40:17 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stanislaw Gruszka <sgruszka@redhat.com> wrote:

> Do not drop &queue->tx_lock and acquire it again to pause queue when
> available entries are below the threshold.
> 
> Patch should mitigate problem of frequently printed errors:
> "Error - Dropping frame due to full tx queue"
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> Tested-by: Enrico Mioso@gmail.com
> Tested-by: Enrico Mioso <mrkiko.rs@gmail.com>

2 patches applied to wireless-drivers-next.git, thanks.

3d8f162cb8ec rt2x00: pause almost full queue early
6dd80efd75ce rt2x00: do not pause queue unconditionally on error path

-- 
https://patchwork.kernel.org/patch/10123101/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
