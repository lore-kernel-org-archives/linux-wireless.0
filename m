Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.21]:16994 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932125AbXBNA6a (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Feb 2007 19:58:30 -0500
Message-ID: <45D254C6.7050401@linux.intel.com>
Date: Tue, 13 Feb 2007 16:16:06 -0800
From: James Ketrenos <jketreno@linux.intel.com>
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
Subject: Re: [ipw3945-devel] [ANNOUNCE] d80211 based driver for Intel PRO/Wireless  3945ABG
References: <45CCE3CA.4050904@linux.intel.com> <20070213181313.GA5350@ucw.cz>
In-Reply-To: <20070213181313.GA5350@ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pavel Machek wrote:
...
>> You can find the new driver, and additional information 
>> about it, here:
>>
>>   http://intellinuxwireless.org/iwlwifi.
> ...
>> You can find that package at:
>>
>>   http://intellinuxwireless.org/d80211
>>
>> Ok.  Now... any questions?
> 
> Yes... is there merged .git tree somewhere? I downloaded iwl git tree,
> but it did not contain d80211 stack. I'm now downloading wireless-dev
> git tree...
> 							Pavel

There isn't a singular merged iwlwifi + d80211 package tree outside of 
wireless-dev, and iwlwifi isn't there yet (I'm cleaning out some dead 
and duplicated code before we submit)

I've put up http://intellinuxwireless.org/repos/?p=d80211.git so you can 
pull the d80211 package via git (vs. downloading the tarball).  Running 
'make patch_kernel' will then install the d80211 subsystem containing 
patches not yet in wireless-dev into your kernel sources (specified via 
KSRC=)

James

