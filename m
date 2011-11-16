Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pbsg501.nifty.com ([202.248.238.71]:35973 "EHLO
	pbsg501.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932834Ab1KPBmz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Nov 2011 20:42:55 -0500
Received: from [127.0.0.1] (himob2-p64.iem.hi-ho.ne.jp [203.180.25.64]) (authenticated)
	by pbsg501.nifty.com with ESMTP id pAG1gcbR005629
	for <linux-wireless@vger.kernel.org>; Wed, 16 Nov 2011 10:42:44 +0900
Date: Wed, 16 Nov 2011 10:41:36 +0900
From: Masahiro Inoue <miyabi.-.inoue@nifty.com>
To: linux-wireless@vger.kernel.org
Subject: Build Error Report
Message-Id: <20111116104133.E58B.2E210E2F@nifty.com> (sfid-20111116_024259_178078_3D2C3F99)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

The build error occurs by compat-wireless-2011-11-10.
My kernel is 2.6.27.

  CC [M]  /home/miyabi/test/compat-wireless/compat-wireless-2011-11-15/drivers/net/wireless/iwlwifi/iwl-agn-calib.o
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-15/drivers/net/wireless/iwlwifi/iwl-agn-calib.c: In function 'iwlagn_gain_computation':
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-15/drivers/net/wireless/iwlwifi/iwl-agn-calib.c:891: warning: comparison of distinct pointer types lacks a cast
  CC [M]  /home/miyabi/test/compat-wireless/compat-wireless-2011-11-15/drivers/net/wireless/iwlwifi/iwl-io.o
  CC [M]  /home/miyabi/test/compat-wireless/compat-wireless-2011-11-15/drivers/net/wireless/iwlwifi/iwl-agn-tt.o
  CC [M]  /home/miyabi/test/compat-wireless/compat-wireless-2011-11-15/drivers/net/wireless/iwlwifi/iwl-agn-sta.o
  CC [M]  /home/miyabi/test/compat-wireless/compat-wireless-2011-11-15/drivers/net/wireless/iwlwifi/iwl-agn-rx.o
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-15/drivers/net/wireless/iwlwifi/iwl-agn-rx.c: In function 'iwlagn_rx_noa_notification':
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-15/drivers/net/wireless/iwlwifi/iwl-agn-rx.c:1075: error: implicit declaration of function 'kfree_rcu'
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-15/drivers/net/wireless/iwlwifi/iwl-agn-rx.c:1075: error: 'rcu_head' undeclared (first use in this function)
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-15/drivers/net/wireless/iwlwifi/iwl-agn-rx.c:1075: error: (Each undeclared identifier is reported only once
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-15/drivers/net/wireless/iwlwifi/iwl-agn-rx.c:1075: error: for each function it appears in.)
make[4]: *** [/home/miyabi/test/compat-wireless/compat-wireless-2011-11-15/drivers/net/wireless/iwlwifi/iwl-agn-rx.o] Error 1
make[3]: *** [/home/miyabi/test/compat-wireless/compat-wireless-2011-11-15/drivers/net/wireless/iwlwifi] Error 2
make[2]: *** [/home/miyabi/test/compat-wireless/compat-wireless-2011-11-15/drivers/net/wireless] Error 2
make[1]: *** [_module_/home/miyabi/test/compat-wireless/compat-wireless-2011-11-15] Error 2
make[1]: Leaving directory `/usr/src/kernels/2.6.27-74vl5-x86_64'
make: *** [modules] Error 2


