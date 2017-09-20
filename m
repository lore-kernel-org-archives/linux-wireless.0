Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:43994 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751748AbdITMXO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Sep 2017 08:23:14 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [V2,
 1/9] qtnfmac: qlink: convert channel width from bitfiled to simple
 enum
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170902014451.17766-2-igor.mitsyanko.os@quantenna.com>
References: <20170902014451.17766-2-igor.mitsyanko.os@quantenna.com>
To: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
Cc: linux-wireless@vger.kernel.org,
        sergey.matyukevich.os@quantenna.com, avinashp@quantenna.com,
        johannes@sipsolutions.net
Message-Id: <20170920122314.5397A60710@smtp.codeaurora.org> (sfid-20170920_142318_172133_D4C5C43C)
Date: Wed, 20 Sep 2017 12:23:14 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Igor Mitsyanko <igor.mitsyanko.os@quantenna.com> wrote:

> From: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
> 
> Signed-off-by: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
> Reviewed-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>

No empty commit logs, please. After the first patch I was about to write
one myself but after seeing multiple of them I'm not going to do that.

9 patches set to Changes Requested.

9935431 [V2,1/9] qtnfmac: qlink: convert channel width from bitfiled to simple enum
9935437 [V2,2/9] qtnfmac: make "Channel change" event report full channel info
9935443 [V2,3/9] qtnfmac: retrieve current channel info from EP
9935445 [V2,4/9] qtnfmac: do not cache channel info from "connect" command
9935429 [V2,5/9] qtnfmac: let wifi card handle channel switch request to the same chan
9935441 [V2,6/9] qtnfmac: pass VIF info to SendChannel command
9935433 [V2,7/9] qtnfmac: do not cache CSA chandef info
9935439 [V2,8/9] qtnfmac: remove unused mac::status field
9935435 [V2,9/9] qtnfmac: do not report channel changes until wiphy is registered

-- 
https://patchwork.kernel.org/patch/9935431/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
