Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:56754 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751790AbdKULP5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Nov 2017 06:15:57 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v8,1/3] dt-bindings: net: add mt76 wireless device binding
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20171121095053.82673-2-nbd@nbd.name>
References: <20171121095053.82673-2-nbd@nbd.name>
To: Felix Fietkau <nbd@nbd.name>
Cc: linux-wireless@vger.kernel.org
Message-Id: <20171121111557.1FC07607F1@smtp.codeaurora.org> (sfid-20171121_121616_369873_D3205983)
Date: Tue, 21 Nov 2017 11:15:57 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau <nbd@nbd.name> wrote:

> Add documentation describing how device tree can be used to configure
> wireless chips supported by the mt76 driver.
> 
> Signed-off-by: Felix Fietkau <nbd@nbd.name>

Thanks, this patchset compiles now. I pushed this to wireless-drivers-next
pending branch so that kbuild bot can test these.

-- 
https://patchwork.kernel.org/patch/10067881/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
