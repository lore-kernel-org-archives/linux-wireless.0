Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:38949 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756233Ab0JZLeH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Oct 2010 07:34:07 -0400
Received: by qwk3 with SMTP id 3so2442344qwk.19
        for <linux-wireless@vger.kernel.org>; Tue, 26 Oct 2010 04:34:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201010261204.01481.helmut.schaa@googlemail.com>
References: <DA0C92FD-F6BF-4746-9BE1-A643A0D70F7A@kaon.com>
	<201010261135.31232.helmut.schaa@googlemail.com>
	<1288086094.3761.6.camel@jlt3.sipsolutions.net>
	<201010261204.01481.helmut.schaa@googlemail.com>
Date: Tue, 26 Oct 2010 13:34:06 +0200
Message-ID: <AANLkTimrw_UFa-K7um59+E_MkuCUYBRahs=qJVfAW-g8@mail.gmail.com>
Subject: Re: Question about starting up an AP
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Joshua Smith <JoshuaESmith@charter.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	users@rt2x00.serialmonkey.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 26, 2010 at 12:04 PM, Helmut Schaa
<helmut.schaa@googlemail.com> wrote:
> Am Dienstag 26 Oktober 2010 schrieb Johannes Berg:
>> On Tue, 2010-10-26 at 11:35 +0200, Helmut Schaa wrote:
>>
>> > > I'll let Ivo decide on this. At least if we really want to wait more then one
>> > > second for DMA to be ready we should increase the msleep(1) to msleep(10) and
>> > > keep the maximum number of retries at 100.
>>
>> > Ivo, do we want to add the excessive waiting (up to one second) for DMA on
>> > rt2800 as it fixes Joshuas device? At the moment we're waiting 100ms.
>>
>> I don't usually chime in on other drivers but is there any reason not
>> to? Properly functioning devices obviously reply within 100ms, so they
>> wouldn't change behaviour, hopefully broken ones that _never_ work are
>> rare, and the remaining ones like Joshua's would be fixed ...
>
> True, nevertheless I wanted to get Ivos ack before going ahead.

yeah, I don't mind waiting for a full second, on my machine a normal
ifconfig up takes already ages for some odd reason, so another second wouldn't
matter if that means that more devices can function. :)

Ivo
