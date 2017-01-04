Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:58350 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936375AbdADOdn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 4 Jan 2017 09:33:43 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: Rob Herring <robh@kernel.org>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Felix Fietkau <nbd@nbd.name>, Arnd Bergmann <arnd@arndb.de>,
        "devicetree\@vger.kernel.org" <devicetree@vger.kernel.org>,
        =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: Re: [PATCH 1/2] dt-bindings: document common IEEE 802.11 frequency properties
References: <20161228155955.25518-1-zajec5@gmail.com>
        <20170103195514.vf4psb6qw2bd2lcw@rob-hp-laptop>
        <CACna6rxmgN2zz-Fc1-Uu02oqMQreNkMJt0jGjLOMrXM=6iujFw@mail.gmail.com>
Date: Wed, 04 Jan 2017 16:32:44 +0200
In-Reply-To: <CACna6rxmgN2zz-Fc1-Uu02oqMQreNkMJt0jGjLOMrXM=6iujFw@mail.gmail.com>
        (=?utf-8?Q?=22Rafa=C5=82_Mi=C5=82ecki=22's?= message of "Tue, 3 Jan 2017
 21:20:49 +0100")
Message-ID: <874m1ej3oz.fsf@kamboji.qca.qualcomm.com> (sfid-20170104_153724_409612_F9D125CC)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com> writes:

> On 3 January 2017 at 20:55, Rob Herring <robh@kernel.org> wrote:
>> On Wed, Dec 28, 2016 at 04:59:54PM +0100, Rafa=C5=82 Mi=C5=82ecki wrote:
>>> From: Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl>
>>>
>>> This new file should be used for properties handled at higher level and
>>> so usable with all drivers.
>>
>> Why is this needed? Where would this data normally come from?
>
> Vendors limit choice of channels at their web user interface level. I
> want to do better and report proper channels directly at kernel level
> instead of masking them in every possible configuration tool.

Why do vendors limit the channels? Is it because of a hardware
limitation (antenna does not support, or not calibrated, for a certain
band etc) or something else?

--=20
Kalle Valo
