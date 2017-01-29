Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:48336 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750990AbdA2Oyk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 29 Jan 2017 09:54:40 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        Daniel Golle <daniel@makrotopia.org>,
        Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH] rt2x00: fix clk_get call
References: <20170129114052.GB7489@redhat.com>
Date: Sun, 29 Jan 2017 16:53:38 +0200
In-Reply-To: <20170129114052.GB7489@redhat.com> (Stanislaw Gruszka's message
        of "Sun, 29 Jan 2017 12:40:52 +0100")
Message-ID: <87vasxgbnx.fsf@purkki.adurom.net> (sfid-20170129_155445_240357_AF1883DB)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stanislaw Gruszka <sgruszka@redhat.com> writes:

> clk_get() takes two arguments and might return ERR_PTR(), so we
> have to nullify pointer on that case, to do not break further call
> to clk_get_rate().
>
> Reported-by: Felix Fietkau <nbd@nbd.name>
> Fixes: 34db70b92fae5 ("rt2x00: add copy of clk for soc devices")
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>

The commit id looks wrong, I think it should be:

Fixes: 34db70b92fae ("rt2x00: add copy of clk for soc devices")

I can fix that during commit.

-- 
Kalle Valo
