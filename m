Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:39926 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753864AbdHWKC6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 23 Aug 2017 06:02:58 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Arvind Yadav <arvind.yadav.cs@gmail.com>
Cc: davem@davemloft.net, Larry.Finger@lwfinger.net,
        chaoming_li@realsil.com.cn, jon.maloy@ericsson.com,
        ying.xue@windriver.com, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 3/3] net: rsi: netlink: constify genl_ops
References: <1503482375-19983-1-git-send-email-arvind.yadav.cs@gmail.com>
        <1503482375-19983-4-git-send-email-arvind.yadav.cs@gmail.com>
Date: Wed, 23 Aug 2017 13:02:49 +0300
In-Reply-To: <1503482375-19983-4-git-send-email-arvind.yadav.cs@gmail.com>
        (Arvind Yadav's message of "Wed, 23 Aug 2017 15:29:35 +0530")
Message-ID: <87378iy52u.fsf@kamboji.qca.qualcomm.com> (sfid-20170823_120330_196269_D70589BF)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arvind Yadav <arvind.yadav.cs@gmail.com> writes:

> genl_ops are not supposed to change at runtime. All functions
> working with genl_ops provided by <net/genetlink.h> work with
> const genl_ops. So mark the non-const structs as const.
>
> Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
> ---
>  net/tipc/netlink_compat.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Using the prefix "rsi:" looks wrong for this patch.

-- 
Kalle Valo
