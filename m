Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:56724 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755034Ab3EAPib (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 May 2013 11:38:31 -0400
Received: by mail-wi0-f171.google.com with SMTP id l13so5018965wie.16
        for <linux-wireless@vger.kernel.org>; Wed, 01 May 2013 08:38:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1835202.Vr0lTLYE3Q@linux-zd5t.site>
References: <d5546f49ab812cc89887b18b41d44da0@imap.force9.net>
	<2687000.szPz826eEU@linux-zd5t.site>
	<20854.23253.514263.467205@gargle.gargle.HOWL>
	<1835202.Vr0lTLYE3Q@linux-zd5t.site>
Date: Wed, 1 May 2013 08:38:29 -0700
Message-ID: <CAJ-Vmon9uK52yJDWCEpCwffnL90S0MVdZWdVGivLEymTWSrFtg@mail.gmail.com> (sfid-20130501_173840_902074_83E81956)
Subject: Re: ath9k problems on openSUSE 12.3
From: Adrian Chadd <adrian@freebsd.org>
To: Gerry Gavigan <gerry@gavigan.f9.co.uk>
Cc: Sujith Manoharan <sujith@msujith.org>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

.. what was the problem?




adrian

On 1 May 2013 01:35, Gerry Gavigan <gerry@gavigan.f9.co.uk> wrote:
> On Tuesday 23 Apr 2013 15:26:37 Sujith Manoharan wrote:
>> Gerry Gavigan wrote:
>> > - turned power save off
>> > - confirmed
>> > - shut down
>> > - restarted
>> > - power save is on
>> >
>> > problem persists
>>
>> Ok.
>>
>> Can you load the driver with more debugging options and post the kernel log
>> ? Please use the mask debug=0x8f49.
>
> I managed to identify what turned out to be the real problem.  It was nothing
> to do with the ath9k and everything to do with my router.
>
> I apologise for wasting your time but I am grateful that you bothered
>
> Gerry
>
>
>
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
