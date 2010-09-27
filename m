Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:43919 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754244Ab0I0Uof (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Sep 2010 16:44:35 -0400
Date: Mon, 27 Sep 2010 16:41:38 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: greearb@candelatech.com, linux-wireless@vger.kernel.org
Subject: wireless-next-2.6 rebased -- Re: [wireless] wireless:  Keep phy name
 consistent across module reloads.
Message-ID: <20100927204138.GA26075@tuxdriver.com>
References: <1285113431-25526-1-git-send-email-greearb@candelatech.com>
 <1285362170.11036.1.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1285362170.11036.1.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 24, 2010 at 11:02:50PM +0200, Johannes Berg wrote:
> On Tue, 2010-09-21 at 16:57 -0700, greearb@candelatech.com wrote:
> > From: Ben Greear <greearb@candelatech.com>
> > 
> > It adds needless pain to user-space scripts to change the name
> > of the phy on each module reload.  Instead, find the first
> > index.
> 
> Crap, I clearly missed this patch, John, please revert this.

Sure, np...wireless-next-2.6 has been rebased from
9cf13668a5f8165a81349defc5f82c57a4a8279b.

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
