Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.169]:18820 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751621AbZCNUTF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Mar 2009 16:19:05 -0400
Received: by wf-out-1314.google.com with SMTP id 28so1118378wfa.4
        for <linux-wireless@vger.kernel.org>; Sat, 14 Mar 2009 13:19:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1237060542.5235.109.camel@johannes.local>
References: <20090314171234.11126.21125.stgit@tikku>
	 <20090314171438.11126.30330.stgit@tikku>
	 <43e72e890903141245k46f4dd4co6a33b45b82e9098a@mail.gmail.com>
	 <1237060542.5235.109.camel@johannes.local>
Date: Sat, 14 Mar 2009 13:19:03 -0700
Message-ID: <43e72e890903141319p2a50f790q86833be80ab63e48@mail.gmail.com> (sfid-20090314_211907_510571_04B2D3C6)
Subject: Re: [RFC PATCH v2 2/4] mac80211: track beacons separately from the rx
	path activity
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Kalle Valo <kalle.valo@nokia.com>, linux-wireless@vger.kernel.org,
	Jouni Malinen <j@w1.fi>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Mar 14, 2009 at 12:55 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Sat, 2009-03-14 at 12:45 -0700, Luis R. Rodriguez wrote:
>> On Sat, Mar 14, 2009 at 10:14 AM, Kalle Valo <kalle.valo@nokia.com> wrote:
>> > Separate beacon and rx path tracking in preparation for the beacon filtering
>> > support. At the same time change ieee80211_associated() to look a bit simpler.
>> >
>> > Probe requests are now sent only after IEEE80211_PROBE_IDLE_TIME, which
>> > is now set to 60 seconds.
>> >
>> > Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
>>
>> Can this be split into 3 separate patches, to make the one with the
>> actual functional changes easier to review. One is the making of
>> ieee80211_associated() look easier, the other the rename, and lastly
>> the actual functional changes. When reviewing the commit log it would
>> then be easier to see what was done.
>
> Disagree, the rename is part of the functional change, it's not just a
> plain rename.

Alright, then 2.

  Luis
