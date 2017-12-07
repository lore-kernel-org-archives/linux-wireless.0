Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:46092 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753930AbdLGNhU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Dec 2017 08:37:20 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v8,1/3] dt-bindings: net: add mt76 wireless device binding
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20171121095053.82673-2-nbd@nbd.name>
References: <20171121095053.82673-2-nbd@nbd.name>
To: Felix Fietkau <nbd@nbd.name>
Cc: linux-wireless@vger.kernel.org
Message-Id: <20171207133719.EE78260867@smtp.codeaurora.org> (sfid-20171207_143739_149401_112DA167)
Date: Thu,  7 Dec 2017 13:37:19 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau <nbd@nbd.name> wrote:

> Add documentation describing how device tree can be used to configure
> wireless chips supported by the mt76 driver.
> 
> Signed-off-by: Felix Fietkau <nbd@nbd.name>

3 patches applied to wireless-drivers-next.git, thanks.

9402f8eb9bed dt-bindings: net: add mt76 wireless device binding
17f1de56df05 mt76: add common code shared between multiple chipsets
7bc04215a66b mt76: add driver code for MT76x2e

-- 
https://patchwork.kernel.org/patch/10067881/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
