Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail022-1.exch022.serverdata.net ([64.78.22.98]:40680 "EHLO
	mail022-1.exch022.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751130Ab2LCGTE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Dec 2012 01:19:04 -0500
Message-ID: <50BC4453.2070705@posedge.com> (sfid-20121203_071908_749727_37C8158C)
Date: Mon, 03 Dec 2012 11:48:59 +0530
From: Saravana <saravanad@posedge.com>
MIME-Version: 1.0
To: Felix Fietkau <nbd@openwrt.org>
CC: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: add debugfs file for last rx rate
References: <50B77013.6040508@posedge.com> <50BB4BC5.1010806@openwrt.org>
In-Reply-To: <50BB4BC5.1010806@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/02/2012 06:08 PM, Felix Fietkau wrote:
> On 2012-11-29 3:24 PM, Saravana wrote:
>> Add a debugfs file showing the rate at which
>> the last packet is received.
>>
>> Signed-off-by: Saravana <saravanad@posedge.com>
> What's the point of adding debugfs files for data which is already
> available via nl80211?
> 
The debugfs is a repository of statistics. Many of the statistics like
tx/rx bytes/packets, retries, signal,power etc which are available via nl80211(iw)
are already available in debugfs. For the sake of completeness and to maintain
uniformity the last rx rate is added to debugfs.
> - Felix
> 

