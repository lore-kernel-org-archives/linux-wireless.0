Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:41492 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730561AbeG0QVI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 27 Jul 2018 12:21:08 -0400
Date: Fri, 27 Jul 2018 16:56:02 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: YueHaibing <yuehaibing@huawei.com>
Cc: davem@davemloft.net, helmut.schaa@googlemail.com,
        kvalo@codeaurora.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rt2x00:  remove redundant functions
 rt2x00mac_sta_{add/remove}
Message-ID: <20180727145602.GA5048@redhat.com> (sfid-20180727_170013_758713_C5083C61)
References: <20180727130549.12980-1-yuehaibing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180727130549.12980-1-yuehaibing@huawei.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 27, 2018 at 09:05:49PM +0800, YueHaibing wrote:
> Only rt2800 subdriver of rt2x00 implement sta_add() and sta_remove(),
> rt2x00mac_sta_add and rt2x00mac_sta_remove has no callers after
> commit 9c87758cf089 ("rt2x00: call sta_add/remove directly in rt2800").
> So can be removed.
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Acked-by: Stanislaw Gruszka <sgruszka@redhat.com>
