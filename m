Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:21557 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751659Ab1JTTA1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Oct 2011 15:00:27 -0400
Subject: Re: iwlagn: WARN_ON() in iwl_get_idle_rx_chain_count()
From: wwguy <wey-yi.w.guy@intel.com>
To: =?UTF-8?Q?Micha=C5=82_Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>
Cc: Intel Linux Wireless <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>
In-Reply-To: <20111020185756.GA24185@rere.qmqm.pl>
References: <20111014150219.GA20672@rere.qmqm.pl>
	 <1318606158.12009.2.camel@wwguy-ubuntu>
	 <20111014192105.GA23640@rere.qmqm.pl> <20111020185756.GA24185@rere.qmqm.pl>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 20 Oct 2011 11:54:22 -0700
Message-ID: <1319136862.2111.3.camel@wwguy-ubuntu> (sfid-20111020_210035_320995_321869E7)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-10-20 at 11:57 -0700, Michał Mirosław wrote:
> On Fri, Oct 14, 2011 at 09:21:05PM +0200, Michał Mirosław wrote:
> > On Fri, Oct 14, 2011 at 08:29:18AM -0700, wwguy wrote:
> > > Could you try the attach patch and see if it fix your problem.
> > [attached patch removed]
> > Backported and applied. I'll test it for couple of days.
> 
> I haven't tripped on the warnings in those last days with your
> patch applied. I think the backported version should be included
> in 3.1.
> 
Thank you for testing it, I will push it upstream into 3.1

Best Regards
Wey


