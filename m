Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:33903 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750698Ab0IVVff convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Sep 2010 17:35:35 -0400
Received: by gyd8 with SMTP id 8so357148gyd.19
        for <linux-wireless@vger.kernel.org>; Wed, 22 Sep 2010 14:35:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTimfAdHOR7XeTxxPGWav1hWB6UKUJm5k2Zs6zcPc@mail.gmail.com>
References: <AANLkTik_68KKkQJ0N_BJFYRsv4L+iXa5V1+MQ=n-v=Y0@mail.gmail.com>
 <AANLkTiki=Ta-77MFJ-dnCs1iDu2f7OMXcnmeY3ht0Z7J@mail.gmail.com> <AANLkTimfAdHOR7XeTxxPGWav1hWB6UKUJm5k2Zs6zcPc@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 22 Sep 2010 14:35:14 -0700
Message-ID: <AANLkTi=LuTyMq8tRXuKJ5B70CSftR3VsaMQsuqSMgdqF@mail.gmail.com>
Subject: Re: Old Otus driver with WEP
To: Alberto Donato <alberto.donato@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 22, 2010 at 2:28 PM, Alberto Donato
<alberto.donato@gmail.com> wrote:
> On Wed, Sep 22, 2010 at 11:20 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
>> On Wed, Sep 22, 2010 at 1:38 PM, Alberto Donato
>> <alberto.donato@gmail.com> wrote:
>>> Hi all,
>>>  I'm using the old otus driver on a mips platform which is currently
>>> using a  2.6.18 kernel with a TP-Link TL-WN821N usb adapter.
>>
>> This driver is not supported, upgrade your kernel to something modern.
>>
>>  Luis
>>
>
> Hi Luis,
>  I know this is no longer supported, but my kernel is vendor-provided
> for an embedded system, so I can't upgrade freely to newer kernels
> supporting the new ar9170 driver.
>
> I'm just trying to know for sure if this driver does not support WEP
> or there is some problem with my current setup.

That driver is going to get removed now so no one cares about it.

  Luis
