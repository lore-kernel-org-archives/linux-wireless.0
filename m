Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:16284 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755929Ab2ISA0j (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Sep 2012 20:26:39 -0400
Date: Wed, 19 Sep 2012 02:26:31 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: lauro.venancio@openbossa.org, aloisio.almeida@openbossa.org,
	yongjun_wei@trendmicro.com.cn, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v3] NFC: pn544_hci: move the dereference below the NULL
 test
Message-ID: <20120919002631.GF3647@sortiz-mobl> (sfid-20120919_022642_539910_C4AB3A2B)
References: <CAPgLHd97e_ZyJFwSbCyCYMy4jwVVib5x4=A9UbTXuw+AiyJ3jA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAPgLHd97e_ZyJFwSbCyCYMy4jwVVib5x4=A9UbTXuw+AiyJ3jA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Wei,

On Sat, Sep 08, 2012 at 09:19:44PM +0800, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> The dereference should be moved below the NULL test.
> 
> spatch with a semantic match is used to found this.
> (http://coccinelle.lip6.fr/)
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> ---
>  drivers/nfc/pn544_hci.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
Applied as well, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
