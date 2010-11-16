Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:53469 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756990Ab0KPXeh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Nov 2010 18:34:37 -0500
Message-ID: <4CE3150A.7000300@openwrt.org>
Date: Wed, 17 Nov 2010 00:34:34 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Subject: Re: [PATCH 1/2] cfg80211: add support for setting the ad-hoc multicast
 rate
References: <1289484443-96326-1-git-send-email-nbd@openwrt.org> <1289946423.3673.13.camel@jlt3.sipsolutions.net>
In-Reply-To: <1289946423.3673.13.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-11-16 11:27 PM, Johannes Berg wrote:
> On Thu, 2010-11-11 at 15:07 +0100, Felix Fietkau wrote:
> 
>> +	if (info->attrs[NL80211_ATTR_MCAST_RATE])
>> +		ibss.mcast_rate =
>> +			nla_get_u32(info->attrs[NL80211_ATTR_MCAST_RATE]);
> 
> That should really check that the rate is supported, and maybe that it's
> a basic rate.
But what about band changes then?

- Felix
