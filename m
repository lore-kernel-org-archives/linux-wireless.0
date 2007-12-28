Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56143
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752193AbXL1WVS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Dec 2007 17:21:18 -0500
Date: Fri, 28 Dec 2007 14:21:18 -0800 (PST)
Message-Id: <20071228.142118.204448113.davem@davemloft.net> (sfid-20071228_222124_264233_6F97DC96)
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org
Subject: Re: cfg80211 API for channels/bitrates, mac80211 and driver
 conversion
From: David Miller <davem@davemloft.net>
In-Reply-To: <1198879515.4172.21.camel@johannes.berg>
References: <1198878633.4172.19.camel@johannes.berg>
	<20071228.140103.159573237.davem@davemloft.net>
	<1198879515.4172.21.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>
Date: Fri, 28 Dec 2007 23:05:14 +0100

> 
> > >  include/net/wireless.h                       |  168 ++++++++++ 
> > 
> > Are the datastructures in this file the ones that go over
> > netlink and thus userland sees?
> 
> No. These are purely the internal definitions, I'm just working on
> defining the netlink attributes for the information going over to
> userland (in include/linux/nl80211.h).

Excellent, thanks for the explanation.
