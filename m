Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:42210 "EHLO ds10.mine.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751367AbZA3Cpu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Jan 2009 21:45:50 -0500
Message-ID: <498269D5.7080204@openwrt.org> (sfid-20090130_034634_182198_C84B05EF)
Date: Fri, 30 Jan 2009 03:45:41 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
CC: Nick Kossifidis <mickflemm@gmail.com>,
	Bob Copeland <me@bobcopeland.com>
Subject: [PATCH,RFC 0/2] ath5k: implement tx power calibration on ar2413/5413
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I got my AR2413 patches to the point where ath5k properly
initializes the PDGAIN curves (register dumps verified against
what the madwifi HAL does), and it does Tx at much better
power level and with 54 Mbit (tested on an AR5413 card).
Power still isn't as good as on madwifi yet, but much closer
than before, and I actually get >20Mbit/s throughput now.

Enjoy!

- Felix
