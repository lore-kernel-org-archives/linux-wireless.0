Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:20532 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934128Ab2C3L1f (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Mar 2012 07:27:35 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20341.39041.645223.592030@gargle.gargle.HOWL> (sfid-20120330_132739_197319_482ABC81)
Date: Fri, 30 Mar 2012 16:56:57 +0530
To: Johannes Berg <johannes@sipsolutions.net>
CC: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	Hauke Mehrtens <hauke@hauke-m.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH 0/2] compat: fix extreme build slowdowns
In-Reply-To: <1333105815.3908.11.camel@jlt3.sipsolutions.net>
References: <1333105815.3908.11.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> Somehow exporting too many variables completely confuses the kernel's
> Makefiles into trying to calculate the size of every file in a very slow
> shell script ... this is causing EXTREME build slowdowns for me.
> 
> These two patches fix it.

Nice.

Trying to build ath9k..

Before:

real    1m18.689s
user    3m1.382s
sys     0m6.833s

After:

real    0m42.091s
user    1m30.024s
sys     0m5.700s

Sujith
