Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:40819 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932193AbaEEM65 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 May 2014 08:58:57 -0400
Message-ID: <1399294719.22235.10.camel@jlt4.sipsolutions.net> (sfid-20140505_145900_876872_D41FE32C)
Subject: Re: [PATCH 2/5] mwifiex: add firmware dump feature for PCIe
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: Bing Zhao <bzhao@marvell.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Kalle Valo <kvalo@adurom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Maithili Hinge <maithili@marvell.com>,
	Xinming Hu <huxm@marvell.com>
Date: Mon, 05 May 2014 14:58:39 +0200
In-Reply-To: <8738guokvv.fsf@qca.qualcomm.com>
References: <1397760423-11455-1-git-send-email-bzhao@marvell.com>
	 <1397760423-11455-2-git-send-email-bzhao@marvell.com>
	 <87a9bb5c2c.fsf@purkki.adurom.net> <20140425013756.GA3410@tuxdriver.com>
	 <477F20668A386D41ADCC57781B1F70430F70A2AE8E@SC-VEXCH1.marvell.com>
	 <1398413370.4152.0.camel@jlt4.sipsolutions.net>
	 <8738gvp8md.fsf@qca.qualcomm.com>
	 <1398846593.5408.0.camel@jlt4.sipsolutions.net>
	 <8738guokvv.fsf@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-04-30 at 19:13 +0300, Kalle Valo wrote:

> I was thinking that it would be nice to avoid rewriting a separate user
> space dumping tool for each driver and instead have a comman way to
> retrieve the blobs from the driver.

Ours is pretty much just "cat /path/to/some/debugfs/file > wherever",
but indeed it would make sense to have a common uevent and dump
mechanism.

The ethtool dump thing seems reasonable to me, who wants to implement
it? The generic uevent should probably be some cfg80211 API then I
guess?

johannes

