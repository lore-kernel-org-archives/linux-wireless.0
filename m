Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34670
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756033Ab0FJBUs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jun 2010 21:20:48 -0400
Date: Wed, 09 Jun 2010 18:20:58 -0700 (PDT)
Message-Id: <20100609.182058.246527219.davem@davemloft.net>
To: reinette.chatre@intel.com
Cc: linux-wireless@vger.kernel.org
Subject: Re: iwlagn fails to assoc with nexus one in ad-hoc mode
From: David Miller <davem@davemloft.net>
In-Reply-To: <1276111062.1835.14914.camel@rchatre-DESK>
References: <1276110641.1835.14891.camel@rchatre-DESK>
	<20100609.121207.193693646.davem@davemloft.net>
	<1276111062.1835.14914.camel@rchatre-DESK>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: reinette chatre <reinette.chatre@intel.com>
Date: Wed, 09 Jun 2010 12:17:42 -0700

> On Wed, 2010-06-09 at 12:12 -0700, David Miller wrote:
>> Upstream 2.6.34 vanilla.
> 
> ok - the firmware assert you are encountering is in the station
> management code which received significant rework in 2.6.35. Could you
> please try latest linux-2.6 (since there are some issues with
> 2.6.35-rc2)?

I did a quick test, and with the current tree the connection works
and I can associate with the nexus one, however I still get a few
of those beacon TIM error logs in my dmesg.
