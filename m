Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f169.google.com ([209.85.218.169]:40891 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751653AbZCaJlQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Mar 2009 05:41:16 -0400
Received: by bwz17 with SMTP id 17so2273001bwz.37
        for <linux-wireless@vger.kernel.org>; Tue, 31 Mar 2009 02:41:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <8e92b4100903302354x66276239m48a14f2182d959c7@mail.gmail.com>
References: <2da21fe50903270727m7b7007ctaa846aea61902436@mail.gmail.com>
	<87ljqr58oa.fsf@litku.valot.fi> <2da21fe50903271208m1c369c88lba8399416dace43a@mail.gmail.com>
	<8e92b4100903300238p4b0cbd3fh754a3dddbf904fa7@mail.gmail.com>
	<2da21fe50903300631o39779ac9ge42252fd4697dce@mail.gmail.com>
	<8e92b4100903302354x66276239m48a14f2182d959c7@mail.gmail.com>
Date: Tue, 31 Mar 2009 11:40:57 +0200
Message-ID: <2da21fe50903310240m2f18adf2ma23f095be397a9ea@mail.gmail.com> (sfid-20090331_114121_891714_B4A6F242)
Subject: Re: ath9k and power management
From: Davide Pesavento <davidepesa@gmail.com>
To: Vivek Natarajan <vivek.natraj@gmail.com>
Cc: Kalle Valo <kalle.valo@iki.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>, mcgrof@gmail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 31, 2009 at 08:54, Vivek Natarajan <vivek.natraj@gmail.com> wrote:
> On Mon, Mar 30, 2009 at 7:01 PM, Davide Pesavento <davidepesa@gmail.com> wrote:
>> On Mon, Mar 30, 2009 at 11:38, Vivek Natarajan <vivek.natraj@gmail.com> wrote:
>>>
>>> ath9k: No need to abort Rx path when autosleep is enabled.
>>>
>>> For chipsets supporting autosleep feature, there is no need to abort
>>> Rx engine since they are capable of automatically going back to sleep
>>> after receiving a packet.
>>
>> I've applied your patch but unfortunately the behaviour is still the
>> same as before.
>
> One more patch sent:
> ath9k: Disable autosleep feature for AR9285 based chipsets.
>
> I hope you are using one of the AR9285 based. I have unit tested and it seems to
> work consistently now.
>

No, I'm not. Sorry for not reporting the hardware type earlier. My
card is identified as:
phy0: Atheros AR5418 MAC/BB Rev:2 AR5133 RF Rev:81:
mem=0xffffc20005020000, irq=17

Thanks,
Davide
