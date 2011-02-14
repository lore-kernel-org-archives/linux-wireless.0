Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.sv1.nifty.com ([220.209.183.60]:28568 "EHLO
	defg302.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755315Ab1BNBXO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Feb 2011 20:23:14 -0500
Received: from pbsg500.nifty.com (pbsg500p.nifty.com [172.22.128.70])by defg302.nifty.com with ESMTP id p1E1K0Y0011820
	for <linux-wireless@vger.kernel.org>; Mon, 14 Feb 2011 10:20:00 +0900
Received: from [127.0.0.1] (himob2-p36.iem.hi-ho.ne.jp [203.180.25.36]) (authenticated)
	by pbsg500.nifty.com with ESMTP id p1E1JWgh032501
	for <linux-wireless@vger.kernel.org>; Mon, 14 Feb 2011 10:19:34 +0900
Date: Mon, 14 Feb 2011 10:19:27 +0900
From: Masahiro Inoue <miyabi.-.inoue@nifty.com>
To: linux-wireless@vger.kernel.org
Subject: Build Error Report(zd1211rw)
Message-Id: <20110214101925.9EC3.2E210E2F@nifty.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

The build error occurs by compat-wireless-2011-02-12.
My kernel is 2.6.27. 

  CC [M]  /home/miyabi/test/compat-wireless/compat-wireless-2011-02-12/drivers/net/wireless/zd1211rw/zd_mac.o
/home/miyabi/test/compat-wireless/compat-wireless-2011-02-12/drivers/net/wireless/zd1211rw/zd_mac.c: In function 'zd_mac_config_beacon':
/home/miyabi/test/compat-wireless/compat-wireless-2011-02-12/drivers/net/wireless/zd1211rw/zd_mac.c:781: error: implicit declaration of function 'usb_queue_reset_device'
make[4]: *** [/home/miyabi/test/compat-wireless/compat-wireless-2011-02-12/drivers/net/wireless/zd1211rw/zd_mac.o] Error 1
make[3]: *** [/home/miyabi/test/compat-wireless/compat-wireless-2011-02-12/drivers/net/wireless/zd1211rw] Error 2
make[2]: *** [/home/miyabi/test/compat-wireless/compat-wireless-2011-02-12/drivers/net/wireless] Error 2
make[1]: *** [_module_/home/miyabi/test/compat-wireless/compat-wireless-2011-02-12] Error 2
make[1]: Leaving directory `/usr/src/kernels/2.6.27-67vl5-x86_64'
make: *** [modules] Error 2


