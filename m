Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail022-1.exch022.serverdata.net ([64.78.22.98]:57285 "EHLO
	mail022-1.exch022.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751882Ab2K2G3N (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Nov 2012 01:29:13 -0500
Message-ID: <50B700B4.3080803@posedge.com> (sfid-20121129_072920_526348_B48C6DE1)
Date: Thu, 29 Nov 2012 11:59:08 +0530
From: Saravana <saravanad@posedge.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [RFC] mac80211: add debugfs file for mic failure
References: <67d5ecb12773d91de180d654e6283cbe@posedge.com> <1353942528.2800.1.camel@jlt4.sipsolutions.net> <50B4565E.6030105@posedge.com>
In-Reply-To: <50B4565E.6030105@posedge.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/27/2012 11:27 AM, Saravana wrote:
> On 11/26/2012 08:38 PM, Johannes Berg wrote:
>> On Mon, 2012-11-26 at 04:56 -0800, saravanad@posedge.com wrote:
>>> Add a debugfs file showing the number of failure of
>>> rx packet dropped due to mic failures. currently the
>>> number of rx packet dropped is counted in general and
>>> not with respect to a specific reason. This patch
>>> counts the number of packet drop due to mic failure.
>>
>> What's the value of this, shouldn't wpa_s/hostapd start countermeasures
>> pretty quickly?
>>
> This will just be a counter which keeps track of the number of mic failures. Debugfs already had Rx dropped packet counter. This would provide more granularity in respect to the reason of packet drop.
> Yes, wpa_s/hostapd will start countermeasure quickly.
> 
>> johannes
>>
Could mic failure count be added to debugfs?
Saravana
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> 
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

