Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:57454 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752933AbdDEHpu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Apr 2017 03:45:50 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath10k: Clean header files from bad block comments
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1487601530-22932-1-git-send-email-marcin.rokicki@tieto.com>
References: <1487601530-22932-1-git-send-email-marcin.rokicki@tieto.com>
To: Marcin Rokicki <marcin.rokicki@tieto.com>
CC: <ath10k@lists.infradead.org>,
        Marcin Rokicki <marcin.rokicki@tieto.com>,
        <linux-wireless@vger.kernel.org>
Message-ID: <744f9259075b4d0784712a5cd272024e@euamsexm01a.eu.qualcomm.com> (sfid-20170405_094554_069286_FF56C630)
Date: Wed, 5 Apr 2017 09:45:39 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Marcin Rokicki <marcin.rokicki@tieto.com> wrote:
> Fix output from checkpatch.pl like:
>  Block comments use a trailing */ on a separate line
> 
> Signed-off-by: Marcin Rokicki <marcin.rokicki@tieto.com>

Patch applied to ath-next branch of ath.git, thanks.

37ff1b0df37a ath10k: clean header files from bad block comments

-- 
https://patchwork.kernel.org/patch/9582975/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
