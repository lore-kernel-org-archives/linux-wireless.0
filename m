Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:44147 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752691Ab0CYQdl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Mar 2010 12:33:41 -0400
Subject: Re: [PATCH] iwlwifi: fix build error for CONFIG_IWLAGN=n
From: reinette chatre <reinette.chatre@intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-next@vger.kernel.org" <linux-next@vger.kernel.org>
In-Reply-To: <20100324233832.GB32563@tuxdriver.com>
References: <4BAA73D2.1000301@oracle.com>
	 <1269465799-19060-1-git-send-email-linville@tuxdriver.com>
	 <1269466426.6935.8.camel@jlt3.sipsolutions.net>
	 <1269466948.2446.3216.camel@rchatre-DESK>
	 <20100324223719.GA32563@tuxdriver.com>
	 <1269470489.2446.3217.camel@rchatre-DESK>
	 <20100324233832.GB32563@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 25 Mar 2010 09:33:40 -0700
Message-ID: <1269534820.2446.3230.camel@rchatre-DESK>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

On Wed, 2010-03-24 at 16:38 -0700, John W. Linville wrote:
> On Wed, Mar 24, 2010 at 03:41:29PM -0700, reinette chatre wrote:
> 
> > I am very sorry, here is the correct link:
> > http://git.kernel.org/?p=linux/kernel/git/iwlwifi/iwlwifi-2.6.git;a=commit;h=bc745eb7d28285f3b437c00253bf01ef501eb3f1
> 
> FWIW, that one misses the definition of iwl_good_ack_health in iwl-core.h.

This definition was added in an recent patch "iwlwifi: code cleanup for
connectivity recovery" which is already in wireless-next-2.6.

> I already put the other one in wireless-next-2.6.  I'll just resolve
> the conflict when I pull your tree.

I'll try to sort this out with our next submission so that there are no
conflicts to resolve.

Reinette


