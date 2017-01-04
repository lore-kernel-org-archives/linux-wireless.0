Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:35336 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759531AbdADOxk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 4 Jan 2017 09:53:40 -0500
MIME-Version: 1.0
In-Reply-To: <874m1ej3oz.fsf@kamboji.qca.qualcomm.com>
References: <20161228155955.25518-1-zajec5@gmail.com> <20170103195514.vf4psb6qw2bd2lcw@rob-hp-laptop>
 <CACna6rxmgN2zz-Fc1-Uu02oqMQreNkMJt0jGjLOMrXM=6iujFw@mail.gmail.com> <874m1ej3oz.fsf@kamboji.qca.qualcomm.com>
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Date: Wed, 4 Jan 2017 15:53:38 +0100
Message-ID: <CACna6rxx-8499ZQKekdORF0UWQQazwGu2On1aq-fwA4oCX7pgw@mail.gmail.com> (sfid-20170104_155503_093676_B033A2F9)
Subject: Re: [PATCH 1/2] dt-bindings: document common IEEE 802.11 frequency properties
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Rob Herring <robh@kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Felix Fietkau <nbd@nbd.name>, Arnd Bergmann <arnd@arndb.de>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 4 January 2017 at 15:32, Kalle Valo <kvalo@codeaurora.org> wrote:
> Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com> writes:
>
>> On 3 January 2017 at 20:55, Rob Herring <robh@kernel.org> wrote:
>>> On Wed, Dec 28, 2016 at 04:59:54PM +0100, Rafa=C5=82 Mi=C5=82ecki wrote=
:
>>>> From: Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl>
>>>>
>>>> This new file should be used for properties handled at higher level an=
d
>>>> so usable with all drivers.
>>>
>>> Why is this needed? Where would this data normally come from?
>>
>> Vendors limit choice of channels at their web user interface level. I
>> want to do better and report proper channels directly at kernel level
>> instead of masking them in every possible configuration tool.
>
> Why do vendors limit the channels? Is it because of a hardware
> limitation (antenna does not support, or not calibrated, for a certain
> band etc) or something else?

Please review & comment on the latest version, currently V5:
https://patchwork.kernel.org/patch/9495795/
"This can be used to specify extra hardware limitations caused by e.g.
used antennas or power amplifiers."

--=20
Rafa=C5=82
