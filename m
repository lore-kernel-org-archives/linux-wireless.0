Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:47609 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751593AbdJ0Nuv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 27 Oct 2017 09:50:51 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath9k: debug: Remove redundant check
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1507974371-7419-1-git-send-email-chris.gekas@gmail.com>
References: <1507974371-7419-1-git-send-email-chris.gekas@gmail.com>
To: Christos Gkekas <chris.gekas@gmail.com>
CC: QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Christos Gkekas <chris.gekas@gmail.com>
Message-ID: <950220104459484c9610cd0fc7ac3ca6@euamsexm01a.eu.qualcomm.com> (sfid-20171027_155236_804769_49117F0D)
Date: Fri, 27 Oct 2017 15:50:43 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Christos Gkekas <chris.gekas@gmail.com> wrote:

> Variable val is unsigned, so checking whether it is less than zero is
> redundant.
> 
> Signed-off-by: Christos Gkekas <chris.gekas@gmail.com>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

Patch applied to ath-next branch of ath.git, thanks.

9d414949a306 ath9k: debug: Remove redundant check

-- 
https://patchwork.kernel.org/patch/10006341/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
