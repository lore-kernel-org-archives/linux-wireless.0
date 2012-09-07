Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:30912 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751222Ab2IGQtR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Sep 2012 12:49:17 -0400
Date: Fri, 7 Sep 2012 18:48:58 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: lauro.venancio@openbossa.org, aloisio.almeida@openbossa.org,
	davem@davemloft.net, yongjun_wei@trendmicro.com.cn,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] NFC: remove pointless conditional before kfree_skb()
Message-ID: <20120907164858.GE3647@sortiz-mobl> (sfid-20120907_184921_508128_F1F0CDB4)
References: <CAPgLHd80nD+uYpMMC+sLjcErRcLbGpAVMw7PktrAoxJB8NwHsg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAPgLHd80nD+uYpMMC+sLjcErRcLbGpAVMw7PktrAoxJB8NwHsg@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Wei,

On Tue, Aug 28, 2012 at 09:02:40PM +0800, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Remove pointless conditional before kfree_skb().
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> ---
>  net/nfc/hci/shdlc.c | 3 +--
>  net/nfc/hci/core.c  | 3 +--
>  2 files changed, 2 insertions(+), 4 deletions(-)
Thanks, patch applied to my nfc-next branch.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
