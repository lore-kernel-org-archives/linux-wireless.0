Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:35005 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755588Ab1BXQBj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Feb 2011 11:01:39 -0500
Received: by qwd7 with SMTP id 7so531606qwd.19
        for <linux-wireless@vger.kernel.org>; Thu, 24 Feb 2011 08:01:39 -0800 (PST)
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <1298563114.4251.3.camel@jlt3.sipsolutions.net>
References: <1298554926.4775.4.camel@jlt3.sipsolutions.net>
	<AANLkTi=sRXPy8tmc4QYDQZfC-CqhGZpKpNeOR6b+OhhQ@mail.gmail.com>
	<1298563114.4251.3.camel@jlt3.sipsolutions.net>
Date: Thu, 24 Feb 2011 17:01:38 +0100
Message-ID: <AANLkTimaFrGObYC2x-XRo4waQKocLjZ34QYWDzLknAi7@mail.gmail.com>
Subject: Re: [PATCH] mac80211: make tx() operation return void
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 24, 2011 at 4:58 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2011-02-24 at 16:56 +0100, Sedat Dilek wrote:
>> On Thu, Feb 24, 2011 at 2:42 PM, Johannes Berg
>
>> Will this patch go into 2.6.39?
>> I have modified it as a v2 to fit latest linux-next ("apply-tested").
>
> Presumably. I'd based it on wireless-testing, but why did you use
> linux-next rather than wireless-next? What's the difference anyway?
>
> johannes
>

IIRC current linux-next and wireless-next don't differ, so it doesn't
matter :-).
I have removed only the drivers/staging/brcm80211/sys/wl_mac80211.c
part as it does not exist in -next.

- Sedat -
