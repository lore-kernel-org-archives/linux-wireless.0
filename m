Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f41.google.com ([209.85.219.41]:55117 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754741AbaAFLhz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jan 2014 06:37:55 -0500
Received: by mail-oa0-f41.google.com with SMTP id j17so19022764oag.0
        for <linux-wireless@vger.kernel.org>; Mon, 06 Jan 2014 03:37:55 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1389007385.5891.9.camel@jlt4.sipsolutions.net>
References: <CA+V6dmh7Udn96GG0XGaabx-t6ZViu1RGk-xTawa_KbnCdro9Ew@mail.gmail.com>
 <1389007385.5891.9.camel@jlt4.sipsolutions.net>
From: Pierre Bourdon <delroth@gmail.com>
Date: Mon, 6 Jan 2014 12:37:34 +0100
Message-ID: <CA+V6dmjoLx90vEwGZa8vRNHp0yWqKQnae+GcvEZHsCxR-oHnhg@mail.gmail.com> (sfid-20140106_123801_484928_5CA66591)
Subject: Re: Exporting the TSF to userland
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 6, 2014 at 12:23 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 2013-12-31 at 05:24 +0100, Pierre Bourdon wrote:
>> Hello linux-wireless,
>>
>> I'm a developer of libdrc, a project that allows Linux computers to
>> control a Wii U GamePad. Because of how the device operates, our
>> library needs to be able to read the TSF value of the access point
>> device from userland.
>>
>> We currently have a hacky patch that works for our use cases, but it
>> would be a lot more convenient if that feature could be upstreamed.
>> What would be the best way to proceed?
>
> That patch ... let's say I think "hacky" is almost lauding it. :)
>
> sysfs is a really bad place for this too, no other wireless APIs use
> sysfs.

What do you recommend as the best place to export this kind of information?

-- 
Pierre "delroth" Bourdon <delroth@gmail.com>
Software Engineer @ Zürich, Switzerland
http://code.delroth.net/
