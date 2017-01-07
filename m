Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:35209 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935166AbdAGMxF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 7 Jan 2017 07:53:05 -0500
MIME-Version: 1.0
In-Reply-To: <1483707597.12677.0.camel@sipsolutions.net>
References: <20170104175832.25996-1-zajec5@gmail.com> <CAL_JsqLg5YkC-YUHg6mQ35nmGaG7SC33VJB++fgtZsu1fRV-7Q@mail.gmail.com>
 <1483617089.4394.13.camel@sipsolutions.net> <CAL_JsqKYpTZFRJpPR1V9MmA-JW5ntoKzbkjwnYBp9HMWLObG3A@mail.gmail.com>
 <1483707597.12677.0.camel@sipsolutions.net>
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Date: Sat, 7 Jan 2017 13:53:04 +0100
Message-ID: <CACna6rzyd3cRMNBTLqCX8-8PYCAvkW1pSq_AF=LAmkL8ccv2NQ@mail.gmail.com> (sfid-20170107_135308_822131_67BDF55A)
Subject: Re: [PATCH V6 1/3] dt-bindings: document common IEEE 802.11 frequency
 limit property
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Rob Herring <robh+dt@kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Felix Fietkau <nbd@nbd.name>,
        Arend van Spriel <arend@broadcom.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 6 January 2017 at 13:59, Johannes Berg <johannes@sipsolutions.net> wrote=
:
> On Thu, 2017-01-05 at 10:34 -0600, Rob Herring wrote:
>> On Thu, Jan 5, 2017 at 5:51 AM, Johannes Berg <johannes@sipsolutions.
>> net> wrote:
>> >
>> > > Acked-by: Rob Herring <robh@kernel.org>
>> >
>> > Do I take that to mean that we'll merge it through the subsystem
>> > tree,
>> > and not go through some common DT tree?
>>
>> Yes, that's generally the case when bindings are in a series with
>> driver changes.
>
> Alright, thanks.
>
> I've applied patches 1-3, patch 4 obviously still needs work (and
> probably won't go through my tree anyway.)
>
> Note that I made some documentation fixes in patch 3, Rafa=C5=82, please
> check.

Looks great, thanks everyone for your help on getting this patchset in shap=
e!

--=20
Rafa=C5=82
