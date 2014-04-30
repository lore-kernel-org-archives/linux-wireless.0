Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:49441 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751802AbaD3HlT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Apr 2014 03:41:19 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Bing Zhao <bzhao@marvell.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Kalle Valo <kvalo@adurom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Maithili Hinge <maithili@marvell.com>,
	Xinming Hu <huxm@marvell.com>
Subject: Re: [PATCH 2/5] mwifiex: add firmware dump feature for PCIe
In-Reply-To: <1398413370.4152.0.camel@jlt4.sipsolutions.net> (Johannes Berg's
	message of "Fri, 25 Apr 2014 10:09:30 +0200")
References: <1397760423-11455-1-git-send-email-bzhao@marvell.com>
	<1397760423-11455-2-git-send-email-bzhao@marvell.com>
	<87a9bb5c2c.fsf@purkki.adurom.net>
	<20140425013756.GA3410@tuxdriver.com>
	<477F20668A386D41ADCC57781B1F70430F70A2AE8E@SC-VEXCH1.marvell.com>
	<1398413370.4152.0.camel@jlt4.sipsolutions.net>
Date: Wed, 30 Apr 2014 10:41:14 +0300
Message-ID: <8738gvp8md.fsf@qca.qualcomm.com> (sfid-20140430_094122_968527_2C8E2CC0)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Thu, 2014-04-24 at 20:35 -0700, Bing Zhao wrote:
>
>> Sorry about the hassle. We will find a proper way to implement this.
>
> FWIW, a pretty simple way is to trigger a uevent or so and have a
> debugfs file that all the info can be read out from in userspace.

I think we need a similar feature in ath10k as well. Should we have a
generic interface this, would that make any sense?

-- 
Kalle Valo
