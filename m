Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:52444 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933715AbeEIKZ5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 May 2018 06:25:57 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: mwifiex: delete unneeded include
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1525593233-10968-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1525593233-10968-1-git-send-email-Julia.Lawall@lip6.fr>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: Amitkumar Karwar <amitkarwar@gmail.com>,
        kernel-janitors@vger.kernel.org,
        Nishant Sarmukadam <nishants@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Xinming Hu <huxm@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-Id: <20180509102556.9EB8260F92@smtp.codeaurora.org> (sfid-20180509_122616_108764_3D3D604B)
Date: Wed,  9 May 2018 10:25:56 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Julia Lawall <Julia.Lawall@lip6.fr> wrote:

> Nothing that is defined in 11ac.h is referenced in cmdevt.c.
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

Patch applied to wireless-drivers-next.git, thanks.

4793e5a954fa mwifiex: delete unneeded include

-- 
https://patchwork.kernel.org/patch/10382667/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
