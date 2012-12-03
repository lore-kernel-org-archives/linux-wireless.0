Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:33051 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752728Ab2LCIPA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Dec 2012 03:15:00 -0500
Message-ID: <50BC5F7C.3080505@openwrt.org> (sfid-20121203_091506_532036_511BD82B)
Date: Mon, 03 Dec 2012 09:14:52 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Saravana <saravanad@posedge.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: add debugfs file for last rx rate
References: <50B77013.6040508@posedge.com> <50BB4BC5.1010806@openwrt.org> <50BC4453.2070705@posedge.com>
In-Reply-To: <50BC4453.2070705@posedge.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-12-03 7:18 AM, Saravana wrote:
> On 12/02/2012 06:08 PM, Felix Fietkau wrote:
>> On 2012-11-29 3:24 PM, Saravana wrote:
>>> Add a debugfs file showing the rate at which
>>> the last packet is received.
>>>
>>> Signed-off-by: Saravana <saravanad@posedge.com>
>> What's the point of adding debugfs files for data which is already
>> available via nl80211?
>> 
> The debugfs is a repository of statistics. Many of the statistics like
> tx/rx bytes/packets, retries, signal,power etc which are available via nl80211(iw)
> are already available in debugfs. For the sake of completeness and to maintain
> uniformity the last rx rate is added to debugfs.
I think debugfs does not have (or need) completeness and uniformity, nor
is it meant as a repository of statistics. It is to be used for various
debugging purposes (as the name implies).
I think any additions of info to debugfs that are also available through
regular APIs should be considered unnecessary bloat and dropped.

- Felix
