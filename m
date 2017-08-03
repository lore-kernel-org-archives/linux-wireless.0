Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:37482 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752006AbdHCKIz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 3 Aug 2017 06:08:55 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [net] hostap: Fix outdated comment about dev->destructor
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <0824ed85fd45846da65fc919ae22df9d7ebf2f97.1501150507.git.sbrivio@redhat.com>
References: <0824ed85fd45846da65fc919ae22df9d7ebf2f97.1501150507.git.sbrivio@redhat.com>
To: Stefano Brivio <sbrivio@redhat.com>
Cc: netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jouni Malinen <j@w1.fi>, linux-wireless@vger.kernel.org
Message-Id: <20170803100854.D9AE560763@smtp.codeaurora.org> (sfid-20170803_120859_508583_236A091C)
Date: Thu,  3 Aug 2017 10:08:54 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stefano Brivio <sbrivio@redhat.com> wrote:

> After commit cf124db566e6 ("net: Fix inconsistent teardown and
> release of private netdev state."), setting
> 'dev->needs_free_netdev' ensures device data is released, and
> 'dev->destructor' is not used anymore.
> 
> Fixes: cf124db566e6 ("net: Fix inconsistent teardown and release of private netdev state.")
> Signed-off-by: Stefano Brivio <sbrivio@redhat.com>

Patch applied to wireless-drivers-next.git, thanks.

9ff067ff4c4a hostap: Fix outdated comment about dev->destructor

-- 
https://patchwork.kernel.org/patch/9866663/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
