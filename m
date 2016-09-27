Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:53154 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933320AbcI0MOm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Sep 2016 08:14:42 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/3] ath10k: use devm_clk_get() instead of clk_get()
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1473165598-28683-2-git-send-email-yamada.masahiro@socionext.com>
References: <1473165598-28683-2-git-send-email-yamada.masahiro@socionext.com>
To: Masahiro Yamada <yamada.masahiro@socionext.com>
CC: <linux-wireless@vger.kernel.org>,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <ath10k@lists.infradead.org>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Johannes Berg <johannes@sipsolutions.net>
Message-ID: <e4a0ff1bec4b4e88b61c88988a7683d6@euamsexm01a.eu.qualcomm.com> (sfid-20160927_141521_284559_1CFC7E62)
Date: Tue, 27 Sep 2016 14:14:33 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Masahiro Yamada <yamada.masahiro@socionext.com> wrote:
> Use the managed variant of clk_get() to simplify the failure path
> and the .remove callback.
> 
> Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>

3 patches applied to ath-next branch of ath.git, thanks.

828662753d60 ath10k: use devm_clk_get() instead of clk_get()
c5d8a34675d9 ath10k: use devm_reset_control_get() instead of reset_control_get()
65901a9e7058 ath10k: do not check if reset is NULL

-- 
https://patchwork.kernel.org/patch/9316579/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
