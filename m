Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:41446 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932465Ab0JFPzp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Oct 2010 11:55:45 -0400
Subject: Re: [PATCH] omap: zoom2/3: fix build caused by wl1271 support
From: Luciano Coelho <luciano.coelho@nokia.com>
To: "ext John W. Linville" <linville@tuxdriver.com>
Cc: "ext Gadiyar, Anand" <gadiyar@ti.com>,
	ext Tony Lindgren <tony@atomide.com>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Ohad Ben-Cohen <ohad@wizery.com>
In-Reply-To: <20101006153025.GG2472@tuxdriver.com>
References: <1285965206-17777-1-git-send-email-gadiyar@ti.com>
	 <20101001231026.GH3117@atomide.com> <1286279588.15401.28.camel@chilepepper>
	 <1286280426.15401.29.camel@chilepepper>
	 <1286284790.15401.53.camel@chilepepper>
	 <1286311187.2793.7.camel@powerslave> <20101006135221.GE2472@tuxdriver.com>
	 <AANLkTinHA+JS1MObanawFF8ktW6OEMGr7CnJhakUetPz@mail.gmail.com>
	 <1286378869.6731.7.camel@powerslave>  <20101006153025.GG2472@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 06 Oct 2010 18:55:18 +0300
Message-ID: <1286380518.6731.10.camel@powerslave>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-10-06 at 17:30 +0200, ext John W. Linville wrote:
> On Wed, Oct 06, 2010 at 06:27:49PM +0300, Luciano Coelho wrote:
> > On Wed, 2010-10-06 at 16:01 +0200, ext Gadiyar, Anand wrote:
> > > >> Hmmm... We got a problem here.  This patch breaks builds when we *don't*
> > > >> have "omap: mmc extended to pass host capabilities from board file".  We
> > > >> don't have that on wireless-next yet, so builds with zoom boards
> > > >> selected are broken.
> > > >>
> > > >> Any ideas on how to solve this dilemma? I guess the proper way to handle
> > > >> this would be to make the changes proposed in this patch when merging
> > > >> instead of having a normal commit for it, wouldn't it?
> > > >
> > > > Just cherry-pick that change into the branch of your tree that I do
> > > > _not_ pull from.  I presume that it is already available in linux-next?
> > > >
> > > 
> > > Yup - both patches are in linux-next; that's where we noticed the build break.
> > 
> > Ok, I hope the patch applies cleanly in our trees.
> > 
> > John, don't you want to do the cherry-pick on your wireless-testing
> > then? If you do it, I can "inherit" that, because I pull from it into my
> > "testing" branch (wl12xx/master).  At the moment, w-t is broken too.
> 
> OK, that's fine -- do you have the commit ID and the tree that has it?

Stephen's linux-net, commit 3a63833ec3002816a759a49ebda4e229c089114e.

http://git.kernel.org/?p=linux/kernel/git/next/linux-next.git;a=commit;h=3a63833ec3002816a759a49ebda4e229c089114e

-- 
Cheers,
Luca.

