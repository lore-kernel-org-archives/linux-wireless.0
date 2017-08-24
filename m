Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:40298 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751102AbdHXJ7O (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 24 Aug 2017 05:59:14 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: wireless: ipw2x00: make iw_handler_def const
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1503491802-1361-1-git-send-email-bhumirks@gmail.com>
References: <1503491802-1361-1-git-send-email-bhumirks@gmail.com>
To: Bhumika Goyal <bhumirks@gmail.com>
Cc: julia.lawall@lip6.fr, stas.yakovlev@gmail.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Bhumika Goyal <bhumirks@gmail.com>
Message-Id: <20170824095913.CE6AC602B3@smtp.codeaurora.org> (sfid-20170824_115930_921630_E5C49316)
Date: Thu, 24 Aug 2017 09:59:13 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bhumika Goyal <bhumirks@gmail.com> wrote:

> Make these const as they are only stored in the const field of a
> net_device structure.
> 
> Signed-off-by: Bhumika Goyal <bhumirks@gmail.com>

Patch applied to wireless-drivers-next.git, thanks.

2c1dca3c6b22 wireless: ipw2x00: make iw_handler_def const

-- 
https://patchwork.kernel.org/patch/9917307/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
