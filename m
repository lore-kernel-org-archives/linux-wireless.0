Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:32800 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752795AbeAHR1a (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Jan 2018 12:27:30 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [04/14] mt76x2: fix transmission of encrypted management frames
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20171214153918.43774-5-nbd@nbd.name>
References: <20171214153918.43774-5-nbd@nbd.name>
To: Felix Fietkau <nbd@nbd.name>
Cc: linux-wireless@vger.kernel.org
Message-Id: <20180108172729.A550B6079C@smtp.codeaurora.org> (sfid-20180108_182736_717912_E0B5107B)
Date: Mon,  8 Jan 2018 17:27:29 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau <nbd@nbd.name> wrote:

> Hardware encryption seems to break encrypted unicast mgmt tx.
> Unfortunately the hardware TXWI header does not have a bit to indicate
> that a frame is software encrypted, so sw-encrypted frames need to use a
> different WCID. For that to work, the CCMP PN needs to be generated in
> software, which makes things a bit slower, so only do it for keys that
> also need to tx management frames.
> 
> Signed-off-by: Felix Fietkau <nbd@nbd.name>

Failed to apply:

fatal: sha1 information is lacking or useless (drivers/net/wireless/mediatek/mt76/mt76x2_mac.c).
error: could not build fake ancestor
Applying: mt76x2: fix transmission of encrypted management frames
Patch failed at 0001 mt76x2: fix transmission of encrypted management frames
The copy of the patch that failed is found in: .git/rebase-apply/patch

Patch set to Changes Requested.

-- 
https://patchwork.kernel.org/patch/10112573/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
