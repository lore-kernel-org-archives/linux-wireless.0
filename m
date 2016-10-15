Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:63021 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750825AbcJOF3v (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 15 Oct 2016 01:29:51 -0400
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: Erik Stromdahl <erik.stromdahl@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [RFC 0/5] ath6kl: non WMI data service support
Date: Sat, 15 Oct 2016 05:29:45 +0000
Message-ID: <87bmym9o3a.fsf@kamboji.qca.qualcomm.com> (sfid-20161015_072955_656069_5191BAA6)
References: <1476376769-4708-1-git-send-email-erik.stromdahl@gmail.com>
        <87k2dbbczu.fsf@kamboji.qca.qualcomm.com>
        <ce941451-4d1c-4931-0f26-da52f5334f08@gmail.com>
In-Reply-To: <ce941451-4d1c-4931-0f26-da52f5334f08@gmail.com> (Erik
        Stromdahl's message of "Fri, 14 Oct 2016 17:54:27 +0200")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

(Adding ath10k list)

Erik Stromdahl <erik.stromdahl@gmail.com> writes:

> On 10/14/2016 09:34 AM, Valo, Kalle wrote:
>> Erik Stromdahl <erik.stromdahl@gmail.com> writes:
>>=20
>>> This patch series is intended to prepare the ath6kl driver
>>> for newer chipsets that doesn't use the current WMI data
>>> endpoints for data traffic.
>>>
>>> The chipset I have been working with (and used for testing)
>>> is QCA6584. It is SDIO based (at least the variant I have
>>> been using) with 802.11p WAVE DSRC capabilities.
>>>
>>> This chipset is different from the AR600X family in that
>>> it does not use the WMI data services (service id's 0x101
>>> to 0x104 ) for data traffic.
>>> Instead it uses the HTT data service for data and wmi unified
>>> for control messages.
>>> It is also different when it comes to mailbox addresses
>>> and HTC header format as well, but these differences are not
>>> part of this patch series.
>>=20
>> Do you have more patches implemented, like something already working or
>> have just started?
>>=20
>
> I have an implementation with all features I need so far, but the other
> patches will require cleanup before I can submit anything.
>
> I have been using the qcacld driver as a basis for the work and some of
> the stuff in that driver is not really compliant with the kernel coding
> style (to say the least).
>
> I have so far mainly been focused on getting all features up and running
> and that has (unfortunately) resulted in some copy-pasting from
> qcacld.

Can you share the current code you have somewhere so that I could take a
quick look? I don't care how ugly it is, I would just like to understand
what kind of changes are needed.

> I will start having a look at ath10k and see how much work it would be
> to add sdio support to it...

Thanks, let me know how it goes or if I can help somehow. My time is
limited but if nothing else I can give some tips.

--=20
Kalle Valo=
