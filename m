Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from defg500.nifty.com ([202.248.238.127]:41273 "EHLO
	defg500.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753343Ab1KKE4N (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Nov 2011 23:56:13 -0500
Received: from pbsg501.nifty.com (pbsg501p.nifty.com [172.22.128.71])by defg500.nifty.com with ESMTP id pAB4pIwZ000426
	for <linux-wireless@vger.kernel.org>; Fri, 11 Nov 2011 13:51:18 +0900
Received: from [127.0.0.1] (himob2-p192.iem.hi-ho.ne.jp [203.180.25.192]) (authenticated)
	by pbsg501.nifty.com with ESMTP id pAB4olPY026602
	for <linux-wireless@vger.kernel.org>; Fri, 11 Nov 2011 13:50:52 +0900
Date: Fri, 11 Nov 2011 13:49:53 +0900
From: Masahiro Inoue <miyabi.-.inoue@nifty.com>
To: linux-wireless@vger.kernel.org
Subject: Build Error Report
Message-Id: <20111111134952.D36A.2E210E2F@nifty.com> (sfid-20111111_055617_848052_C195082C)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

The build error occurs by compat-wireless-2011-11-10.
My kernel is 2.6.27.

  CC [M]  /home/miyabi/test/compat-wireless/compat-wireless-2011-11-10/net/mac80211/status.o
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-10/net/mac80211/status.c: In function 'ieee80211_tx_status':
/home/miyabi/test/compat-wireless/compat-wireless-2011-11-10/net/mac80211/status.c:566: error: implicit declaration of function 'skb_complete_wifi_ack'
make[3]: *** [/home/miyabi/test/compat-wireless/compat-wireless-2011-11-10/net/mac80211/status.o] Error 1
make[2]: *** [/home/miyabi/test/compat-wireless/compat-wireless-2011-11-10/net/mac80211] Error 2
make[1]: *** [_module_/home/miyabi/test/compat-wireless/compat-wireless-2011-11-10] Error 2
make[1]: Leaving directory `/usr/src/kernels/2.6.27-71vl5-x86_64'
make: *** [modules] Error 2


