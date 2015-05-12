Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:36761 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932209AbbELIAe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 May 2015 04:00:34 -0400
Received: by pabsx10 with SMTP id sx10so138323328pab.3
        for <linux-wireless@vger.kernel.org>; Tue, 12 May 2015 01:00:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAB3XZEd6GbsQfs7EZxvrea7hxJjbqnVuHO5pQc3gZCmG-0V8sw@mail.gmail.com>
References: <CAGm1_ktjoyQp_sebmPrG__4kgmW-EnR16tv6rd2sPECD8uFrtQ@mail.gmail.com>
 <CAB3XZEd6GbsQfs7EZxvrea7hxJjbqnVuHO5pQc3gZCmG-0V8sw@mail.gmail.com>
From: Yegor Yefremov <yegorslists@googlemail.com>
Date: Tue, 12 May 2015 10:00:13 +0200
Message-ID: <CAGm1_ktaxy1yLxwv55oNzRhfWh3mdBfDHJOCcGZYbVn5Tox=pA@mail.gmail.com> (sfid-20150512_100037_642967_D7DBAF1F)
Subject: Re: wlcore: mac-address property support
To: Eliad Peller <eliad@wizery.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 12, 2015 at 9:53 AM, Eliad Peller <eliad@wizery.com> wrote:
> hi,
>
> On Tue, May 12, 2015 at 9:37 AM, Yegor Yefremov
> <yegorslists@googlemail.com> wrote:
>> Does wlcore support "mac-address" property, so that MAC address could
>> be set via Device Tree?
>>
> it's currently not supported.
> (by default the address is read from the fuse ROM, and it can be
> overridden by the nvs file)

It's not very practical for us as our chips don't have internal EEPROM
and nvs file is also bad, as it is SD card bound. We have all our
production data in usual EEPROM, so that I can fetch MACs from there
and put them into loaded DTB. This way Linux has all the needed data
and I don't need special files/scripts in order to assign MACs.

Yegor
