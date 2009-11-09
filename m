Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f180.google.com ([209.85.223.180]:45892 "EHLO
	mail-iw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688AbZKITtq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Nov 2009 14:49:46 -0500
Received: by iwn10 with SMTP id 10so2653510iwn.4
        for <linux-wireless@vger.kernel.org>; Mon, 09 Nov 2009 11:49:52 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <fd145f7d0911091052m187aad9dh6c03f593a2580067@mail.gmail.com>
References: <4AF6C7CD.7060108@web.de> <878wehf85v.fsf@purkki.valot.fi>
	<4AF6CC02.8080204@web.de> <m3639k9kq4.wl%holgerschurig@gmail.com>
	<87ocncdrfz.fsf@purkki.valot.fi> <fd145f7d0911091052m187aad9dh6c03f593a2580067@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 9 Nov 2009 11:49:32 -0800
Message-ID: <43e72e890911091149nb644643uf6b87291f36914eb@mail.gmail.com>
Subject: Re: ar9170 in AP mode
To: Jeffrey Baker <jwbaker@gmail.com>
Cc: Kalle Valo <kalle.valo@iki.fi>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 9, 2009 at 10:52 AM, Jeffrey Baker <jwbaker@gmail.com> wrote:
> On Mon, Nov 9, 2009 at 12:37 AM, Kalle Valo <kalle.valo@iki.fi> wrote:
>> Holger Schurig <holgerschurig@googlemail.com> writes:
>>
>>>> How common is the combination of powersaving and mcast in practice?
>>>> Given that quite a few useful scenarios are blocked right now (unless
>>>> you know what to patch), I would at least vote for a config option or a
>>>> module parameter. That gives a chance to warn the user about this
>>>> limitation without locking out people that are no hackers.
>>>
>>> In my case (hand-help devices) it's very common. Without power-save,
>>> the battery would be drained so fast it wouldn't be usable.
>>
>> Yes, just to give a concrete example of n810 wlan idle case
>> (associated, but no data transfered):
>>
>> ps off  7 hours
>> ps on   7 days
>>
>> Huge difference.
>>
>>> And with power-save and an AP that can't handle this, you'd get
>>> weird errors.
>>
>> Exactly. These kinds of errors are very difficult for the users to
>> understand.
>>
>>> So, I personally prefer to have "Do an AP right" or "Don't do it at
>>> all". But please no general enablement.
>>>
>>> But, for example, having some CONFIG_AR9K_AP_MODE depending on
>>> CONFIG_EXPERIMENTAL and a bit fat warning would do for me. Hopefully
>>> this would scara away distros, so that they don't turn this on for
>>> there standard kernel :-)
>>
>> I think EXPERIMENTAL is not enough, I would prefer that the user needs
>> to patch the driver to enable it. Or if that's not good enough, then
>> maybe depend on BROKEN.
>
> Is this broken on all ar9k or just the 9170?

Just ar9170.

  Luis
