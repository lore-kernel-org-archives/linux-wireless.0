Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.sv1.nifty.com ([220.209.183.60]:57671 "EHLO
	defg303.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753441Ab1JaBpL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Oct 2011 21:45:11 -0400
Received: from pbsg500.nifty.com (pbsg500p.nifty.com [172.22.128.70])by defg303.nifty.com with ESMTP id p9V1a9Pp032107
	for <linux-wireless@vger.kernel.org>; Mon, 31 Oct 2011 10:36:09 +0900
Received: from [127.0.0.1] (himob1-p214.iem.hi-ho.ne.jp [203.180.24.214]) (authenticated)
	by pbsg500.nifty.com with ESMTP id p9V1Zc2X003368
	for <linux-wireless@vger.kernel.org>; Mon, 31 Oct 2011 10:35:42 +0900
Date: Mon, 31 Oct 2011 10:35:33 +0900
From: Masahiro Inoue <miyabi.-.inoue@nifty.com>
To: linux-wireless@vger.kernel.org
Subject: Build Error Report
Message-Id: <20111031103531.BCF6.2E210E2F@nifty.com> (sfid-20111031_024524_639393_43E04C59)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

The build error occurs by compat-wireless-2011-10-30.
My kernel is 2.6.27.

  LD      /home/miyabi/test/compat-wireless/compat-wireless-2011-10-30/drivers/net/ethernet/atheros/atl1c/built-in.o
  CC [M]  /home/miyabi/test/compat-wireless/compat-wireless-2011-10-30/drivers/net/ethernet/atheros/atl1c/atl1c_main.o
/home/miyabi/test/compat-wireless/compat-wireless-2011-10-30/drivers/net/ethernet/atheros/atl1c/atl1c_main.c: In function 'atl1c_tx_map':
/home/miyabi/test/compat-wireless/compat-wireless-2011-10-30/drivers/net/ethernet/atheros/atl1c/atl1c_main.c:2199: error: implicit declaration of function 'skb_frag_size'
/home/miyabi/test/compat-wireless/compat-wireless-2011-10-30/drivers/net/ethernet/atheros/atl1c/atl1c_main.c: At top level:
/home/miyabi/test/compat-wireless/compat-wireless-2011-10-30/drivers/net/ethernet/atheros/atl1c/atl1c_main.c:2926: warning: useless storage class specifier in empty declaration
/home/miyabi/test/compat-wireless/compat-wireless-2011-10-30/drivers/net/ethernet/atheros/atl1c/atl1c_main.c:2926: warning: empty declaration
make[4]: *** [/home/miyabi/test/compat-wireless/compat-wireless-2011-10-30/drivers/net/ethernet/atheros/atl1c/atl1c_main.o] Error 1
make[3]: *** [/home/miyabi/test/compat-wireless/compat-wireless-2011-10-30/drivers/net/ethernet/atheros/atl1c] Error 2
make[2]: *** [/home/miyabi/test/compat-wireless/compat-wireless-2011-10-30/drivers/net/ethernet/atheros] Error 2
make[1]: *** [_module_/home/miyabi/test/compat-wireless/compat-wireless-2011-10-30] Error 2
make[1]: Leaving directory `/usr/src/kernels/2.6.27-71vl5-x86_64'
make: *** [modules] Error 2


