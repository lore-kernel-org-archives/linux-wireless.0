Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:5043 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750910AbZG1Hrh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Jul 2009 03:47:37 -0400
Subject: Re: [PATCH 04/14] iwlwifi: Thermal Throttling Management - part 2
From: reinette chatre <reinette.chatre@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>,
	"Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>
In-Reply-To: <1248766429.8113.1.camel@johannes.local>
References: <1248459194-10239-1-git-send-email-reinette.chatre@intel.com>
	 <1248459194-10239-5-git-send-email-reinette.chatre@intel.com>
	 <1248733760.7015.0.camel@johannes.local>
	 <1248734807.1216.619.camel@rc-desk>
	 <1248766429.8113.1.camel@johannes.local>
Content-Type: text/plain
Date: Tue, 28 Jul 2009 00:47:37 -0700
Message-Id: <1248767257.1216.671.camel@rc-desk>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2009-07-28 at 00:33 -0700, Johannes Berg wrote:
> On Mon, 2009-07-27 at 15:46 -0700, reinette chatre wrote:
> 
> > Sorry for missing this. We are trying to be better with documentation
> > and need to do more work in this area. This patch is currently in
> > wireless-testing. I am not sure how to proceed here. If I send a cleanup
> > patch on top of current wireless-testing it will only make sense to
> > address other kernel-doc mishaps. As our driver has not been tested
> > (afaik) to provide meaningful documentation when kernel-doc is used I am
> > hesitant to take on this right now ... but it is something we have to
> > address at some point.
> 
> Yeah, I know it's not used, and I'm sure there's more -- I was just
> looking at the code trying to rebase a patch and this caught my eye.
> It's certainly not too important, but I wanted to point it out anyway if
> only to avoid that in the future :)

Point taken. Thank you very much.

Reinette



