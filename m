Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from caladan.dune.hu ([78.24.191.180]:38144 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754190AbcCCPMU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Mar 2016 10:12:20 -0500
Subject: Re: [PATCH v2 2/2] mac80211: minstrel_ht: set A-MSDU tx limits based
 on selected max_prob_rate
To: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
References: <1456306140-78485-1-git-send-email-nbd@openwrt.org>
 <1456306140-78485-2-git-send-email-nbd@openwrt.org>
 <1457016949.2044.12.camel@sipsolutions.net> <56D85246.8070306@openwrt.org>
 <1457017621.2044.17.camel@sipsolutions.net>
Cc: egrumbach@gmail.com
From: Felix Fietkau <nbd@openwrt.org>
Message-ID: <56D85451.2080500@openwrt.org> (sfid-20160303_161227_601102_B01A4E8C)
Date: Thu, 3 Mar 2016 16:12:17 +0100
MIME-Version: 1.0
In-Reply-To: <1457017621.2044.17.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2016-03-03 16:07, Johannes Berg wrote:
> On Thu, 2016-03-03 at 16:03 +0100, Felix Fietkau wrote:
>> 
>> > This isn't *quite* right, since you have to take an 802.11 header
>> > (vs.
>> > an ethernet header) into account, I think?
>> It's only a rough approximation anyway to prevent very large A-MSDUs
>> from being created with low rates.
>> 
> 
> Right, but it seemed like the intent was to allow two full-MTU sized
> frames to be combined, which this doesn't.
I'll look into it some more to see if it's better to change the comment
or the code in this case.

- Felix
