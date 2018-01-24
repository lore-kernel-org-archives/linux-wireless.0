Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:54982 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934140AbeAXPNc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 Jan 2018 10:13:32 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: mt76: fix transmission of encrypted management frames
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180118180143.82156-1-nbd@nbd.name>
References: <20180118180143.82156-1-nbd@nbd.name>
To: Felix Fietkau <nbd@nbd.name>
Cc: linux-wireless@vger.kernel.org
Message-Id: <20180124151332.1FA1E60A63@smtp.codeaurora.org> (sfid-20180124_161410_120047_2A3FB983)
Date: Wed, 24 Jan 2018 15:13:31 +0000 (UTC)
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

Patch applied to wireless-drivers-next.git, thanks.

23405236460b mt76: fix transmission of encrypted management frames

-- 
https://patchwork.kernel.org/patch/10173781/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
