Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:43854 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751222Ab3GXSuB convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Jul 2013 14:50:01 -0400
From: Bing Zhao <bzhao@marvell.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>
Date: Wed, 24 Jul 2013 11:48:25 -0700
Subject: RE: [PATCH 18/21] mwifiex: handle driver initialization error paths
Message-ID: <477F20668A386D41ADCC57781B1F70430EA311794C@SC-VEXCH1.marvell.com> (sfid-20130724_205006_550360_86869924)
References: <1374545878-15683-1-git-send-email-bzhao@marvell.com>
 <1374545878-15683-19-git-send-email-bzhao@marvell.com>
 <20130724151651.GD2385@tuxdriver.com>
In-Reply-To: <20130724151651.GD2385@tuxdriver.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

> This one didn't apply on the current wireless-next tree.  Can you
> fix it up?

18/21 and 19/21 depend on this patch:

commit 232fde062e0a2cc52e8e18a50cda361b4ba88f34
Author: Daniel Drake <dsd@laptop.org>
Date:   Sat Jul 13 10:57:10 2013 -0400

    mwifiex: fix IRQ enable/disable

which is in wireless.git and wireless-testing.git currently.


We can apply 18 and 19 later after commit 232fde0 is merged back to wireless-next.git.
(I will send you a reminder to merge these two patches once commit 232fde0 is in -next tree.)

Thanks,
Bing

