Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yh0-f51.google.com ([209.85.213.51]:33928 "EHLO
	mail-yh0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752117AbbFITp7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Jun 2015 15:45:59 -0400
Received: by yhid80 with SMTP id d80so11526631yhi.1
        for <linux-wireless@vger.kernel.org>; Tue, 09 Jun 2015 12:45:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1433879050.1892.13.camel@sipsolutions.net>
References: <CAAnMG+MdokAvP4YNHnPX+o+0vi2vDfYB8Bj0x-kSci0yDa+bEg@mail.gmail.com>
	<1433879050.1892.13.camel@sipsolutions.net>
Date: Tue, 9 Jun 2015 12:45:58 -0700
Message-ID: <CAAnMG+N6wUMxAnqKpxKaBJcZrYwEqF7PcDVkRbwj-XJVri1KOQ@mail.gmail.com> (sfid-20150609_214602_575379_E51B3728)
Subject: Re: [PATCH] mac80211: Always check rates and capabilities in mesh mode
From: Alexis Green <agreen@cococorp.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Jesse Jones <jjones@cococorp.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Will resend using a better mail client. Just found out that web-gmail is no-go.

On Tue, Jun 9, 2015 at 12:44 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Fri, 2015-05-29 at 15:24 -0700, Alexis Green wrote:
>> In mesh mode there is a race between establishing links and processing rates
>> and capabilities in beacons. This is very noticeable with slow beacons (e.g.
>> beacon intervals of 1s) and manifested for us as stations using minstrel when
>> minstrel_ht should be used. Fixed by changing mesh_sta_info_init so that it
>> always checks rates and such if it has not already done so.
>>
>> Signed-off-by: Alexis Green <agreen@cococorp.com>
>> CC: Jesse Jones <jjones@cococorp.com>
>
> This patch doesn't apply, it's line-broken and whitespace damaged.
>
> johannes
>
