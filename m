Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f198.google.com ([209.85.211.198]:53803 "EHLO
	mail-yw0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751972Ab0ENJbA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 May 2010 05:31:00 -0400
Received: by ywh36 with SMTP id 36so1083349ywh.4
        for <linux-wireless@vger.kernel.org>; Fri, 14 May 2010 02:30:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1273825421.6318.98.camel@powerslave>
References: <1273743804-11587-1-git-send-email-ohad@wizery.com>
	<1273825421.6318.98.camel@powerslave>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Fri, 14 May 2010 12:30:39 +0300
Message-ID: <AANLkTikxmd7nS-9lVh-JMYVjgVene4E1YdllWx0yZv8U@mail.gmail.com>
Subject: Re: [PATCH] wl1271: remove sdio ARM dependency
To: Luciano Coelho <luciano.coelho@nokia.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Luciano,

On Fri, May 14, 2010 at 11:23 AM, Luciano Coelho
<luciano.coelho@nokia.com> wrote:
> On Thu, 2010-05-13 at 11:43 +0200, ext Ohad Ben-Cohen wrote:
>> Make it possible to use wl1271's SDIO interface on non-ARM platforms.
>>
>> Fully tested on a x86 platform, compile-tested on ARM.
>>
>> Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
>> ---
>
> Acked-by: Luciano Coelho <luciano.coelho@nokia.com>
>
> One question, what wl1271 card are you using on an x86 platform?

It's an embedded x86 platform with a specially made wl1271 card.
Not something that is widely available..

Thanks,
Ohad.

>
> --
> Cheers,
> Luca.
>
>
