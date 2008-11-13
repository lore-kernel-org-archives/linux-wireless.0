Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:20800 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751017AbYKMFrf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Nov 2008 00:47:35 -0500
Subject: Re: Issue with ifconfig down and 4965 driver
From: reinette chatre <reinette.chatre@intel.com>
To: Marcel Holtmann <holtmann@linux.intel.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <BCB72601-9DA2-4D89-BDF1-7B96254DA17C@linux.intel.com>
References: <BCB72601-9DA2-4D89-BDF1-7B96254DA17C@linux.intel.com>
Content-Type: text/plain
Date: Wed, 12 Nov 2008 21:48:13 -0800
Message-Id: <1226555293.1115.939.camel@rc-desk> (sfid-20081113_064740_377377_13FC973C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-11-12 at 20:14 -0800, Marcel Holtmann wrote:
> Hi guys,
> 
> so I am running a 2.6.28-rc4 kernel and every time I stop  
> wpa_supplicant or call ifconfig down on the 4965 card, I get a user  
> noticeable delay (mouse freezes). Seems that some part inside the  
> driver is actively sleeping with a busy-loop. This is really not an  
> acceptable behavior since it is a day-to-day task to bring the device  
> down. And for power concerns, we really wanna allow to bring down the  
> interface.
> 

Please add your information to
http://www.intellinuxwireless.org/bugzilla/show_bug.cgi?id=1790

Reinette

