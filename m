Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:53700 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755816Ab1HaOr7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Aug 2011 10:47:59 -0400
Message-ID: <4E5E499D.1050600@openwrt.org> (sfid-20110831_164812_234726_3274EA28)
Date: Wed, 31 Aug 2011 16:47:57 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Helmut Schaa <helmut.schaa@googlemail.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com
Subject: Re: [PATCH] mac80211: retry sending failed BAR frames later instead
 of tearing down aggr
References: <1314558661-28454-1-git-send-email-nbd@openwrt.org> <1314792948.4161.23.camel@jlt3.sipsolutions.net> <CAGXE3d-_hSmii3GsZF3jqOfP1amrMeL+GtJ605z406nRjA_z7g@mail.gmail.com>
In-Reply-To: <CAGXE3d-_hSmii3GsZF3jqOfP1amrMeL+GtJ605z406nRjA_z7g@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-08-31 2:31 PM, Helmut Schaa wrote:
> On Wed, Aug 31, 2011 at 2:15 PM, Johannes Berg
> <johannes@sipsolutions.net>  wrote:
>>  On Sun, 2011-08-28 at 21:11 +0200, Felix Fietkau wrote:
>>>  Unfortunately failed BAR tx attempts happen more frequently than I
>>>  expected, and the resulting aggregation teardowns cause performance
>>>  issues, as the aggregation session does not always get re-established
>>>  properly.
>
> Felix, so this also happens with ath9k (not only rt2800pci)?
Right. I think it can happen with any driver if the client goes into 
powersave during heavy traffic.

- Felix
