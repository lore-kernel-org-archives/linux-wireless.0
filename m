Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:57986 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751460AbeDXR2Y (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 24 Apr 2018 13:28:24 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: mt7601u: phy: mark expected switch fall-through
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180330211223.GA22497@embeddedgus>
References: <20180330211223.GA22497@embeddedgus>
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc: Jakub Kicinski <kubakici@wp.pl>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Message-Id: <20180424172823.754ED60A06@smtp.codeaurora.org> (sfid-20180424_192847_893706_C792D4CE)
Date: Tue, 24 Apr 2018 17:28:23 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Gustavo A. R. Silva" <gustavo@embeddedor.com> wrote:

> In preparation to enabling -Wimplicit-fallthrough, mark switch cases
> where we are expecting to fall through.
> 
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> Acked-by: Jakub Kicinski <kubakici@wp.pl>

Patch applied to wireless-drivers-next.git, thanks.

5156b054bcda mt7601u: phy: mark expected switch fall-through

-- 
https://patchwork.kernel.org/patch/10318419/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
