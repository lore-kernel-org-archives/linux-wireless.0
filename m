Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f220.google.com ([209.85.220.220]:34611 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753060Ab0A3QOe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Jan 2010 11:14:34 -0500
Received: by fxm20 with SMTP id 20so2865048fxm.21
        for <linux-wireless@vger.kernel.org>; Sat, 30 Jan 2010 08:14:33 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1264867217.3546.186.camel@johannes.local>
References: <20100129122718.73a6c877@nehalam>
	 <1264866128.3546.185.camel@johannes.local>
	 <51058d551001300751r4a509e90i521c946dfe9dec4@mail.gmail.com>
	 <1264867217.3546.186.camel@johannes.local>
Date: Sat, 30 Jan 2010 10:14:32 -0600
Message-ID: <51058d551001300814y66d1d589uae15fa50086593b8@mail.gmail.com>
Subject: Re: Multiple SSID on same phy
From: Greg Oliver <oliver.greg@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jan 30, 2010 at 10:00 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> I suggest you go public with your reply so you can be flamed and taught
> wrong appropriately.

Sorry - this gmail inefficiency sometimes gets me...

BUT, please enlighten me when any of the 3 use cases would be
beneficial to anyone not trying to (or "inefficiently migrating") hack
into a network would occur.

-Greg

> On Sat, 2010-01-30 at 09:51 -0600, Greg Oliver wrote:
>> On Sat, Jan 30, 2010 at 9:42 AM, Johannes Berg
>> <johannes@sipsolutions.net> wrote:
>> > On Fri, 2010-01-29 at 12:27 -0800, Stephen Hemminger wrote:
>> >> What are the restrictions (on ath9k) for multiple SSID with hostap
>> >> on same physical device. Should/will the following work:
>> >>
>> >> 1. Duplicate SSID's (different channels)
>> >
>> > Not really/well, wouldn't go there right now.
>> >
>> >> 2. Same channel but different SSID
>> >
>> > Yes.
>> >
>> >> 3. Duplicate SSID, same channel, but different encryption method
>> >
>> > "Duplicate SSID"? If you mean the same SSID and different encryption, I
>> > don't think that's supported. If you just meant two SSIDs with different
>> > encryption, that's doable by using two (B)SSIDs.
>> >
>>
>> There's no really honest use case for any of the examples presented.
>> "They" must want a head start on the next hackers conference..
>>
>
>
>
