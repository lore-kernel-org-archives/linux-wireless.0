Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:47881 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758176AbaD3IaE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Apr 2014 04:30:04 -0400
Message-ID: <1398846593.5408.0.camel@jlt4.sipsolutions.net> (sfid-20140430_103010_738964_FC14DAA2)
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
Date: Wed, 30 Apr 2014 10:29:53 +0200
In-Reply-To: <8738gvp8md.fsf@qca.qualcomm.com>
References: <1397760423-11455-1-git-send-email-bzhao@marvell.com>
	 <1397760423-11455-2-git-send-email-bzhao@marvell.com>
	 <87a9bb5c2c.fsf@purkki.adurom.net> <20140425013756.GA3410@tuxdriver.com>
	 <477F20668A386D41ADCC57781B1F70430F70A2AE8E@SC-VEXCH1.marvell.com>
	 <1398413370.4152.0.camel@jlt4.sipsolutions.net>
	 <8738gvp8md.fsf@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-04-30 at 10:41 +0300, Kalle Valo wrote:
> Johannes Berg <johannes@sipsolutions.net> writes:
> 
> > On Thu, 2014-04-24 at 20:35 -0700, Bing Zhao wrote:
> >
> >> Sorry about the hassle. We will find a proper way to implement this.
> >
> > FWIW, a pretty simple way is to trigger a uevent or so and have a
> > debugfs file that all the info can be read out from in userspace.
> 
> I think we need a similar feature in ath10k as well. Should we have a
> generic interface this, would that make any sense?

We have it in iwlwifi as well - we were considering a generic uevent but
beyond that I don't think there's much that could be done?

johannes

