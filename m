Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:43719 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754116AbZG0Wqr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jul 2009 18:46:47 -0400
Subject: Re: [PATCH 04/14] iwlwifi: Thermal Throttling Management - part 2
From: reinette chatre <reinette.chatre@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>,
	"Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>
In-Reply-To: <1248733760.7015.0.camel@johannes.local>
References: <1248459194-10239-1-git-send-email-reinette.chatre@intel.com>
	 <1248459194-10239-5-git-send-email-reinette.chatre@intel.com>
	 <1248733760.7015.0.camel@johannes.local>
Content-Type: text/plain
Date: Mon, 27 Jul 2009 15:46:47 -0700
Message-Id: <1248734807.1216.619.camel@rc-desk>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

On Mon, 2009-07-27 at 15:29 -0700, Johannes Berg wrote:
> On Fri, 2009-07-24 at 11:13 -0700, Reinette Chatre wrote:
> 
> >  /**
> > + * struct iwl_tt_restriction - Thermal Throttling restriction table used
> > + *		by advance thermal throttling management
> > + *		based on the current thermal throttling state, determine
> > + *		number of tx/rx streams; and the status of HT operation
> > + * @tx_stream: number of tx stream allowed
> > + * @is_ht: ht enable/disable
> > + * @rx_stream: number of rx stream allowed
> > + */
> 
> This kernel-doc, and some others, are really botched btw -- the bit
> after 'struct foo - ' really needs to be a single line only, you can put
> longer descriptions after the parameters.

Sorry for missing this. We are trying to be better with documentation
and need to do more work in this area. This patch is currently in
wireless-testing. I am not sure how to proceed here. If I send a cleanup
patch on top of current wireless-testing it will only make sense to
address other kernel-doc mishaps. As our driver has not been tested
(afaik) to provide meaningful documentation when kernel-doc is used I am
hesitant to take on this right now ... but it is something we have to
address at some point.

Reinette


