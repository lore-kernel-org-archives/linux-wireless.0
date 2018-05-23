Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:59840 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753986AbeEWH5w (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 23 May 2018 03:57:52 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/2] mt76: fix sending encrypted broadcast packets for secondary
 interfaces
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180515123323.24702-1-nbd@nbd.name>
References: <20180515123323.24702-1-nbd@nbd.name>
To: Felix Fietkau <nbd@nbd.name>
Cc: linux-wireless@vger.kernel.org
Message-Id: <20180523075751.8A89C60618@smtp.codeaurora.org> (sfid-20180523_095755_458160_4CE0EFEA)
Date: Wed, 23 May 2018 07:57:51 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau <nbd@nbd.name> wrote:

> For encryption to work properly, the BSS index needs to be initialized
> for the WCID entry used for the interface.
> 
> Signed-off-by: Felix Fietkau <nbd@nbd.name>

2 patches applied to wireless-drivers-next.git, thanks.

d98fb328ad10 mt76: fix sending encrypted broadcast packets for secondary interfaces
66a77cbe63eb mt76: discard early received packets if not running yet

-- 
https://patchwork.kernel.org/patch/10400931/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
