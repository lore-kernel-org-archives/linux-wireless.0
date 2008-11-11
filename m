Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:17713 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752308AbYKKDyG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Nov 2008 22:54:06 -0500
Subject: Re: BUG: scheduling while atomic: iwl3945/0/3680/0x00000002 during
	resume from suspend
From: Zhu Yi <yi.zhu@intel.com>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Jiri Slaby <jirislaby@gmail.com>, Michal Hocko <mhocko@suse.cz>,
	LKML <linux-kernel@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>,
	"Chatre, Reinette" <reinette.chatre@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
In-Reply-To: <200811101049.01759.borntraeger@de.ibm.com>
References: <20081109141412.GA5858@dhcp35.suse.cz>
	 <49172112.60508@gmail.com> <1226279540.2604.277.camel@debian.sh.intel.com>
	 <200811101049.01759.borntraeger@de.ibm.com>
Content-Type: text/plain
Date: Tue, 11 Nov 2008 11:54:15 +0800
Message-Id: <1226375655.2604.330.camel@debian.sh.intel.com> (sfid-20081111_045412_093563_6747DABA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-11-10 at 17:49 +0800, Christian Borntraeger wrote:
> Am Montag, 10. November 2008 schrieb Zhu Yi:
> > On Mon, 2008-11-10 at 01:42 +0800, Jiri Slaby wrote:
> > > I think the same as:
> > > http://marc.info/?l=linux-wireless&m=122254514501379&w=2
> > 
> > Yup. Try this fix.
> > 
> http://git.kernel.org/?p=linux/kernel/git/linville/wireless-testing.git;a=commit;h=605b6cd038c5002f8dcbd3695aa934a130257af4
> 
> I got a similar one on
> 03:00.0 Network controller: Intel Corporation PRO/Wireless 4965 AG or AGN 
> [Kedron] Network Connection (rev 61)
> 
> with a pretty decent git: 2.6.28-rc3-00255-g6209344.
> This version contains the fix for iwlwifi, but I still see this bug.

I see. This is a different bug. I'll comment on the previous thread.

Thanks,
-yi

