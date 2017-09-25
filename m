Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:49020 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933294AbdIYI2O (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 25 Sep 2017 04:28:14 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [V3,
 1/9] qtnfmac: convert channel width from bitfiled to simple enum
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170921213437.27457-2-igor.mitsyanko.os@quantenna.com>
References: <20170921213437.27457-2-igor.mitsyanko.os@quantenna.com>
To: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
Cc: linux-wireless@vger.kernel.org,
        sergey.matyukevich.os@quantenna.com, avinashp@quantenna.com,
        johannes@sipsolutions.net
Message-Id: <20170925082813.CCBDF6095F@smtp.codeaurora.org> (sfid-20170925_110029_823483_4211F44D)
Date: Mon, 25 Sep 2017 08:28:13 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Igor Mitsyanko <igor.mitsyanko.os@quantenna.com> wrote:

> From: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
> 
> This will allow to use qlink channel width values to specify BW setting
> corresponding to enum nl80211_chan_width.
> Current user is converted to apply BIT() macro manually to each individual
> qlink_channel_width enumeration value.
> 
> Signed-off-by: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>

9 patches applied to wireless-drivers-next.git, thanks.

77d68147745b qtnfmac: convert channel width from bitfiled to simple enum
fac7f9bf1481 qtnfmac: make "Channel change" event report full channel info
9e5478b608b5 qtnfmac: retrieve current channel info from EP
96d4eaf20fb8 qtnfmac: do not cache channel info from "connect" command
3656ab0fef5b qtnfmac: let wifi card handle channel switch request to the same chan
8c015b9067d6 qtnfmac: pass VIF info to SendChannel command
97397633108a qtnfmac: do not cache CSA chandef info
6bfe61d697cb qtnfmac: remove unused mac::status field
115af851234f qtnfmac: do not report channel changes until wiphy is registered

-- 
https://patchwork.kernel.org/patch/9964831/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
