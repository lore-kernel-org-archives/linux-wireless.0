Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:37157 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422649AbaD3NaR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Apr 2014 09:30:17 -0400
Date: Wed, 30 Apr 2014 09:22:47 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>, Bing Zhao <bzhao@marvell.com>,
	Kalle Valo <kvalo@adurom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Maithili Hinge <maithili@marvell.com>,
	Xinming Hu <huxm@marvell.com>
Subject: Re: [PATCH 2/5] mwifiex: add firmware dump feature for PCIe
Message-ID: <20140430132246.GB3635@tuxdriver.com> (sfid-20140430_153022_409639_40F4E85E)
References: <1397760423-11455-1-git-send-email-bzhao@marvell.com>
 <1397760423-11455-2-git-send-email-bzhao@marvell.com>
 <87a9bb5c2c.fsf@purkki.adurom.net>
 <20140425013756.GA3410@tuxdriver.com>
 <477F20668A386D41ADCC57781B1F70430F70A2AE8E@SC-VEXCH1.marvell.com>
 <1398413370.4152.0.camel@jlt4.sipsolutions.net>
 <8738gvp8md.fsf@qca.qualcomm.com>
 <1398846593.5408.0.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1398846593.5408.0.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 30, 2014 at 10:29:53AM +0200, Johannes Berg wrote:
> On Wed, 2014-04-30 at 10:41 +0300, Kalle Valo wrote:
> > Johannes Berg <johannes@sipsolutions.net> writes:
> > 
> > > On Thu, 2014-04-24 at 20:35 -0700, Bing Zhao wrote:
> > >
> > >> Sorry about the hassle. We will find a proper way to implement this.
> > >
> > > FWIW, a pretty simple way is to trigger a uevent or so and have a
> > > debugfs file that all the info can be read out from in userspace.
> > 
> > I think we need a similar feature in ath10k as well. Should we have a
> > generic interface this, would that make any sense?
> 
> We have it in iwlwifi as well - we were considering a generic uevent but
> beyond that I don't think there's much that could be done?

There is an ethtool op for that, no?

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
