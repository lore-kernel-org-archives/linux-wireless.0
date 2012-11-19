Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f46.google.com ([209.85.219.46]:45184 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753859Ab2KSRsr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Nov 2012 12:48:47 -0500
Received: by mail-oa0-f46.google.com with SMTP id h16so5070518oag.19
        for <linux-wireless@vger.kernel.org>; Mon, 19 Nov 2012 09:48:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1353346581.10872.117.camel@cumari.coelho.fi>
References: <1353343170-26516-1-git-send-email-eliad@wizery.com>
	<1353343170-26516-9-git-send-email-eliad@wizery.com>
	<1353344601.18299.31.camel@jlt4.sipsolutions.net>
	<CAB3XZEepFkTNZMAzB+Jy9R4wSzAyQuNVHdWcdHMoRN+FRe5=9A@mail.gmail.com>
	<1353346581.10872.117.camel@cumari.coelho.fi>
Date: Mon, 19 Nov 2012 19:48:46 +0200
Message-ID: <CAB3XZEdniop27NjoCR6KcD4Cp_r=OUU1=tuB1xk2gASs0CW6iw@mail.gmail.com> (sfid-20121119_184851_787839_619082C0)
Subject: Re: [PATCH 08/15] wlcore: add chanctx implementation
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 19, 2012 at 7:36 PM, Luciano Coelho <coelho@ti.com> wrote:
> On Mon, 2012-11-19 at 19:16 +0200, Eliad Peller wrote:
>> On Mon, Nov 19, 2012 at 7:03 PM, Johannes Berg
>> <johannes@sipsolutions.net> wrote:
>> > On Mon, 2012-11-19 at 18:39 +0200, Eliad Peller wrote:
>> >> Add some basic chanctx implementation.
>> >
>> > This patch will leave the driver in a broken state, and in fact probably
>> > crashing trying to use hw.conf.channel.
>> >
>> you are right. i'm taking care of these in the following patches.
>> i preferred splitting the patches for clarity instead of squashing
>> them all into one big patch (removing hw.conf.channel references
>> before implementing chanctx will break the driver as well).
>> i guess i can squash them in this case, but i'm not sure it will
>> really help, as other intermediate patches in this patchset might
>> still break some functionality of the driver.
>>
>> i don't mind either way. whatever Luca will prefer :)
>> (maybe keeping it that way for review, and only squashing them on apply?)
>
> I prefer if we can do it so that the driver is not broken, to make it
> easier to bisect.  But I also agree that for review, it's better to have
> split up patches.
>
> So, your suggestion sounds good to me.  Maybe you could send a final
> squashed patchset when they're reviewed and ready to be applied?
>
sure.

Eliad.
