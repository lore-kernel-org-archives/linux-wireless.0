Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:55242 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755891Ab3LISTZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Dec 2013 13:19:25 -0500
Message-ID: <52A609A3.9030708@openwrt.org> (sfid-20131209_191928_372481_A119C1F4)
Date: Mon, 09 Dec 2013 19:19:15 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Antonio Quartulli <antonio@meshcoding.com>,
	linux-wireless@vger.kernel.org
CC: johannes@sipsolutions.net
Subject: Re: [PATCH] mac80211: add helper functions for tracking P2P NoA state
References: <1386604742-8560-1-git-send-email-nbd@openwrt.org> <52A60603.3010606@meshcoding.com>
In-Reply-To: <52A60603.3010606@meshcoding.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-12-09 19:03, Antonio Quartulli wrote:
> On 09/12/13 16:59, Felix Fietkau wrote:
> [...]
>> +/**
>> + * struct ieee80211_noa_data - holds temporary data for tracking P2P NoA state
>> + *
>> + * @next_tsf: TSF timestamp of the next absent state change
>> + * @has_next_tsf: next absent state change event pending
>> + *
>> + * @absent: descriptor bitmask, set if GO is currently absent
>> + */
> 
> why not providing the kerneldoc for all the fields? Even the more
> obvious for you may not be so obvious for the next poor reader that has
> to touch this code :-)
The driver should not care about those, they're private for the mac80211
utility function.

- Felix

