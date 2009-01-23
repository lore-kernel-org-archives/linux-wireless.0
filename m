Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:21475 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753589AbZAWT0V (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2009 14:26:21 -0500
Subject: Re: [PATCH 2/2 v2.6.29] iwlagn: fix agn rate scaling
From: reinette chatre <reinette.chatre@intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>,
	"Abbas, Mohamed" <mohamed.abbas@intel.com>
In-Reply-To: <20090123190138.GC30486@tuxdriver.com>
References: <1232564283-18008-1-git-send-email-reinette.chatre@intel.com>
	 <1232564283-18008-2-git-send-email-reinette.chatre@intel.com>
	 <1232564283-18008-3-git-send-email-reinette.chatre@intel.com>
	 <20090123190138.GC30486@tuxdriver.com>
Content-Type: text/plain
Date: Fri, 23 Jan 2009 11:28:57 -0800
Message-Id: <1232738937.24871.6.camel@rc-desk> (sfid-20090123_202644_754119_948819B0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2009-01-23 at 11:01 -0800, John W. Linville wrote:
> On Wed, Jan 21, 2009 at 10:58:03AM -0800, Reinette Chatre wrote:
> > From: Abbas, Mohamed <mohamed.abbas@intel.com>
> >
> > Sometime Tx reply rate different than what rate scale expecting
> > causing rate scale to bail out. This could cause failing to
> > commit LQ cmd. This patch will try to solve this instead of just
> > bail out. It also make sure we start with a valid rate.
> >
> > Signed-off-by: mohamed abbas <mohamed.abbas@intel.com>
> > Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
> 
> While I'm sure this would be nice to fix, I don't see the regression,
> Oops or crash?

You are right - this does not fix an oops or a crash. Having this patch
in 2.6.29 is thus not critical.

Reinette

