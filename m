Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:39105 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751204AbcGTGSJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jul 2016 02:18:09 -0400
From: "Reizer, Eyal" <eyalr@ti.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
	Kalle Valo <kvalo@codeaurora.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: linux-next: build warning after merge of the
 wireless-drivers-next tree
Date: Wed, 20 Jul 2016 06:18:00 +0000
Message-ID: <8665E2433BC68541A24DFFCA87B70F5B3616184A@DFRE01.ent.ti.com> (sfid-20160720_081830_587447_0DEABDBC)
References: <20160720122503.09a46d7b@canb.auug.org.au>
In-Reply-To: <20160720122503.09a46d7b@canb.auug.org.au>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Stephen,

> 
> After merging the wireless-drivers-next tree, today's linux-next build
> (x86_64 allmodconfig) produced this warning:
> 
> drivers/net/wireless/ti/wlcore/spi.c: In function 'wlcore_probe_of':
> drivers/net/wireless/ti/wlcore/spi.c:457:6: warning: unused variable 'ret' [-
> Wunused-variable]
>   int ret;
>       ^
> 
> Introduced by commit
> 
>   01efe65aba65 ("wlcore: spi: add wl18xx support")
> 
Of course you are right. It is indeed redundant now.
Don't know how I have missed it. Don't remember seeing a warning from the tool chain I have used.
Anyway ,will submit an amended patch soon.

Best Regards,
Eyal
