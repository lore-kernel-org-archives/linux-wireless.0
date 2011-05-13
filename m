Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:38970 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932423Ab1EMVPq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 May 2011 17:15:46 -0400
Received: by vxi39 with SMTP id 39so2128593vxi.19
        for <linux-wireless@vger.kernel.org>; Fri, 13 May 2011 14:15:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1305290751.3487.33.camel@jlt3.sipsolutions.net>
References: <BANLkTi=pupNh=LMO-OEK+BbfNkpJz0nUkw@mail.gmail.com>
	<20110513115030.GB5516@redhat.com>
	<1305287703.3487.16.camel@jlt3.sipsolutions.net>
	<20110513122235.GC5516@redhat.com>
	<1305289642.3487.18.camel@jlt3.sipsolutions.net>
	<20110513123913.GD5516@redhat.com>
	<1305290751.3487.33.camel@jlt3.sipsolutions.net>
Date: Fri, 13 May 2011 23:15:45 +0200
Message-ID: <BANLkTin741=RL4Q4Tsn6w8LOv45xALyqMQ@mail.gmail.com> (sfid-20110513_231602_779870_F58C930D)
Subject: Re: Setting my WiFi adhoc connection in power save mode
From: Jorge Miguel <jmiggal@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I am really glad I got all your answers. Thanks a lot. Now it is clear to me.
Jorge.



On 13 May 2011 14:45, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Fri, 2011-05-13 at 14:39 +0200, Stanislaw Gruszka wrote:
>
>> > I doubt it, iirc it was just some DMA issue that was discovered at some
>> > point and nobody could really pinpoint it. Those old devices stored some
>> > internal data into a host memory buffer, and reading them back sometimes
>> > corrupted them.
>>
>> Ok, so I will probably not try to reenable PS (as long someone clearly
>> state that it works in the past, and this is a regression).
>
> Well, problem is that it _did_ work for some people, since it seemed to
> depend on the platform. I don't remember all the details though.
>
>> Does this problem happen on both 4965 and 3945 ?
>
> I'm not sure on 3945. ISTR there was an issue, but I don't know if it
> was the same one.
>
> johannes
>
>
