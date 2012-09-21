Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:51395 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754701Ab2IUQlK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Sep 2012 12:41:10 -0400
From: Sujith Manoharan <c_manoha@qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20572.39015.872732.569065@gargle.gargle.HOWL> (sfid-20120921_184115_293862_3A9EEA91)
Date: Fri, 21 Sep 2012 22:10:07 +0530
To: Ben Greear <greearb@candelatech.com>
CC: Sujith Manoharan <c_manoha@qualcomm.com>, <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/2] ath9k: Add a debugfs file to adjust antenna diversity
In-Reply-To: <505C7984.1090600@candelatech.com>
References: <20572.4308.801973.961874@gargle.gargle.HOWL>
	<505C7984.1090600@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ben Greear wrote:
> Can you document what the various settings mean?

1 = Enable, 0 = Disable. :)

> Also, what is the difference between antenna diversity
> and selecting the tx/rx chainmask?

Diversity is used to select which antenna to receive on based on RSSI.
(See antenna.c)

Sujith
