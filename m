Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ozlabs.org ([103.22.144.67]:57041 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752190AbcGTCZG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jul 2016 22:25:06 -0400
Date: Wed, 20 Jul 2016 12:25:03 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Kalle Valo <kvalo@codeaurora.org>, <linux-wireless@vger.kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
	Eyal Reizer <eyalr@ti.com>
Subject: linux-next: build warning after merge of the wireless-drivers-next
 tree
Message-ID: <20160720122503.09a46d7b@canb.auug.org.au> (sfid-20160720_042529_806674_04CBD436)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

After merging the wireless-drivers-next tree, today's linux-next build
(x86_64 allmodconfig) produced this warning:

drivers/net/wireless/ti/wlcore/spi.c: In function 'wlcore_probe_of':
drivers/net/wireless/ti/wlcore/spi.c:457:6: warning: unused variable 'ret' [-Wunused-variable]
  int ret;
      ^

Introduced by commit

  01efe65aba65 ("wlcore: spi: add wl18xx support")

-- 
Cheers,
Stephen Rothwell
