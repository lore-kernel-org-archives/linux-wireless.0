Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:44632 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753279Ab2JVOCk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Oct 2012 10:02:40 -0400
Received: by mail-wg0-f44.google.com with SMTP id dr13so2255268wgb.1
        for <linux-wireless@vger.kernel.org>; Mon, 22 Oct 2012 07:02:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1350912037.10166.5.camel@jlt4.sipsolutions.net>
References: <CAF1_xX2uo0Q7mNSEENA2uH61itMxjoJ8ejcS9MeW5puibXpeeQ@mail.gmail.com>
	<1350912037.10166.5.camel@jlt4.sipsolutions.net>
Date: Mon, 22 Oct 2012 16:02:39 +0200
Message-ID: <CAF1_xX2NA_kCSJVvu=o=MhC+wMWSDk7n0DQa9ukQUCYESKtheQ@mail.gmail.com> (sfid-20121022_160243_851391_E8335F99)
Subject: Re: [regression][bisected] Handling of channel contexts causes
 wireless to fail (i.e. no wlan* devices)
From: Ronald <ronald645@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2012/10/22 Johannes Berg <johannes@sipsolutions.net>:
> On Mon, 2012-10-22 at 15:13 +0200, Ronald wrote:
>> The following commit causes wireless interfaces to not show up (i.e.
>> wlan* is non existant):
>>
>> fe57d9f: mac80211: track whether to use channel contexts
>>
>> Reverting this commit on top of current wireless-testing resulted in
>> undefined references to chanctx.
>
> Oops, my mistake, this should fix it:
>
> http://p.sipsolutions.net/cd55626ca51fc3c5.txt
>
> johannes
>

I can confirm that the attached patch fixes the issue reported.

                 Thanks!
