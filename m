Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:9598 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759106Ab0FJQXW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jun 2010 12:23:22 -0400
Subject: Re: [PATCHv4] mac80211: Fix circular locking dependency in ARP
 filter handling
From: reinette chatre <reinette.chatre@intel.com>
To: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1276147838.5277.34297.camel@wimaxnb.nmp.nokia.com>
References: <1276080206-29562-1-git-send-email-juuso.oikarinen@nokia.com>
	 <1276126067.1835.15473.camel@rchatre-DESK>
	 <1276147255.5277.34285.camel@wimaxnb.nmp.nokia.com>
	 <1276147838.5277.34297.camel@wimaxnb.nmp.nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 10 Jun 2010 09:23:21 -0700
Message-ID: <1276187001.1835.17525.camel@rchatre-DESK>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-06-09 at 22:30 -0700, Juuso Oikarinen wrote:
> On Thu, 2010-06-10 at 07:21 +0200, Juuso Oikarinen wrote:
> > On Thu, 2010-06-10 at 01:27 +0200, ext reinette chatre wrote:
> > > Even so, I tested your new patch and for some reason the BUG returned
> > > (even though I am now running with "mac80211: Add netif state checking
> > > to ieee80211_ifa_changed"
> > 
> > This is curious. In your source (mine does not seem to fully match what
> > you are using) what is the BUG that is getting triggered, main.c:437 ?
> 
> Oh, and did you remember to apply the fix patch for the bug too, as it
> seems not yet be integrated to wireless-testing:
> 
> "mac80211: Add netif state checking to ieee80211_ifa_changed"
> 

I am running with that patch  .... see my comment above ;)

Reinette


