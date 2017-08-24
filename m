Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([184.105.139.130]:60684 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750806AbdHXFcN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 24 Aug 2017 01:32:13 -0400
Date: Wed, 23 Aug 2017 22:32:12 -0700 (PDT)
Message-Id: <20170823.223212.2236765862347036476.davem@davemloft.net> (sfid-20170824_073230_784715_528D00E8)
To: arvind.yadav.cs@gmail.com
Cc: Larry.Finger@lwfinger.net, chaoming_li@realsil.com.cn,
        kvalo@codeaurora.org, jon.maloy@ericsson.com,
        ying.xue@windriver.com, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 3/3 v3] net: tipc: constify genl_ops
From: David Miller <davem@davemloft.net>
In-Reply-To: <1503485540-22113-1-git-send-email-arvind.yadav.cs@gmail.com>
References: <1503485540-22113-1-git-send-email-arvind.yadav.cs@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arvind Yadav <arvind.yadav.cs@gmail.com>
Date: Wed, 23 Aug 2017 16:22:20 +0530

> genl_ops are not supposed to change at runtime. All functions
> working with genl_ops provided by <net/genetlink.h> work with
> const genl_ops. So mark the non-const structs as const.
> 
> Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>

Applied.
