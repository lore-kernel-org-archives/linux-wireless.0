Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:51506 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754506AbdLGNpM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Dec 2017 08:45:12 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ssb: make SSB a menuconfig to ease disabling it all
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20171204222744.8817-2-vincent.legoll@gmail.com>
References: <20171204222744.8817-2-vincent.legoll@gmail.com>
To: Vincent Legoll <vincent.legoll@gmail.com>
Cc: m@bues.ch, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Vincent Legoll <vincent.legoll@gmail.com>
Message-Id: <20171207134511.E7853607EA@smtp.codeaurora.org> (sfid-20171207_144635_024248_5D5D2F06)
Date: Thu,  7 Dec 2017 13:45:11 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Vincent Legoll <vincent.legoll@gmail.com> wrote:

> No need to get into the submenu to disable all SSB-related
> config entries.
> 
> This makes it easier to disable all SSB config options
> without entering the submenu. It will also enable one
> to see that en/dis-abled state from the outside menu.
> 
> This is only intended to change menuconfig UI, not change
> the config dependencies.
> 
> Signed-off-by: Vincent Legoll <vincent.legoll@gmail.com>

Patch applied to wireless-drivers-next.git, thanks.

8c9fdd7687d9 ssb: make SSB a menuconfig to ease disabling it all

-- 
https://patchwork.kernel.org/patch/10091683/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
