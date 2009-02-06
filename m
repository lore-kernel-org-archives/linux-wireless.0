Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:25144 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752523AbZBFWlt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Feb 2009 17:41:49 -0500
Subject: Re: iwlagn: Microcode SW error detected.
From: reinette chatre <reinette.chatre@intel.com>
To: Jan Schneider <jan@horde.org>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20090206233134.11116cap9kcroxgc@neo.wg.de>
References: <20090206233134.11116cap9kcroxgc@neo.wg.de>
Content-Type: text/plain
Date: Fri, 06 Feb 2009 14:45:18 -0800
Message-Id: <1233960318.11530.114.camel@rc-desk> (sfid-20090206_234153_652792_C0CB41C9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2009-02-06 at 14:31 -0800, Jan Schneider wrote:
> I've seen in a post from January that someone already had this problem  
> but couldn't reproduce it.
> I can't reliably reproduce, but I see this more often than I like.  
> When this happens, it usually doesn't help to reload the kernel  
> module. Sometimes it helps to use the rfkill switch though.
> 
> Here's a log with debug=0x43fff:

It does not seem as though your driver is compiled with debug support.
You can confirm that by looking at the version number of the driver
printed when it loads ... it should have a "d" in it like "1.2.26kds".
Could you please recompile the driver with debug support (IWLWIFI_DEBUG)
and rerun your test?  This will provide us with a complete event log of
the uCode error.

Thank you

Reinette


