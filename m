Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail022-1.exch022.serverdata.net ([64.78.22.98]:49593 "EHLO
	mail022-1.exch022.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751291Ab2K3MqJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Nov 2012 07:46:09 -0500
Message-ID: <50B8AA8C.9020508@posedge.com> (sfid-20121130_134615_412297_C6D30E51)
Date: Fri, 30 Nov 2012 18:16:04 +0530
From: Saravana <saravanad@posedge.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: add debugfs file for mic failure
References: <50B86A28.9090509@posedge.com> <1354275686.10035.0.camel@jlt4.sipsolutions.net>
In-Reply-To: <1354275686.10035.0.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/30/2012 05:11 PM, Johannes Berg wrote:
> On Fri, 2012-11-30 at 13:41 +0530, Saravana wrote:
>> Add a debugfs file showing the number of dropped
>> rx packet due to mic failures. currently the
>> number of rx packet dropped is counted in general and
>> not with respect to a specific reason. This patch
>> counts the number of packet drop due to mic failure.
> 
> It would make more sense to count them per *key*, not per station, and
> counting them per station like this can crash anyway if sta is NULL.
> 
I agree with you. I will prepare the patch per key instead of per station.
> johannes
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

