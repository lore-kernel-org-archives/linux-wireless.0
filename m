Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:19779 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750820AbaDYDfn convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Apr 2014 23:35:43 -0400
From: Bing Zhao <bzhao@marvell.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	Kalle Valo <kvalo@adurom.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Maithili Hinge <maithili@marvell.com>,
	Xinming Hu <huxm@marvell.com>
Date: Thu, 24 Apr 2014 20:35:34 -0700
Subject: RE: [PATCH 2/5] mwifiex: add firmware dump feature for PCIe
Message-ID: <477F20668A386D41ADCC57781B1F70430F70A2AE8E@SC-VEXCH1.marvell.com> (sfid-20140425_053549_713612_80638BD2)
References: <1397760423-11455-1-git-send-email-bzhao@marvell.com>
 <1397760423-11455-2-git-send-email-bzhao@marvell.com>
 <87a9bb5c2c.fsf@purkki.adurom.net> <20140425013756.GA3410@tuxdriver.com>
In-Reply-To: <20140425013756.GA3410@tuxdriver.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> > Sorry for commenting so late, I was on holidays and then got lagged
> > behind with email.

Hi Kalle,

Thanks for your comments.

> > Like I said in my previous email, IMHO a wireless driver should not save
> > any files to the filesystem. For example, I don't see any other uses of
> > filp_open() in drivers/net. Ugly hacks like this belong to staging
> > drivers, not to proper upstream drivers.
> 
> I'm sorry for letting this slip through.  I must have had too much rum or something...
> 
> I'm reverting this patch in wireless-next -- drivers should not be
> making filesystem calls like that.  Even if you can argue for doing
> so somehow, where the file would go would be a policy decision that
> should not be encoded in the driver.

Hi John,

Sorry about the hassle. We will find a proper way to implement this.

Thanks,
Bing




