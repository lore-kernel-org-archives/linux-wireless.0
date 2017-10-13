Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:54729 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753378AbdJMLlY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Oct 2017 07:41:24 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath9k: fix tx99 potential info leak
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1506474814-18118-1-git-send-email-miaoqing@codeaurora.org>
References: <1506474814-18118-1-git-send-email-miaoqing@codeaurora.org>
To: miaoqing pan <miaoqing@codeaurora.org>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@qca.qualcomm.com>,
        <sssa@qti.qualcomm.com>, Miaoqing Pan <miaoqing@codeaurora.org>
Message-ID: <003892f366354efdab9ea92c2eaf01b2@euamsexm01e.eu.qualcomm.com> (sfid-20171013_134128_154066_3E3BC328)
Date: Fri, 13 Oct 2017 13:41:17 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

miaoqing pan <miaoqing@codeaurora.org> wrote:

> When the user sets count to zero the string buffer would remain
> completely uninitialized which causes the kernel to parse its
> own stack data, potentially leading to an info leak. In addition
> to that, the string might be not terminated properly when the
> user data does not contain a 0-terminator.
> 
> Signed-off-by: Miaoqing Pan <miaoqing@codeaurora.org>
> Reviewed-by: Christoph Böhmwalder <christoph@boehmwalder.at>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

Patch applied to ath-next branch of ath.git, thanks.

ee0a47186e2f ath9k: fix tx99 potential info leak

-- 
https://patchwork.kernel.org/patch/9972889/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
