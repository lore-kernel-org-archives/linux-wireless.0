Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49945
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759768Ab0FKSiG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Jun 2010 14:38:06 -0400
Date: Fri, 11 Jun 2010 11:38:17 -0700 (PDT)
Message-Id: <20100611.113817.191400630.davem@davemloft.net>
To: reinette.chatre@intel.com
Cc: linville@tuxdriver.com, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] wireless: orphan ipw2x00 drivers
From: David Miller <davem@davemloft.net>
In-Reply-To: <1276278467.25793.1296.camel@rchatre-DESK>
References: <20100610014547.GA2318@tuxdriver.com>
	<20100609.225243.179940910.davem@davemloft.net>
	<1276278467.25793.1296.camel@rchatre-DESK>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: reinette chatre <reinette.chatre@intel.com>
Date: Fri, 11 Jun 2010 10:47:47 -0700

> On Wed, 2010-06-09 at 22:52 -0700, David Miller wrote:
>> If documentation can't be provided so that others can maintain this
>> driver (not just few specific people, because some day those folks
>> might tire of maintaining this too) that would be a serious crime.
> 
> We are unable to release this documentation, but are looking into our
> options at this time. With groups disbanded this will take some time.

And people wonder why we push vendors so damn hard to release chip
documentation even when the vendor has an upstream friendly set of
developers maintaining the code at least at the beginning.

It's exactly because stuff like this can and does happen.  And with
the plethora of devices with drivers in the tree now, expect the
number of times this happens to escalate in the future rather than
decrease.

We're powerless without those documents, and at the mercy of what
you guys end up deciding to do.  That doesn't work.
