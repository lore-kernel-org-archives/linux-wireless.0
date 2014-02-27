Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ve0-f170.google.com ([209.85.128.170]:55922 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114AbaB0RVe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Feb 2014 12:21:34 -0500
Received: by mail-ve0-f170.google.com with SMTP id pa12so2562172veb.15
        for <linux-wireless@vger.kernel.org>; Thu, 27 Feb 2014 09:21:33 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1393519539.4648.10.camel@jlt4.sipsolutions.net>
References: <CAOAOC6a96e5MrEOVY=KXirhUU-rJRv2hgz5B0so9SkWYMpoDfw@mail.gmail.com>
	<1393517094.4648.3.camel@jlt4.sipsolutions.net>
	<CAOAOC6agHr6mVB2jcUx1qHWnBJZyOw0=KP0Wp5BVhrvJgRhmQg@mail.gmail.com>
	<1393517627.4648.4.camel@jlt4.sipsolutions.net>
	<CAOAOC6ZhnB=LrJWvG07tOK=b_wWAFO74YdhXWZPxrVCk8=425A@mail.gmail.com>
	<CAOAOC6aoz43LdXBTcRHWqPMvQAVKsH6z4yNqe_hEpT7zouo+Ew@mail.gmail.com>
	<1393519119.4648.7.camel@jlt4.sipsolutions.net>
	<CAOAOC6Z5J8_-ZKVukxfz+_K402E5sjhTdBvf3TzsWUDgwqw0Zw@mail.gmail.com>
	<1393519539.4648.10.camel@jlt4.sipsolutions.net>
Date: Thu, 27 Feb 2014 12:21:33 -0500
Message-ID: <CAOAOC6aWWh3y8b-iRsouxFV+d9oKSpL4hkeVyJ6sarGEVzyOdg@mail.gmail.com> (sfid-20140227_182136_879964_5BE552C8)
Subject: Re: pci-half-mini 7260 Wireless AC support 3.13
From: Tim Nelson <tim.l.nelson@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I see nothing at all in my dmesg when I connect to it.  As well,
running Ubuntu, I do not have a wpa_supplicant.log.

It's not that it errors at all, in fact it works quite well.  The
problem lies with the fact it's not actually doing AC.  Although it is
doing very well with N.

On Thu, Feb 27, 2014 at 11:45 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2014-02-27 at 11:41 -0500, Tim Nelson wrote:
>> [    9.299536] iwlwifi 0000:02:00.0: Detected Intel(R) Dual Band
>> Wireless AC 7260, REV=0x144
>
> Hm ok that should support it. Maybe it's always connecting to the 2.4
> GHz one for some reason? That seems unlikely but still possible...
>
> Maybe you could get more dmesg data about the AP it selected, and the
> wpa_supplicant log.
>
> johannes
>
