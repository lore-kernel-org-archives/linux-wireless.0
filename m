Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:8295 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750999AbbAWFLY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2015 00:11:24 -0500
Message-ID: <1422009676.29681.3.camel@pe-lt950> (sfid-20150123_061127_438575_45CA21CF)
Subject: Re: [PATCH 3/3] mwifiex: selectively choose ext_scan support
From: Avinash Patil <patila@marvell.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Cathy Luo <cluo@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>
Date: Fri, 23 Jan 2015 16:11:16 +0530
In-Reply-To: <1421858191.1900.18.camel@sipsolutions.net>
References: <1421858531-4536-1-git-send-email-patila@marvell.com>
	 <1421858531-4536-3-git-send-email-patila@marvell.com>
	 (sfid-20150121_121353_128877_AC22EEF3) <1421858158.1900.17.camel@sipsolutions.net>
	 (sfid-20150121_173606_460838_ECEC5A69) <1421858191.1900.18.camel@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-01-21 at 08:36 -0800, Johannes Berg wrote:
> On Wed, 2015-01-21 at 17:35 +0100, Johannes Berg wrote:
> > On Wed, 2015-01-21 at 22:12 +0530, Avinash Patil wrote:
> > 
> > > +	u8 ext_scan_support;
> > 
> > bool.
> 
> Oh, there are also two more places it seems :)
> 
> johannes
> 
Hmm..:)
I will send another follow-up patch to fix this later.

Thanks,
Avinash

