Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f52.google.com ([209.85.215.52]:41654 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756297Ab3KFMK0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Nov 2013 07:10:26 -0500
Received: by mail-la0-f52.google.com with SMTP id ev20so5964904lab.11
        for <linux-wireless@vger.kernel.org>; Wed, 06 Nov 2013 04:10:25 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1383732564.14307.16.camel@jlt4.sipsolutions.net>
References: <1383659329-11023-1-git-send-email-janusz.dziedzic@tieto.com>
	<1383732564.14307.16.camel@jlt4.sipsolutions.net>
Date: Wed, 6 Nov 2013 13:10:24 +0100
Message-ID: <CALhHN=pxo00fg6KYHJbw34FEP8k-6aiT2CMb5y7oRyVOyTzFZA@mail.gmail.com> (sfid-20131106_131028_922323_8E29169A)
Subject: Re: [PATCH v2 1/5] cfg80211/mac80211: DFS setup chandef for cac event
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 6 November 2013 11:09, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Tue, 2013-11-05 at 14:48 +0100, Janusz Dziedzic wrote:
>
>>  void cfg80211_cac_event(struct net_device *netdev,
>> +                     struct cfg80211_chan_def *chandef,
>
> Jouni had a patch to make a lot of these pointers const - this one
> probably should be as well.
>

Yes.
I can send this one after Jouni patch will be merged.

BR
Janusz
