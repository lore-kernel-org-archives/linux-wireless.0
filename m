Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:59321 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750767Ab3FVE42 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Jun 2013 00:56:28 -0400
Received: from mailout-de.gmx.net ([10.1.76.34]) by mrigmx.server.lan
 (mrigmx002) with ESMTP (Nemesis) id 0M1kdo-1U2P6f17mM-00tky9 for
 <linux-wireless@vger.kernel.org>; Sat, 22 Jun 2013 06:56:27 +0200
Message-ID: <51C52E79.30104@rempel-privat.de> (sfid-20130622_065641_930269_3FE280AA)
Date: Sat, 22 Jun 2013 06:56:25 +0200
From: Oleksij Rempel <linux@rempel-privat.de>
MIME-Version: 1.0
To: "ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Javier Cardona <javier@cozybit.com>
Subject: regression after, " ath9k_htc: Add support for mesh interfaces"
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Javier,

i warning after patch "ath9k_htc: Add support for mesh interfaces".
I get this warning only on pc with CONFIG_MAC80211_MESH not set. 
Probably you missed config check some where.

commit 594e65b633e0b76db1d8e7359e4efb2d60fba20d
Author: Javier Cardona <javier@cozybit.com>
Date:   Wed May 8 10:16:46 2013 -0700

     ath9k_htc: Add support for mesh interfaces

     More specifically, enable AP-style beaconing on mesh
     ifaces and change the hw capabilities to reflect mesh
     support.

     Coexistence with a virtual STA interface was tested as
     working fine.

     Signed-off-by: Javier Cardona <javier@cozybit.com>
     [rebase, add iface combinations]
     Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
     Signed-off-by: John W. Linville <linville@tuxdriver.com>
-- 
Regards,
Oleksij
