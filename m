Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:53204 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754527Ab1JRGUH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Oct 2011 02:20:07 -0400
Date: Tue, 18 Oct 2011 09:19:50 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Bing Zhao <bzhao@marvell.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch 4/4] mwifiex: return -ENOMEM if kzalloc() fails
Message-ID: <20111018061950.GJ27732@elgon.mountain> (sfid-20111018_082015_017467_80BF879F)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sorry, I've decided to hold this one back.  It was written in a lazy
way and only fixed the return codes that Smatch complained about.
I'll redo it and send it later.

regards,
dan carpenter
