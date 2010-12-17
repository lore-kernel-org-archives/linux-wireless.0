Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:49735 "HELO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754413Ab0LQTYD convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Dec 2010 14:24:03 -0500
From: Bing Zhao <bzhao@marvell.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Frank Huang <frankh@marvell.com>
Date: Fri, 17 Dec 2010 11:23:48 -0800
Subject: RE: [PATCH] mwifiex: use debugfs_remove_recursive()
Message-ID: <477F20668A386D41ADCC57781B1F704307F4C231D1@SC-VEXCH1.marvell.com>
References: <1292558206-29423-1-git-send-email-bzhao@marvell.com>
 <20101217142653.GC2398@tuxdriver.com>
In-Reply-To: <20101217142653.GC2398@tuxdriver.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

> -----Original Message-----
> From: John W. Linville [mailto:linville@tuxdriver.com]
> Sent: Friday, December 17, 2010 6:27 AM
> To: Bing Zhao
> Cc: linux-wireless@vger.kernel.org; Johannes Berg; Amitkumar Karwar; Kiran Divekar; Frank Huang
> Subject: Re: [PATCH] mwifiex: use debugfs_remove_recursive()
> 
> On Thu, Dec 16, 2010 at 07:56:46PM -0800, Bing Zhao wrote:
> > From: Amitkumar Karwar <akarwar@marvell.com>
> >
> > instead of keeping pointers to all entries.
> >
> > Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> > Signed-off-by: Kiran Divekar <dkiran@marvell.com>
> 
> Just for the record, I'm not tracking any of the mwifiex patches at
> this time.  Are you pushing them to a public git tree?

I have pushed all mwifiex patches to Marvell public git tree:

git://git.marvell.com/mwifiex.git
http://git.marvell.com/?p=mwifiex.git;a=summary

I will let you know as soon as we finish all open items commented by you, Johannes and other reviewers.

Thanks,

Bing

> 
> John
> --
> John W. Linville		Someday the world will need a hero, and you
> linville@tuxdriver.com			might be all we have.  Be ready.
