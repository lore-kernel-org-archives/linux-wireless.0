Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from elasmtp-dupuy.atl.sa.earthlink.net ([209.86.89.62]:35840 "EHLO
	elasmtp-dupuy.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753662AbYFLU0G (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jun 2008 16:26:06 -0400
Message-ID: <4851864B.4040103@earthlink.net> (sfid-20080612_222610_567193_3B5C071E)
Date: Thu, 12 Jun 2008 16:25:47 -0400
From: Stephen Clark <sclark46@earthlink.net>
Reply-To: sclark46@earthlink.net
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: Zhu Yi <yi.zhu@intel.com>, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net
Subject: Re: [ipw3945-devel] [BUG] iwlwifi 3945 works only	with	disable_hw_scan=1
References: <484FEA26.1040305@gmail.com>	<1213241315.7814.696.camel@debian.sh.intel.com> <20080612135936.GA5031@tuxdriver.com>
In-Reply-To: <20080612135936.GA5031@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John W. Linville wrote:
> On Thu, Jun 12, 2008 at 11:28:35AM +0800, Zhu Yi wrote:
> 
>> I don't understand why "disable_hw_scan=1" works for you. Can you also
>> attach the dmesg for it?
> 
> How does the hardware scan differ from what mac80211 does when
> scanning?  I still see a lot of mysterious iwlwifi (especially iwl3945)
> problems in Fedora that seem to disappear with disable_hw_scan=1.
> 
> Honestly I'm tempted to change it to "enable_hw_scan" instead...
> 
> John
It has been a while since I tested without "disable_hw_scan=1" - my 3945 works
every time with it - last time I tested without it was very hit or miss. 
Sometimes taking over 10 minutes to get associated, sometimes never and this
was with me right next to the WAP.

I think the latest in the fedora kernel I am using is 1.26kds as I recall.

Steve

-- 

"They that give up essential liberty to obtain temporary safety,
deserve neither liberty nor safety."  (Ben Franklin)

"The course of history shows that as a government grows, liberty
decreases."  (Thomas Jefferson)


