Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hub022-nj-3.exch022.serverdata.net ([206.225.164.186]:64469
	"EHLO HUB022-nj-3.exch022.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752191Ab2KSESc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Nov 2012 23:18:32 -0500
Message-ID: <50A9B312.2010603@posedge.com> (sfid-20121119_051838_747448_816805B0)
Date: Mon, 19 Nov 2012 09:48:26 +0530
From: Mahesh Palivela <maheshp@posedge.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [RFC v2 4/8] nl80211/cfg80211: support VHT channel configuration
References: <1352492254-29399-1-git-send-email-johannes@sipsolutions.net>  <1352492254-29399-5-git-send-email-johannes@sipsolutions.net>  <50A62FDA.2070307@posedge.com> <1353069457.9490.3.camel@jlt4.sipsolutions.net>
In-Reply-To: <1353069457.9490.3.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/16/2012 06:07 PM, Johannes Berg wrote:
> On Fri, 2012-11-16 at 17:51 +0530, Mahesh Palivela wrote:
>> On 11/10/2012 01:47 AM, Johannes Berg wrote:
>>> From: Johannes Berg <johannes.berg@intel.com>
>>>
>>
>>> + *
>>> + * @NL80211_CHAN_WIDTH_20_NOHT: 20 MHz, non-HT channel
>>
>> Should we have NL80211_CHAN_WIDTH_LEGACY or rename
>> NL80211_CHAN_WIDTH_20_NOHT to NL80211_CHAN_WIDTH_NOHT to cover non HT
>> associations in both 2.4 & 5 GHz bands.
>
> Huh? I must be misunderstanding something -- both 2.4 and 5 GHz bands
> use 20 MHz bandwidth by default?
>

2.4 band channel spacing is 5 MHz and we can use 20 MHz bandwidth only 
in HT mode.
