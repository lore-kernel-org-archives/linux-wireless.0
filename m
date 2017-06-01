Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:52243 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751058AbdFANCG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Jun 2017 09:02:06 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath10k: fix the logic of limiting tdls peer counts
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1496177909-5579-1-git-send-email-ryanhsu@qca.qualcomm.com>
References: <1496177909-5579-1-git-send-email-ryanhsu@qca.qualcomm.com>
To: <ryanhsu@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        <ryanhsu@qti.qualcomm.com>, <kaliu@qti.qualcomm.com>,
        <yintang@qti.qualcomm.com>
Message-ID: <022043783bb54759888017d9acd62c47@eusanexr01a.eu.qualcomm.com> (sfid-20170601_150227_772151_FE4AC98E)
Date: Thu, 1 Jun 2017 06:02:00 -0700
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ryanhsu@qti.qualcomm.com wrote:

> The original idea is to limit the maximum TDLS peer link, but the logic
> is always false, and never be able to restrict the number of TDLS peer
> creation.
> 
> Fix the logic here and also move the checking earlier, so that it could
> avoid to handle the failure case, e.g disable the tdls peer, delete the
> peer and also vdev count cleanup.
> 
> Signed-off-by: Ryan Hsu <ryanhsu@qti.qualcomm.com>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

Patch applied to ath-next branch of ath.git, thanks.

9a993cc1ea95 ath10k: fix the logic of limiting tdls peer counts

-- 
https://patchwork.kernel.org/patch/9755235/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
