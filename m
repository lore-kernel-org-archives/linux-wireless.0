Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:60215 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754232Ab2ISAZK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Sep 2012 20:25:10 -0400
Date: Wed, 19 Sep 2012 02:25:09 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: lauro.venancio@openbossa.org, aloisio.almeida@openbossa.org,
	yongjun_wei@trendmicro.com.cn, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] NFC: nfcwilink: move the dereference below the NULL
 test
Message-ID: <20120919002509.GD3647@sortiz-mobl> (sfid-20120919_022521_127826_4CB14627)
References: <CAPgLHd_SyyDQBeFGRDfXJFn58sH8FWfHWKRqrBGOyoVbFf3u7Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAPgLHd_SyyDQBeFGRDfXJFn58sH8FWfHWKRqrBGOyoVbFf3u7Q@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Wei,

On Sat, Sep 08, 2012 at 09:53:22AM +0800, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> The dereference should be moved below the NULL test.
> 
> spatch with a semantic match is used to found this.
> (http://coccinelle.lip6.fr/)
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> ---
>  drivers/nfc/nfcwilink.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
Patch applied, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
