Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:45821 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759577Ab0KQDAz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Nov 2010 22:00:55 -0500
Message-ID: <4CE34565.6040204@openwrt.org>
Date: Wed, 17 Nov 2010 04:00:53 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Subject: Re: [PATCH 2/2] mac80211: add support for setting the ad-hoc multicast
 rate
References: <1289484443-96326-1-git-send-email-nbd@openwrt.org>	 <1289484443-96326-2-git-send-email-nbd@openwrt.org> <1289946471.3673.14.camel@jlt3.sipsolutions.net>
In-Reply-To: <1289946471.3673.14.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-11-16 11:27 PM, Johannes Berg wrote:
> On Thu, 2010-11-11 at 15:07 +0100, Felix Fietkau wrote:
> 
>> +	if (mcast_rate) {
>> +		for (i = 0; i < sband->n_bitrates; i++) {
>> +			if (sband->bitrates[i].bitrate == mcast_rate) {
>> +				*idx = i;
>> +				return;
>> +			}
>> +		}
>> +	}
> 
> That conversion loop really shouldn't be in the hotpath.
Seems like the change got merged already, I'll send follow-up fixes soon.

- Felix

