Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:55866 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755335AbdCTRR2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 20 Mar 2017 13:17:28 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: rt2x00: fix TX_PWR_CFG_4 register definition
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170308235412.GA22227@makrotopia.org>
References: <20170308235412.GA22227@makrotopia.org>
To: Daniel Golle <daniel@makrotopia.org>
Cc: linux-wireless@vger.kernel.org,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Helmut Schaa <helmut.schaa@googlemail.com>
Message-Id: <20170320171727.22CCA60BF7@smtp.codeaurora.org> (sfid-20170320_181801_562248_D77B34EB)
Date: Mon, 20 Mar 2017 17:17:22 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Daniel Golle <daniel@makrotopia.org> wrote:
> Some of the macros used to describe the TX_PWR_CFG_4 register accidentally
> refer to TX_PWR_CFG_3, probably a copy&paste error. Fix that.
> 
> Signed-off-by: Daniel Golle <daniel@makrotopia.org>
> Acked-by: Stanislaw Gruszka <sgruszka@redhat.com>

Patch applied to wireless-drivers-next.git, thanks.

5ce33b603063 rt2x00: fix TX_PWR_CFG_4 register definition

-- 
https://patchwork.kernel.org/patch/9612163/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
