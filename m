Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f180.google.com ([209.85.223.180]:57328 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932215AbaAWOt7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jan 2014 09:49:59 -0500
Received: by mail-ie0-f180.google.com with SMTP id at1so1218478iec.11
        for <linux-wireless@vger.kernel.org>; Thu, 23 Jan 2014 06:49:58 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1390478759.4189.91.camel@porter.coelho.fi>
References: <CAKKnJbdK1eJJoFZik1SENg1PtnqMsK=B4mEtoausGybKNywSqw@mail.gmail.com>
	<1390478759.4189.91.camel@porter.coelho.fi>
Date: Thu, 23 Jan 2014 09:49:58 -0500
Message-ID: <CAKKnJbd+HDOuOkK63NskHaaYtAvj9WUwpCutJ_YvoPpQhkhPYw@mail.gmail.com> (sfid-20140123_155016_666558_792868BB)
Subject: Re: wl12xx force lower bitrate
From: Charles <hobbesc7@gmail.com>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>> I'm using the wl12xx-spi driver with a TI wl1271 chipset.  In my
>> application, range is more important than throughput, so I want to
>> force a lower bitrate (like 802.11b speeds at the fastest.)
>>
>> None of the commands for doing this seem to have any effect, however.
>> I've tried both iwconfig and iw.
>>
>> Is forcing a lower bitrate possible with this driver / firmware / chipset?
>
> Rate control should do this automatically.  If you have good signal
> conditions, it will use the highest possible rate.  If things start to
> degrade (as if you get further away from the AP), the rate will drop.
>

I know about automatic rate control.  But in our experience, 802.11b
adapters perform better at the margins (of range), possibly because
their rate is not jumping around as much.  I know there is allowance
within iwconfig and iw for fixing bitrate, but I have yet to find an
adapter/driver where this functionality works.
