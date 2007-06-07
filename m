Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:59146 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1763962AbXFGWkL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jun 2007 18:40:11 -0400
Date: Fri, 8 Jun 2007 00:40:09 +0200
From: Jiri Benc <jbenc@suse.cz>
To: jketreno <jketreno@linux.intel.com>
Cc: Michael Wu <flamingice@sourmilk.net>,
	"John W. Linville" <linville@tuxdriver.com>, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org
Subject: Re: IEEE802.11e/WMM TS management and DLS support
Message-ID: <20070608004009.46c3d6ea@logostar.upir.cz>
In-Reply-To: <4668DE0F.7060302@linux.intel.com>
References: <20070606082152.GA28639@mail.intel.com>
	<20070607224315.6dadffca@griffin.suse.cz>
	<4668D293.1010908@linux.intel.com>
	<200706071412.54918.flamingice@sourmilk.net>
	<4668DE0F.7060302@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 07 Jun 2007 21:41:51 -0700, jketreno wrote:
> In addition to the updated patches against wireless-dev incorporating 
> feedback, John asked Yi to provide the WME patches against Linus' tree.  
> He did..
> 
> Now, a month after Yi's patches were originally sent out, Jiri cited things 
> he doesn't like

I apologize it took me so long. On the other hand, I wrote at least some of
the comments when the patches were sent out first time many months ago and
they still haven't been addressed.

> --things which can be addressed through patches to the code 
> vs. having to re-apply a monolithic patch.

That could work if there are just minor issues in the code. That's not this
case, the patches have still major ones.

> Nothing is perfect the first time--and nothing will ever get done so long
> as an aggressive and offensive position is held in regard to outside
> contribution.

I hope I wasn't aggressive. If it sounded that way, I apologize, I didn't
mean to. Be assured that nobody is trying to offense "outside
contributions" (there is nothing like that, btw, everyone can contribute
and is considered the same), the only merit is a quality of code.

Let's work on fixing those patches and when they are ready I will be more
than happy to let them be applied - everybody will profit from them.

Unfortunately, I won't have a time to look deeply into the second patch
until a beginning of next week. (But you can use that time for fixing the
third patch ;-))

Thanks,

 Jiri

-- 
Jiri Benc
SUSE Labs
