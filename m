Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:33254 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750764AbdAaHJ7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 31 Jan 2017 02:09:59 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: rt2x00: fix clk_get call
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170129114052.GB7489@redhat.com>
References: <20170129114052.GB7489@redhat.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        Daniel Golle <daniel@makrotopia.org>,
        Felix Fietkau <nbd@nbd.name>
Message-Id: <20170131070948.CC9D06071B@smtp.codeaurora.org> (sfid-20170131_081002_287563_027A8634)
Date: Tue, 31 Jan 2017 07:09:48 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> clk_get() takes two arguments and might return ERR_PTR(), so we
> have to nullify pointer on that case, to do not break further call
> to clk_get_rate().
> 
> Reported-by: Felix Fietkau <nbd@nbd.name>
> Fixes: 34db70b92fae ("rt2x00: add copy of clk for soc devices")
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>

Patch applied to wireless-drivers-next.git, thanks.

33e962c8871f rt2x00: fix clk_get call

-- 
https://patchwork.kernel.org/patch/9543961/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
