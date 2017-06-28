Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:48340 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751505AbdF1SSB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Jun 2017 14:18:01 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: cw1200: add const to hwbus_ops structures
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1498218199-13429-1-git-send-email-bhumirks@gmail.com>
References: <1498218199-13429-1-git-send-email-bhumirks@gmail.com>
To: Bhumika Goyal <bhumirks@gmail.com>
Cc: julia.lawall@lip6.fr, pizza@shaftnet.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Bhumika Goyal <bhumirks@gmail.com>
Message-Id: <20170628181801.049B560AD5@smtp.codeaurora.org> (sfid-20170628_201840_154233_44449136)
Date: Wed, 28 Jun 2017 18:18:01 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bhumika Goyal <bhumirks@gmail.com> wrote:

> Declare hwbus_ops structures as const as they are only passed as an
> argument to the function cw1200_core_probe. This argument is of type
> const. So, make these structures const.
> 
> Signed-off-by: Bhumika Goyal <bhumirks@gmail.com>

Patch applied to wireless-drivers-next.git, thanks.

3ac27dd37b40 cw1200: add const to hwbus_ops structures

-- 
https://patchwork.kernel.org/patch/9806289/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
