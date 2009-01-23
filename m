Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:45760 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752611AbZAWUPr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2009 15:15:47 -0500
Date: Fri, 23 Jan 2009 15:01:20 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Tomas Winkler <tomasw@gmail.com>
Cc: reinette chatre <reinette.chatre@intel.com>,
	"Abbas, Mohamed" <mohamed.abbas@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>
Subject: Re: [ipw3945-devel] [PATCH 2/2 v2.6.29] iwlagn: fix agn rate
	scaling
Message-ID: <20090123200120.GE30486@tuxdriver.com> (sfid-20090123_211552_833029_3ACDCC76)
References: <1232564283-18008-1-git-send-email-reinette.chatre@intel.com> <1232564283-18008-2-git-send-email-reinette.chatre@intel.com> <1232564283-18008-3-git-send-email-reinette.chatre@intel.com> <20090123190138.GC30486@tuxdriver.com> <1232738937.24871.6.camel@rc-desk> <1ba2fa240901231155q79607779t1b91880b98db0839@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1ba2fa240901231155q79607779t1b91880b98db0839@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 23, 2009 at 09:55:34PM +0200, Tomas Winkler wrote:
> On Fri, Jan 23, 2009 at 9:28 PM, reinette chatre
> <reinette.chatre@intel.com> wrote:
> > On Fri, 2009-01-23 at 11:01 -0800, John W. Linville wrote:
> >> On Wed, Jan 21, 2009 at 10:58:03AM -0800, Reinette Chatre wrote:
> >> > From: Abbas, Mohamed <mohamed.abbas@intel.com>
> >> >
> >> > Sometime Tx reply rate different than what rate scale expecting
> >> > causing rate scale to bail out. This could cause failing to
> >> > commit LQ cmd. This patch will try to solve this instead of just
> >> > bail out. It also make sure we start with a valid rate.
> >> >
> >> > Signed-off-by: mohamed abbas <mohamed.abbas@intel.com>
> >> > Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
> >>
> >> While I'm sure this would be nice to fix, I don't see the regression,
> >> Oops or crash?
> >
> > You are right - this does not fix an oops or a crash. Having this patch
> > in 2.6.29 is thus not critical.
> 
> What is funny that we have to wait till  2.6.30 is open to get it to
> stable of 2.6.27 and 28.

Not my rule -- ask Greg for special dispensation?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
