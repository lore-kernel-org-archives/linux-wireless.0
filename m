Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.30]:38137 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751512AbYGPL34 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jul 2008 07:29:56 -0400
Received: by yx-out-2324.google.com with SMTP id 8so1786913yxm.1
        for <linux-wireless@vger.kernel.org>; Wed, 16 Jul 2008 04:29:55 -0700 (PDT)
Message-ID: <1ba2fa240807160429n22eed2cer17c88119bf50ac84@mail.gmail.com> (sfid-20080716_133000_730953_96401949)
Date: Wed, 16 Jul 2008 14:29:54 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: REVISED AGENDA -- Re: Linux Wireless Mini-Summit -- Ottawa -- July 22, 2008
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1216197607.3422.10.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <20080709190915.GA8238@tuxdriver.com>
	 <20080715182654.GA5969@tuxdriver.com>
	 <1216197607.3422.10.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 16, 2008 at 11:40 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 2008-07-15 at 14:26 -0400, John W. Linville wrote:
>
>> 0900  Status Reports
>>
>>       Overview of where things stand today
>>
>>       - 802.11n
>>
>>       - QoS/Multiqueue
>
> It might make sense to do these the other way around since 11n depends
> on the MQ stuff. I can talk about davem's recent changes that remove
> most of the code, but other than that I think we're pretty much set.
>
>> 1030  Current Work
>>
>>       Short presentations/discussions about work in progress
>>
>>       - access point mode
>>
>>       - cfg80211/nl80211
>>               - time to push to replace WEXT?
>>               - tool enhancements and/or userland support?
>
> Both of those are pretty much stalled now, apparently because I was the
> only one investing time into them and am no longer doing anything at the
> moment. I can give a five-minute overview over what we need/want for
> each of those I guess.

I believe as WEXT limitations are more visible mainly in the context
of fullmac chips.
A discussion that defining new interface or it course will be very
important. cfg80211 came a bit ahead of it's time and I  believe
actually now we can spin it again.
Tomas
