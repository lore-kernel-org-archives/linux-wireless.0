Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44439
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758219Ab0FITL5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jun 2010 15:11:57 -0400
Date: Wed, 09 Jun 2010 12:12:07 -0700 (PDT)
Message-Id: <20100609.121207.193693646.davem@davemloft.net>
To: reinette.chatre@intel.com
Cc: linux-wireless@vger.kernel.org
Subject: Re: iwlagn fails to assoc with nexus one in ad-hoc mode
From: David Miller <davem@davemloft.net>
In-Reply-To: <1276110641.1835.14891.camel@rchatre-DESK>
References: <1276102692.1835.14610.camel@rchatre-DESK>
	<20100609.103326.189711649.davem@davemloft.net>
	<1276110641.1835.14891.camel@rchatre-DESK>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: reinette chatre <reinette.chatre@intel.com>
Date: Wed, 09 Jun 2010 12:10:41 -0700

> Hi David,
> 
> On Wed, 2010-06-09 at 10:33 -0700, David Miller wrote:
>> From: reinette chatre <reinette.chatre@intel.com>
>> > Which hardware are you using? This information is needed to decode the
>> > firmware assert you are posting.
>> 
>> 5300
> 
> The firmware assert you are encountering is something that we have fixed
> before. This may be a new instance of it or you may not be running with
> the fix. What repo/kernel version are you using for your testing?

Upstream 2.6.34 vanilla.

> Also, to confirm things, could you ensure driver is compiled with
> CONFIG_IWLWIFI_DEBUG and load module with "modprobe iwlagn
> debug=0x43fff" to get us some more data? It may help to compile mac80211
> with verbose debugging (CONFIG_MAC80211_VERBOSE_DEBUG) also.

I'll try to find time to do this.
