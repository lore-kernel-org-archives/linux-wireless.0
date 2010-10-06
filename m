Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:59405 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932089Ab0JFPpH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Oct 2010 11:45:07 -0400
Date: Wed, 6 Oct 2010 11:30:25 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Luciano Coelho <luciano.coelho@nokia.com>
Cc: "ext Gadiyar, Anand" <gadiyar@ti.com>,
	ext Tony Lindgren <tony@atomide.com>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Ohad Ben-Cohen <ohad@wizery.com>
Subject: Re: [PATCH] omap: zoom2/3: fix build caused by wl1271 support
Message-ID: <20101006153025.GG2472@tuxdriver.com>
References: <1285965206-17777-1-git-send-email-gadiyar@ti.com>
 <20101001231026.GH3117@atomide.com>
 <1286279588.15401.28.camel@chilepepper>
 <1286280426.15401.29.camel@chilepepper>
 <1286284790.15401.53.camel@chilepepper>
 <1286311187.2793.7.camel@powerslave>
 <20101006135221.GE2472@tuxdriver.com>
 <AANLkTinHA+JS1MObanawFF8ktW6OEMGr7CnJhakUetPz@mail.gmail.com>
 <1286378869.6731.7.camel@powerslave>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1286378869.6731.7.camel@powerslave>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 06, 2010 at 06:27:49PM +0300, Luciano Coelho wrote:
> On Wed, 2010-10-06 at 16:01 +0200, ext Gadiyar, Anand wrote:
> > >> Hmmm... We got a problem here.  This patch breaks builds when we *don't*
> > >> have "omap: mmc extended to pass host capabilities from board file".  We
> > >> don't have that on wireless-next yet, so builds with zoom boards
> > >> selected are broken.
> > >>
> > >> Any ideas on how to solve this dilemma? I guess the proper way to handle
> > >> this would be to make the changes proposed in this patch when merging
> > >> instead of having a normal commit for it, wouldn't it?
> > >
> > > Just cherry-pick that change into the branch of your tree that I do
> > > _not_ pull from.  I presume that it is already available in linux-next?
> > >
> > 
> > Yup - both patches are in linux-next; that's where we noticed the build break.
> 
> Ok, I hope the patch applies cleanly in our trees.
> 
> John, don't you want to do the cherry-pick on your wireless-testing
> then? If you do it, I can "inherit" that, because I pull from it into my
> "testing" branch (wl12xx/master).  At the moment, w-t is broken too.

OK, that's fine -- do you have the commit ID and the tree that has it?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
