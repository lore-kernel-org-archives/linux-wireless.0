Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f179.google.com ([209.85.216.179]:33415 "EHLO
        mail-qt0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936193AbdADUBY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 4 Jan 2017 15:01:24 -0500
Received: by mail-qt0-f179.google.com with SMTP id v23so32360560qtb.0
        for <linux-wireless@vger.kernel.org>; Wed, 04 Jan 2017 12:01:05 -0800 (PST)
Subject: Re: [PATCH 1/2] dt-bindings: document common IEEE 802.11 frequency
 properties
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>
References: <20161228155955.25518-1-zajec5@gmail.com>
 <20170103195514.vf4psb6qw2bd2lcw@rob-hp-laptop>
 <CACna6rxmgN2zz-Fc1-Uu02oqMQreNkMJt0jGjLOMrXM=6iujFw@mail.gmail.com>
 <874m1ej3oz.fsf@kamboji.qca.qualcomm.com>
 <CACna6rxx-8499ZQKekdORF0UWQQazwGu2On1aq-fwA4oCX7pgw@mail.gmail.com>
Cc: Rob Herring <robh@kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Felix Fietkau <nbd@nbd.name>, Arnd Bergmann <arnd@arndb.de>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <fec0dffd-5c9f-0d9d-a458-464d81952ce0@broadcom.com> (sfid-20170104_210215_935349_2A83B155)
Date: Wed, 4 Jan 2017 20:53:07 +0100
MIME-Version: 1.0
In-Reply-To: <CACna6rxx-8499ZQKekdORF0UWQQazwGu2On1aq-fwA4oCX7pgw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 4-1-2017 15:53, Rafał Miłecki wrote:
> On 4 January 2017 at 15:32, Kalle Valo <kvalo@codeaurora.org> wrote:
>> Rafał Miłecki <zajec5@gmail.com> writes:
>>
>>> On 3 January 2017 at 20:55, Rob Herring <robh@kernel.org> wrote:
>>>> On Wed, Dec 28, 2016 at 04:59:54PM +0100, Rafał Miłecki wrote:
>>>>> From: Rafał Miłecki <rafal@milecki.pl>
>>>>>
>>>>> This new file should be used for properties handled at higher level and
>>>>> so usable with all drivers.
>>>>
>>>> Why is this needed? Where would this data normally come from?
>>>
>>> Vendors limit choice of channels at their web user interface level. I
>>> want to do better and report proper channels directly at kernel level
>>> instead of masking them in every possible configuration tool.
>>
>> Why do vendors limit the channels? Is it because of a hardware
>> limitation (antenna does not support, or not calibrated, for a certain
>> band etc) or something else?
> 
> Please review & comment on the latest version, currently V5:
> https://patchwork.kernel.org/patch/9495795/
> "This can be used to specify extra hardware limitations caused by e.g.
> used antennas or power amplifiers."

Just to be clear, it is does not need to be a hardware limitation, but
simply a way to assure that multiple wlan radios are not interfering
with each other and crank up the total bandwidth that vendors can put on
their box.

Regards,
Arend
