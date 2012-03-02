Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from condef006-v.nifty.com ([210.131.4.243]:33464 "EHLO
	condef006-v.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753229Ab2CBCIU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Mar 2012 21:08:20 -0500
Received: from msag502.nifty.com ([10.22.128.253])by condef006-v.nifty.com with ESMTP id q221wqV4009139
	for <linux-wireless@vger.kernel.org>; Fri, 2 Mar 2012 10:58:52 +0900
Received: from [192.168.3.100] (EM117-55-65-134.emobile.ad.jp [117.55.65.134]) (authenticated)
	by msag502.nifty.com with ESMTP id q221wHVf032130
	for <linux-wireless@vger.kernel.org>; Fri, 2 Mar 2012 10:58:20 +0900
Date: Fri, 02 Mar 2012 10:58:19 +0900
From: Masahiro Inoue <miyabi.-.inoue@nifty.com>
To: linux-wireless@vger.kernel.org
Subject: Build Error Report
Message-Id: <20120302105815.7B30.2E210E2F@nifty.com> (sfid-20120302_030848_342420_4E96B81F)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

The build error occurs by compat-wireless-2012-03-01.
My kernel is 2.6.35.

  CC [M]  /home/miyabi/test/compat-wireless/compat-wireless-2012-03-01/drivers/misc/eeprom/eeprom_93cx6.o
  LD      /home/miyabi/test/compat-wireless/compat-wireless-2012-03-01/drivers/net/ethernet/atheros/built-in.o
  LD      /home/miyabi/test/compat-wireless/compat-wireless-2012-03-01/drivers/net/ethernet/atheros/atl1c/built-in.o
  CC [M]  /home/miyabi/test/compat-wireless/compat-wireless-2012-03-01/drivers/net/ethernet/atheros/atl1c/atl1c_main.o
/home/miyabi/test/compat-wireless/compat-wireless-2012-03-01/drivers/net/ethernet/atheros/atl1c/atl1c_main.c: In function 'atl1c_set_mac_addr':
/home/miyabi/test/compat-wireless/compat-wireless-2012-03-01/drivers/net/ethernet/atheros/atl1c/atl1c_main.c:475: error: 'struct net_device' has no member named 'addr_assign_type'
/home/miyabi/test/compat-wireless/compat-wireless-2012-03-01/drivers/net/ethernet/atheros/atl1c/atl1c_main.c: In function 'atl1c_probe':
/home/miyabi/test/compat-wireless/compat-wireless-2012-03-01/drivers/net/ethernet/atheros/atl1c/atl1c_main.c:2775: error: 'struct net_device' has no member named 'addr_assign_type'
make[5]: *** [/home/miyabi/test/compat-wireless/compat-wireless-2012-03-01/drivers/net/ethernet/atheros/atl1c/atl1c_main.o] Error 1
make[4]: *** [/home/miyabi/test/compat-wireless/compat-wireless-2012-03-01/drivers/net/ethernet/atheros/atl1c] Error 2
make[3]: *** [/home/miyabi/test/compat-wireless/compat-wireless-2012-03-01/drivers/net/ethernet/atheros] Error 2
make[2]: *** [_module_/home/miyabi/test/compat-wireless/compat-wireless-2012-03-01] Error 2
make[2]: Leaving directory `/usr/src/kernels/2.6.35-21vl6-x86_64'
make[1]: *** [modules] Error 2
make[1]: Leaving directory `/home/miyabi/test/compat-wireless/compat-wireless-2012-03-01'
make: *** [.compat_autoconf_compat-wireless-2012-02-28] Error 2

