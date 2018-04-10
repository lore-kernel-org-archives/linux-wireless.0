Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:40938 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752955AbeDJOZN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 10 Apr 2018 10:25:13 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2,13/13] dt: bindings: add bindings for wcn3990 wifi block
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1521781424-24972-14-git-send-email-govinds@codeaurora.org>
References: <1521781424-24972-14-git-send-email-govinds@codeaurora.org>
To: Govind Singh <govinds@codeaurora.org>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Govind Singh <govinds@codeaurora.org>
Message-Id: <20180410142513.238DE60D81@smtp.codeaurora.org> (sfid-20180410_162518_462512_68F4051C)
Date: Tue, 10 Apr 2018 14:25:13 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Govind Singh <govinds@codeaurora.org> wrote:

> Add device tree binding documentation details for wcn3990
> wifi block present in Qualcomm SDM845/APQ8098 SoC into
> "qcom,ath10k.txt".
> 
> Signed-off-by: Govind Singh <govinds@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Govind, you forgot to CC devicetree list. I was wondering why there's no ack
from device tree maintainers and realised only now that they were not CCed.

Please resubmit this patch unmodified (no need to resubmit others) and CC also
devicetree list. Hopefully we get an ack from them and I can finally apply this
patchset.

-- 
https://patchwork.kernel.org/patch/10302683/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
