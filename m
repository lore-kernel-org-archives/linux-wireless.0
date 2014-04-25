Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:54943 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028AbaDYIJ4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Apr 2014 04:09:56 -0400
Message-ID: <1398413370.4152.0.camel@jlt4.sipsolutions.net> (sfid-20140425_101023_657543_6BB6B7C0)
Subject: Re: [PATCH 2/5] mwifiex: add firmware dump feature for PCIe
From: Johannes Berg <johannes@sipsolutions.net>
To: Bing Zhao <bzhao@marvell.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Kalle Valo <kvalo@adurom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Maithili Hinge <maithili@marvell.com>,
	Xinming Hu <huxm@marvell.com>
Date: Fri, 25 Apr 2014 10:09:30 +0200
In-Reply-To: <477F20668A386D41ADCC57781B1F70430F70A2AE8E@SC-VEXCH1.marvell.com> (sfid-20140425_053549_713612_80638BD2)
References: <1397760423-11455-1-git-send-email-bzhao@marvell.com>
	 <1397760423-11455-2-git-send-email-bzhao@marvell.com>
	 <87a9bb5c2c.fsf@purkki.adurom.net> <20140425013756.GA3410@tuxdriver.com>
	 <477F20668A386D41ADCC57781B1F70430F70A2AE8E@SC-VEXCH1.marvell.com>
	 (sfid-20140425_053549_713612_80638BD2)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-04-24 at 20:35 -0700, Bing Zhao wrote:

> Sorry about the hassle. We will find a proper way to implement this.

FWIW, a pretty simple way is to trigger a uevent or so and have a
debugfs file that all the info can be read out from in userspace.

johannes

