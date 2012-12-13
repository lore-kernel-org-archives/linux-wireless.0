Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail022-1.exch022.serverdata.net ([64.78.22.98]:37177 "EHLO
	mail022-1.exch022.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752800Ab2LMKMi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2012 05:12:38 -0500
Message-ID: <50C9AA12.4060303@posedge.com> (sfid-20121213_111241_891740_D2752950)
Date: Thu, 13 Dec 2012 15:42:34 +0530
From: Srinivasan B <srinivasanb@posedge.com>
MIME-Version: 1.0
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
CC: johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Subject: Re: 802.11h DFS support
References: <50C89C8B.6040301@posedge.com> <20121213095134.GA26314@pandem0nium>
In-Reply-To: <20121213095134.GA26314@pandem0nium>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Simon,
          Thanks for the clarification.

regards,
Srinivasan

On 12/13/2012 03:21 PM, Simon Wunderlich wrote:
> Hello Srinivasan,
>
> On Wed, Dec 12, 2012 at 08:32:35PM +0530, Srinivasan B wrote:
>> Hi,
>>          I was looking for the DFS support in
>> mac80211/cfg80211/nl80211/hostapd and observed that the latest
>> wireless-testing kernel&  hostapd.git does not include support for
>> 802.11h.
> that's correct.
>>          I also referred few patches submitted by Victor Goldenshtein
>> which had support for entire DFS operation basing wireless-testing
>> kernel. As per my understanding these patches are presently getting
>> modified to support new channel-context modifications.
>>
>>          Could someone confirm if I am right at my understanding.
> Yup. Actually I picked up Victors patchset and doing the channel context
> rework right now, and plan to send a revised patchset for nl80211/mac80211
> soon.
>
> "Entire" DFS operation is not entirely correct. There will still be quite
> a few bits missing:
>
>   * driver support - some drivers like ath9k have something prepared, but
>     it still needs to be integrated
>   * ETSI/FCC support has to be verified for the different drivers
>   * testing, of course
>
> Cheers,
> 	Simon

