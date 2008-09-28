Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:54531 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752395AbYI1DQI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Sep 2008 23:16:08 -0400
Subject: Re: [PATCH] Working packet injection patch for ipw2200 - enables
	aireplay-ng and others to work
From: Zhu Yi <yi.zhu@intel.com>
To: Paul <paul14075@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <7d553cf40809271345n3a945091u6c341e65c51811d5@mail.gmail.com>
References: <7d553cf40809271345n3a945091u6c341e65c51811d5@mail.gmail.com>
Content-Type: text/plain
Date: Sun, 28 Sep 2008 11:15:10 +0800
Message-Id: <1222571710.2510.587.camel@debian.sh.intel.com> (sfid-20080928_051613_791909_7A7E0488)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2008-09-27 at 14:45 -0600, Paul wrote:
> I made this patch using bits and pieces from various other "ipw2200
> injection patches".  I can not take credit for the content, as I
> basically just changed the line numbers in the .diff files.  However I
> applied this patch to the version of ipw2200 included in kernel
> 2.6.27-rc6  (i believe it's ipw2200-1.2.2) and it worked like a charm.
> 
> Previously I was unable to inject wifi packets using aireplay-ng due
> to this error:
> 
> "ARP linktype is set to 1 (Ethernet) - expected ARPHRD_IEEE80211 or
> ARPHRD_IEEE80211_PRISM instead.  Make sure RFMON is enabled: run
> 'ifconfig wifi0 up; iwconfig wifi0 mode Monitor channel <#>' Sysfs
> injection support was not found either."
> 
> However, after switching to Monitor mode, even though aireplay would
> ACT AS IF it was working, it wasn't.

Isn't the rtap_iface does the same thing? Did you try it?

Thanks,
-yi

