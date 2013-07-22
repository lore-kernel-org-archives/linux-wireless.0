Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:36290 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932521Ab3GVRf2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Jul 2013 13:35:28 -0400
Received: by mail-wi0-f177.google.com with SMTP id ey16so2190329wid.10
        for <linux-wireless@vger.kernel.org>; Mon, 22 Jul 2013 10:35:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1374504059.14517.12.camel@jlt4.sipsolutions.net>
References: <CAJ-Vmo=yvHUgv6pwK42n+NhPrAu9shxc5pigRkhZE+x91W_FoA@mail.gmail.com>
	<1374504059.14517.12.camel@jlt4.sipsolutions.net>
Date: Mon, 22 Jul 2013 10:35:27 -0700
Message-ID: <CAJ-VmokHRAUsL7XEeM8HUNt2WEtj-G8o8uXM2=cQ2moaTbKe4w@mail.gmail.com> (sfid-20130722_193532_647343_65F32A0A)
Subject: Re: So, which IEEE<->Frequency mappings should we be all using?
From: Adrian Chadd <adrian@freebsd.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: freebsd-wireless@freebsd.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Well, the UHF stuff is available now and vendors are making cards for
them. I'm happy just mapping them to 2.4GHz channels for now but it
severely restricts the channels (ie, spacing/width) we can use in that
range.



adrian

On 22 July 2013 07:40, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Wed, 2013-07-17 at 10:42 -0700, Adrian Chadd wrote:
>
>> * 420MHz
>> * 700MHz
>> * 900MHz (which we already have, due to history);
>> * 3.6GHz
>> * 4.9GHz
>
> 3.6 should have been defined in the spec recently, 4.9 surely is defined
> already (though the whole stack will have to support the
> dot11ChannelStartingFactor)
>
> The others are kinda non-standard extensions, and you probably won't
> even be able to properly support them since they're kinda
> pretend-handled like 2.4 GHz.
>
> johannes
>
