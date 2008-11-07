Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:59037 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083AbYKGEko (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Nov 2008 23:40:44 -0500
Cc: Zhu Yi <yi.zhu@intel.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Message-Id: <5109BB99-53F1-499A-9D0B-FAB77591FBD5@linux.intel.com> (sfid-20081107_054048_397287_29074D6F)
From: Marcel Holtmann <holtmann@linux.intel.com>
To: Matt Mackall <mpm@selenic.com>
In-Reply-To: <1225944979.3792.3.camel@calx>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Mime-Version: 1.0 (Apple Message framework v929.2)
Subject: Re: iwlagn: wrong command queue 31, command id 0x0
Date: Fri, 7 Nov 2008 05:40:43 +0100
References: <1225944979.3792.3.camel@calx>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Matt,

> [ 5470.869820] WARNING: at drivers/net/wireless/iwlwifi/iwl-tx.c:1204
> iwl_rx_handle+0x11a/0x21b [iwlagn]()
> [ 5470.869824] wrong command queue 31, command id 0x0

I am seeing this a lot with my X61 running a 64-bit kernel/OS and my D- 
Link DIR-615 access point. With some other access points I am seeing  
it never or a lot less.

What kind of laptop and access point are you using? Is you access  
point 802.11n capable? Do you run the i386 or x86_64 version of your  
distro?

Regards

Marcel

