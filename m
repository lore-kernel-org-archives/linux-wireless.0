Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([184.105.139.130]:55316 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934183AbeE2Nyp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 May 2018 09:54:45 -0400
Date: Tue, 29 May 2018 09:54:42 -0400 (EDT)
Message-Id: <20180529.095442.2136175767059213822.davem@davemloft.net> (sfid-20180529_155504_621841_FDD260C0)
To: yuehaibing@huawei.com
Cc: jiri@resnulli.us, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, johannes@sipsolutions.net,
        kvalo@codeaurora.org, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org, sameo@linux.intel.com,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH net-next] net: remove unnecessary genlmsg_cancel() calls
From: David Miller <davem@davemloft.net>
In-Reply-To: <20180526111548.17184-1-yuehaibing@huawei.com>
References: <20180526111548.17184-1-yuehaibing@huawei.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: YueHaibing <yuehaibing@huawei.com>
Date: Sat, 26 May 2018 19:15:48 +0800

> the message be freed immediately, no need to trim it
> back to the previous size.
> 
> Inspired by commit 7a9b3ec1e19f ("nl80211: remove unnecessary genlmsg_cancel() calls")
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Applied.
