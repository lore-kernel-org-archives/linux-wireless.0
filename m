Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f171.google.com ([209.85.223.171]:41005 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752042Ab3IKHss (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Sep 2013 03:48:48 -0400
Received: by mail-ie0-f171.google.com with SMTP id 16so7335339iea.16
        for <linux-wireless@vger.kernel.org>; Wed, 11 Sep 2013 00:48:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1378799431.4799.63.camel@porter.coelho.fi>
References: <1378218848-7853-1-git-send-email-eliad@wizery.com>
	<1378218848-7853-12-git-send-email-eliad@wizery.com>
	<1378799431.4799.63.camel@porter.coelho.fi>
Date: Wed, 11 Sep 2013 09:48:46 +0200
Message-ID: <CAB3XZEeer+NTKwWc5GkjZQdswSkPfsGhinvpcK2BbarqjCeA5A@mail.gmail.com> (sfid-20130911_094851_857786_5ED44F0B)
Subject: Re: [PATCH 12/12] wlcore: always register dummy hardirq
From: Eliad Peller <eliad@wizery.com>
To: Luca Coelho <luca@coelho.fi>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 10, 2013 at 10:50 AM, Luca Coelho <luca@coelho.fi> wrote:
> On Tue, 2013-09-03 at 17:34 +0300, Eliad Peller wrote:
>> From: Arik Nemtsov <arik@wizery.com>
>>
>> This keeps the kernel happy when using edge-irqs and requesting a
>> threaded irq.
>>
>> Signed-off-by: Arik Nemtsov <arik@wizery.com>
>> Signed-off-by: Eliad Peller <eliad@wizery.com>
>> ---
>
> Ouch, I think this is not going to fit at all with the DT patches I
> sent.
>
this is quite minor patch (only making sure we always define hardirq
when threaded_irq is used. i don't think it should conflict (at least
logically) with DT patches...

Eliad.
