Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f176.google.com ([209.85.223.176]:50307 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159AbbAFS51 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Jan 2015 13:57:27 -0500
Received: by mail-ie0-f176.google.com with SMTP id tr6so4385907ieb.7
        for <linux-wireless@vger.kernel.org>; Tue, 06 Jan 2015 10:57:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1420553688.1966.33.camel@sipsolutions.net>
References: <1420366399-31535-1-git-send-email-eliad@wizery.com>
	<1420542274.1966.21.camel@sipsolutions.net>
	<1420553111.1966.32.camel@sipsolutions.net>
	<1420553688.1966.33.camel@sipsolutions.net>
Date: Tue, 6 Jan 2015 20:57:27 +0200
Message-ID: <CAB3XZEctcBuPG6f4ZrZFV5O3Z7+hi+ShFdwvFXdJovG2KeAufQ@mail.gmail.com> (sfid-20150106_195732_879502_467129A1)
Subject: Re: [PATCH 1/3] mac80211: consider only relevant vifs for
 radar_required calculation
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 6, 2015 at 4:14 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Tue, 2015-01-06 at 15:05 +0100, Johannes Berg wrote:
>> On Tue, 2015-01-06 at 12:04 +0100, Johannes Berg wrote:
>> > all three applied.
>>
>> Nope, dropped patch 2 again
>
> And dropped the other two also - with them the sequence of two tests I
> was looking at never completes.
>
err... sorry about that.
i'll look into it.

thanks,
Eliad.
