Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:36656 "EHLO
        mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752831AbeDLTB1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 12 Apr 2018 15:01:27 -0400
Received: by mail-wm0-f52.google.com with SMTP id x82so216373wmg.1
        for <linux-wireless@vger.kernel.org>; Thu, 12 Apr 2018 12:01:26 -0700 (PDT)
Subject: Re: second wifi card enforce CN reg dom
To: Dan Williams <dcbw@redhat.com>, Steve deRosier <derosier@gmail.com>
References: <CAE4vF2fCTEmEX8i+XVpvTJ1sRYDHDLr+fYFAM2PzTQTqkCoXVQ@mail.gmail.com>
 <CAE4vF2f2oXEvOJWDXPjmiWZTC=HOq5+xE_R64-_VvH6zc-Vw+A@mail.gmail.com>
 <5ACF0F5A.3090301@broadcom.com>
 <CAE4vF2ftgMPhKEUHr2rPaobM9Dtuc-B9rtbF5tWavvrwUXA7Ag@mail.gmail.com>
 <5ACF3A28.4060303@broadcom.com>
 <CALLGbRLJLxu92S2bYFOk9oJCLanES4Fu6e-9bh9oAupEC0Uw5w@mail.gmail.com>
 <1517ecac1d85eb746367d9db436beca2d8f47835.camel@redhat.com>
Cc: solsTiCe d'Hiver <solstice.dhiver@gmail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5ACFAD04.10908@broadcom.com> (sfid-20180412_210130_911089_89551300)
Date: Thu, 12 Apr 2018 21:01:24 +0200
MIME-Version: 1.0
In-Reply-To: <1517ecac1d85eb746367d9db436beca2d8f47835.camel@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 4/12/2018 5:52 PM, Dan Williams wrote:
> On Thu, 2018-04-12 at 08:18 -0700, Steve deRosier wrote:
>> On Thu, Apr 12, 2018 at 3:51 AM, Arend van Spriel
>> <arend.vanspriel@broadcom.com> wrote:
>>> On 4/12/2018 10:42 AM, solsTiCe d'Hiver wrote:
>>>>
>>>> Hi.
>>>>
>>>> This is beyond my comprehension that you could assert this is a
>>>> non issue.
>>>
>>>
>>> Well. I am just saying that it is by design. There is no way for
>>> the
>>> regulatory code to determine where you and your hardware actually
>>> reside so
>>> instead it takes a conservative approach.
>>>
>>
>> To say it another way: mixing regulatory domains on your host system
>> should result in a _smaller_ set of channels - ie only those channels
>> at the intersection of the two.
>>
>> And another wrinkle to consider - one of the 802.11 amendments (can't
>> remember which one) actually causes the radio to listen to the
>
> 802.11d I believe, from the early 2000s.

Correct.

Regards,
Arend
