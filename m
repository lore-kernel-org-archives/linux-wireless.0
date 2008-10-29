Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:17990 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757989AbYJ2XBR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2008 19:01:17 -0400
Subject: Re: Still 4965 issues with wireless-testing
From: reinette chatre <reinette.chatre@intel.com>
To: Marcel Holtmann <holtmann@linux.intel.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <5A6314C4-958B-43E7-B94D-FE5BABED89EA@linux.intel.com>
References: <5A6314C4-958B-43E7-B94D-FE5BABED89EA@linux.intel.com>
Content-Type: text/plain
Date: Wed, 29 Oct 2008 16:01:38 -0700
Message-Id: <1225321298.1115.309.camel@rc-desk> (sfid-20081030_000424_504369_7EEC6896)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-10-29 at 14:33 -0700, Marcel Holtmann wrote:
> Hi guys,
> 
> so besides the point that the Ubuntu 8.10 kernel has a broken driver  
> for the Intel 4965 cards which will crash my X61 after less than one  
> minute uptime when it connects to my access point, I have my dmesg  
> full with warnings from the latest wireless-testing kernel.
> 
> I know that we have discussed this before and Johannes' patch at least  
> turns it into warnings instead of killing my system completely, but I  
> am still surprised why this hasn't been fixed.
> 
> Attached is one of the dmesg snippets. They occur multiple times per  
> minute.

Could you please compare your testing with that done in
http://www.intellinuxwireless.org/bugzilla/show_bug.cgi?id=1703 ?

Thanks

Reinette

