Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:41016 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755755AbdKJCbh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 9 Nov 2017 21:31:37 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [V2,1/9] qtnfmac: use per-band HT/VHT info from wireless device
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20171031010455.27772-2-igor.mitsyanko.os@quantenna.com>
References: <20171031010455.27772-2-igor.mitsyanko.os@quantenna.com>
To: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
Cc: linux-wireless@vger.kernel.org,
        sergey.matyukevich.os@quantenna.com, vulyanov@quantenna.com,
        johannes@sipsolutions.net
Message-Id: <20171110023137.5D098607EA@smtp.codeaurora.org> (sfid-20171110_033141_917390_C10C03B8)
Date: Fri, 10 Nov 2017 02:31:37 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Igor Mitsyanko <igor.mitsyanko.os@quantenna.com> wrote:

> From: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
> 
> HT/VHT capabilities must be reported per each band supported by a radio,
> not for all bands on a radio. Furthermore, driver better not assume
> any capabilities and just use whetever is reported by device itself.
> 
> To support this, convert "get channels" command into "get band info"
> command. Difference is that it may also carry HT/VHT capabilities along
> with channels information.
> 
> While at it, also add "num_bitrates" field to "get band info" command,
> for future use.
> 
> Signed-off-by: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>

9 patches applied to wireless-drivers-next.git, thanks.

e294cbfda056 qtnfmac: use per-band HT/VHT info from wireless device
d42df85f7d85 qtnfmac: initialize HT/VHT caps "can override" masks
d1398b5b34cc qtnfmac: get rid of PHYMODE capabilities flags
18b7470f92df qtnfmac: extend "IE set" TLV to include frame type info
5face518d446 qtnfmac: SCAN results: retreive frame type information from "IE set" TLV
4d1f0fabdc45 qtnfmac: convert "Append IEs" command to QTN_TLV_ID_IE_SET usage
17011da0b8f0 qtnfmac: configure and start AP interface with a single command
a3945f43761c qtnfmac: include HTCAP and VHTCAP into config AP command
c9889671736c qtnfmac: pass all CONNECT cmd params to wireless card for processing

-- 
https://patchwork.kernel.org/patch/10033509/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
