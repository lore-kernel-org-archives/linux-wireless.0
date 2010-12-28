Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:51878 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751513Ab0L1HAH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Dec 2010 02:00:07 -0500
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1PXTXQ-0006lQ-Kr
	for linux-wireless@vger.kernel.org; Tue, 28 Dec 2010 08:00:05 +0100
Received: from bas1-woodbridge48-1176129448.dsl.bell.ca ([70.26.79.168])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 28 Dec 2010 08:00:04 +0100
Received: from weedy2887 by bas1-woodbridge48-1176129448.dsl.bell.ca with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 28 Dec 2010 08:00:04 +0100
To: linux-wireless@vger.kernel.org
From: Weedy <weedy2887@gmail.com>
Subject: Compile error for the last week inside rtlwifi/base.c
Date: Tue, 28 Dec 2010 06:58:11 +0000 (UTC)
Message-ID: <loom.20101228T075242-208@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm not sure if my kernel is too old or what but since nothing has changed I'm
going to ask.


  CC [M] 
/media/8G_SDcard/compat-wireless-2010-12-26-pc/drivers/net/wireless/rtlwifi/
base.o
/media/8G_SDcard/compat-wireless-2010-12-26-pc/drivers/net/wireless/rtlwifi/
base.c: In function ‘_rtl_init_deferred_work’:
/media/8G_SDcard/compat-wireless-2010-12-26-pc/drivers/net/wireless/rtlwifi/
base.c:229: error: implicit declaration of function ‘alloc_workqueue’
/media/8G_SDcard/compat-wireless-2010-12-26-pc/drivers/net/wireless/rtlwifi/
base.c:229: warning: assignment makes pointer from integer without a cast
make[4]: *** [/media/8G_SDcard/compat-wireless-2010-12-26-pc/drivers/net/
wireless/rtlwifi/base.o] Error 1
make[3]: *** [/media/8G_SDcard/compat-wireless-2010-12-26-pc/drivers/net/
wireless/rtlwifi] Error 2
make[2]: *** [/media/8G_SDcard/compat-wireless-2010-12-26-pc/drivers/net/
wireless] Error 2
make[1]: *** [_module_/media/8G_SDcard/compat-wireless-2010-12-26-pc] Error 2
make[1]: Leaving directory `/usr/src/linux-headers-2.6.35-24-generic-pae'
make: *** [modules] Error 2


