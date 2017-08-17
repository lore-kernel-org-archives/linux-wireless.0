Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:51724 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751752AbdHQHGE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 17 Aug 2017 03:06:04 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/9] qtnfmac: remove unused qtnf_rx_frame declaration
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170815130638.31718-2-sergey.matyukevich.os@quantenna.com>
References: <20170815130638.31718-2-sergey.matyukevich.os@quantenna.com>
To: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Cc: linux-wireless@vger.kernel.org,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Message-Id: <20170817070603.9EE1960274@smtp.codeaurora.org> (sfid-20170817_090607_765240_1233336B)
Date: Thu, 17 Aug 2017 07:06:03 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sergey Matyukevich <sergey.matyukevich.os@quantenna.com> wrote:

> Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>

8 patches applied to wireless-drivers-next.git, thanks.

0db63e37992c qtnfmac: remove unused qtnf_rx_frame declaration
7376947dfb80 qtnfmac: switch to napi_gro_receive
c58730cab8ea qtnfmac: use __netdev_alloc_skb_ip_align
867ba964fa69 qtnfmac: skb2rbd_attach cleanup
dfb13db68f3e qtnfmac: decrease default Tx queue size
3cbc3a0f19ac qtnfmac: switch to kernel circ_buf implementation
cc75f9e5bc66 qtnfmac: introduce counter for Rx underflow events
0593da274d4d qtnfmac: modify tx reclaim locking

-- 
https://patchwork.kernel.org/patch/9901845/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
