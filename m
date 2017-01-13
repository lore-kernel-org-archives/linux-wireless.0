Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:18770 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751760AbdAMN1a (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Jan 2017 08:27:30 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2,1/2] ath10k: refactor ath10k_peer_assoc_h_phymode()
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <20161014101859.5300.47040.stgit@potku.adurom.net>
References: <20161014101859.5300.47040.stgit@potku.adurom.net>
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Message-ID: <ceac78fa3ca848f593955708bed59c0d@euamsexm01a.eu.qualcomm.com> (sfid-20170113_142734_659261_7A680BEA)
Date: Fri, 13 Jan 2017 14:27:18 +0100
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> When adding VHT160 support to ath10k_peer_assoc_h_phymode() the VHT mode
> selection code becomes too complex. Simplify it by refactoring the vht part to
> a separate function.
> 
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

2 patches applied to ath-next branch of ath.git, thanks.

06efdbe70f9c ath10k: refactor ath10k_peer_assoc_h_phymode()
bc1efd739b61 ath10k: add VHT160 support

-- 
https://patchwork.kernel.org/patch/9376371/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
