Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:52019 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751931Ab3KLIZF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Nov 2013 03:25:05 -0500
Received: by mail-wi0-f170.google.com with SMTP id m19so3385297wiv.1
        for <linux-wireless@vger.kernel.org>; Tue, 12 Nov 2013 00:25:04 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <87d2m6rqut.fsf@purkki.adurom.net>
References: <CADNhdGHGnHDYdum79cY89kV4LtpiGugMc84Mc_4bNmCuOWrn5g@mail.gmail.com>
	<87d2m6rqut.fsf@purkki.adurom.net>
Date: Tue, 12 Nov 2013 13:55:03 +0530
Message-ID: <CADNhdGEJJ3vjtX+tJAGs78-tGZgS0ivqvXJPGqzaV9mWFAY=dQ@mail.gmail.com> (sfid-20131112_092510_354131_850D9334)
Subject: Re: [mac80211] hooking all 802.11 packets to user space without conversion
From: shankar swaminathan <shankswa@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

No. I am trying to build an AP. Hence, the interface is in AP mode.
Can an interface be put in both AP and Monitor so that i just have one
interface which i can use to get packets in user space in 802.11
format?

Some form of netfilter for wifi packets would help.

On Tue, Nov 12, 2013 at 1:31 PM, Kalle Valo <kvalo@adurom.com> wrote:
> shankar swaminathan <shankswa@gmail.com> writes:
>
>> I would like to know if 802.11 packets could be hooked from the mac80211
>> module to the user space.
>>
>> Basically, I run a module that needs the 802.11 pkts without converting
>> them to 802.3.
>>
>> I am able to register for MLME pkts but not sure whether I can register for
>> data pkts and get them to user space.
>
> Have you tried adding a monitor interface and taking packets from that?
>
> --
> Kalle Valo
