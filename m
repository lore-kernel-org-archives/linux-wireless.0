Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:26689 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751407Ab0JVGFv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Oct 2010 02:05:51 -0400
Received: from vs3006.wh2.ocn.ne.jp (125.206.180.169)
	by mail30g.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 5-0915357547
	for <linux-wireless@vger.kernel.org>; Fri, 22 Oct 2010 15:05:50 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: lrodriguez@atheros.com
Subject: ath5k negative RSSI?
Date: Fri, 22 Oct 2010 15:05:56 +0900
Cc: Nick Kossifidis <mickflemm@gmail.com>, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org, Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201010221505.56666.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello!

I'm looking at the RSSI values provided by the hardware in the RX descriptor 
(rs_rssi) in ath5k. Sometimes the RSSI value is negative (-1, -2, -3) or zero 
(0), which logically does not make sense. madwifi and ath9k work around 
negative values by setting them to zero. Is this a known hardware bug? Or is 
there anything we can do in the driver to get a more reliable RSSI value?

Thanks for any insights,
Bruno
