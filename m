Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.21]:47342 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752484AbXBIXAc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Feb 2007 18:00:32 -0500
Message-ID: <45CCF318.2020503@linux.intel.com>
Date: Fri, 09 Feb 2007 14:18:00 -0800
From: James Ketrenos <jketreno@linux.intel.com>
MIME-Version: 1.0
To: Pavel Roskin <proski@gnu.org>
CC: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net, netdev@vger.kernel.org
Subject: Re: [ANNOUNCE] d80211 based driver for Intel PRO/Wireless 3945ABG
References: <45CCE3CA.4050904@linux.intel.com> <1171061021.7039.7.camel@dv>
In-Reply-To: <1171061021.7039.7.camel@dv>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pavel Roskin wrote:
> Hello, James!
> 
> On Fri, 2007-02-09 at 13:12 -0800, James Ketrenos wrote:
> 
>> You can find the new driver, and additional information about it, here:
>>
>>    http://intellinuxwireless.org/iwlwifi.
> 
> I cannot get it through git:
> 
> $ git-clone http://intellinuxwireless.org/repos/iwlwifi.git
> Initialized empty Git repository in /home/proski/src/iwlwifi/.git/
> Cannot get remote repository information.
> Perhaps git-update-server-info needs to be run there?
> 
> Perhaps git is right?  There is no info/refs there.

Updated and tested 'git clone' and its working now (I use cg-clone)

> grep: /lib/modules/2.6.20/build//include/linux/netdevice.h: No such file
> or directory
> 
> Apparently it should be looking into /lib/modules/2.6.20/source as well.
> That was a problem with the official ipw3945 drivers as well.

I'll look into it.  Does it work if you explicitly set KSRC to point to 
your kernel sources?

$ make KSRC=/lib/modules/2.6.20/source

?

Thanks,
James
