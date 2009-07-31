Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:18243 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751506AbZGaTpQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jul 2009 15:45:16 -0400
Subject: Re: [PATCH] iwlwifi: don't export symbols not needed in other
 modules
From: reinette chatre <reinette.chatre@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1248982009.23496.5.camel@johannes.local>
References: <1248947897.8925.13.camel@johannes.local>
	 <1248978482.1216.1087.camel@rc-desk>
	 <1248979011.23496.4.camel@johannes.local>
	 <1248979665.1216.1094.camel@rc-desk>
	 <1248982009.23496.5.camel@johannes.local>
Content-Type: text/plain
Date: Fri, 31 Jul 2009 12:45:15 -0700
Message-Id: <1249069515.30019.228.camel@rc-desk>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2009-07-30 at 12:26 -0700, Johannes Berg wrote:
> On Thu, 2009-07-30 at 11:47 -0700, reinette chatre wrote:
> 
> > No. If this is what you want then I think you also need to remove
> > iwl_rx_ant_restriction.
> 
> Hm, I missed that, I actually have removed as part of my powersave
> patch.

now I see. 

Acked-by: Reinette Chatre <reinette.chatre@intel.com>

Reinette

