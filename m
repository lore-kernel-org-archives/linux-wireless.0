Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:57783 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950Ab0INOnd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Sep 2010 10:43:33 -0400
Received: by iwn5 with SMTP id 5so6147322iwn.19
        for <linux-wireless@vger.kernel.org>; Tue, 14 Sep 2010 07:43:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1284475122.3704.11.camel@jlt3.sipsolutions.net>
References: <1284474028-3337-1-git-send-email-lrodriguez@atheros.com>
 <1284474577.3704.8.camel@jlt3.sipsolutions.net> <AANLkTin5Dbb+0EdY4wEmbk=ZAvFbowBj5YqH4fX9hBgc@mail.gmail.com>
 <1284475122.3704.11.camel@jlt3.sipsolutions.net>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Tue, 14 Sep 2010 07:43:12 -0700
Message-ID: <AANLkTi=_tq2vw6GCAjf4pudGaQgHzOp7OAaTSB1itQpy@mail.gmail.com>
Subject: Re: [PATCH 07/10] mac80211: disable beacon monitor while going offchannel
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	stable@kernel.org, Paul Stewart <pstew@google.com>,
	Amod Bodas <amod.bodas@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 14, 2010 at 7:38 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 2010-09-14 at 07:35 -0700, Luis R. Rodriguez wrote:
>> On Tue, Sep 14, 2010 at 7:29 AM, Johannes Berg
>> <johannes@sipsolutions.net> wrote:
>> > On Tue, 2010-09-14 at 10:20 -0400, Luis R. Rodriguez wrote:
>> >
>> >> +     del_timer_sync(&ifmgd->bcn_mon_timer);
>> >>       del_timer_sync(&sdata->u.mgd.conn_mon_timer);
>> >
>> > This is kinda inconsistent now ... and you added both these lines in
>> > your patch set :-)
>>
>> Sorry, I do not follow, can you elaborate?
>
> You use "ifmgd->", but also "sdata->u.mgd." when both should be one of
> those.

Ah heh yeah, good catch, will resend.

  Luis
