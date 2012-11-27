Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail022-1.exch022.serverdata.net ([64.78.22.98]:38130 "EHLO
	mail022-1.exch022.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752593Ab2K0FkR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2012 00:40:17 -0500
Message-ID: <50B45239.7070300@posedge.com> (sfid-20121127_064021_010485_541944DC)
Date: Tue, 27 Nov 2012 11:10:09 +0530
From: Saravana <saravanad@posedge.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [RFC] mac80211: add debugfs file for current tx rate
References: <3cce329ee6381f0ab4dd4d86ea76c2da@posedge.com> <1353942595.2800.2.camel@jlt4.sipsolutions.net>
In-Reply-To: <1353942595.2800.2.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/26/2012 08:39 PM, Johannes Berg wrote:
> On Mon, 2012-11-26 at 05:22 -0800, saravanad@posedge.com wrote:
>> Add a debugfs file showing the current tx rate.
>> The information available in the rc_stats file
>> doesn't evidently provides us the current tx rate.
>> This patch adds the support for the same.
>
> I don't see any value in this, you can just do "iw station dump" to get
> the information.
>
The debugfs already contains almost all the parameters that can be 
viewed  when "iw station dump" is used. e.g. rx/tx bytes,packets, tx 
retry, power. The current tx rate was available in iw but not in debugfs.
For sake of completeness and to maintain uniformity, thought of adding
current tx rate to debugfs.
> johannes
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

