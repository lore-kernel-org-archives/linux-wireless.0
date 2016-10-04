Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:43049 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752027AbcJDPCn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Oct 2016 11:02:43 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/2] ath: export alpha2 helper
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1470140454-3899-2-git-send-email-bartosz.markowski@tieto.com>
References: <1470140454-3899-2-git-send-email-bartosz.markowski@tieto.com>
To: Bartosz Markowski <bartosz.markowski@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        "Michal Kazior" <michal.kazior@tieto.com>,
        Bartosz Markowski <bartosz.markowski@tieto.com>
Message-ID: <7569987251e5403ebe0c30061dd7db5c@euamsexm01a.eu.qualcomm.com> (sfid-20161004_170247_998319_C8E694AA)
Date: Tue, 4 Oct 2016 17:02:36 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bartosz Markowski <bartosz.markowski@tieto.com> wrote:
> From: Michal Kazior <michal.kazior@tieto.com>
> 
> This will be helpful for drivers that can acquire
> alpha2 regulatory codes.
> 
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
> Signed-off-by: Bartosz Markowski <bartosz.markowski@tieto.com>

2 patches applied to ath-next branch of ath.git, thanks.

d291d8e0592a ath: export alpha2 helper
209b2a68de76 ath10k: add platform regulatory domain support

-- 
https://patchwork.kernel.org/patch/9256535/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
