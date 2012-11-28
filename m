Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:21545 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754698Ab2K1NvM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2012 08:51:12 -0500
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <wireless-regdb@lists.infradead.org>,
	<linux-wireless@vger.kernel.org>
Subject: wireless-regdb: How to specify Tx power for Japan
Date: Wed, 28 Nov 2012 15:51:08 +0200
Message-ID: <2274062.Nz7FkqmJnV@lx-vladimir> (sfid-20121128_145116_227430_0D69E5E3)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I have document (WiGig spec for 60g band), where, in the annex with regulatory data,
it specifies power for Japan on per-element basis, not EIRP.

Typical antenna for 60g would have 16 elements.

What should I put in the power rule for wireless-regdb?

Power stated is 10dBm; should I say 10 + 10log16, i.e. about 22dBm ?

Thanks, Vladimir
