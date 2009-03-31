Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.172]:8667 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753154AbZCaGyF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Mar 2009 02:54:05 -0400
Received: by wf-out-1314.google.com with SMTP id 29so3015937wff.4
        for <linux-wireless@vger.kernel.org>; Mon, 30 Mar 2009 23:54:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <2da21fe50903300631o39779ac9ge42252fd4697dce@mail.gmail.com>
References: <2da21fe50903270727m7b7007ctaa846aea61902436@mail.gmail.com>
	 <87ljqr58oa.fsf@litku.valot.fi>
	 <2da21fe50903271208m1c369c88lba8399416dace43a@mail.gmail.com>
	 <8e92b4100903300238p4b0cbd3fh754a3dddbf904fa7@mail.gmail.com>
	 <2da21fe50903300631o39779ac9ge42252fd4697dce@mail.gmail.com>
Date: Tue, 31 Mar 2009 12:24:04 +0530
Message-ID: <8e92b4100903302354x66276239m48a14f2182d959c7@mail.gmail.com> (sfid-20090331_085409_979441_A090A959)
Subject: Re: ath9k and power management
From: Vivek Natarajan <vivek.natraj@gmail.com>
To: Davide Pesavento <davidepesa@gmail.com>
Cc: Kalle Valo <kalle.valo@iki.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>, mcgrof@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 30, 2009 at 7:01 PM, Davide Pesavento <davidepesa@gmail.com> wrote:
> On Mon, Mar 30, 2009 at 11:38, Vivek Natarajan <vivek.natraj@gmail.com> wrote:
>>
>> ath9k: No need to abort Rx path when autosleep is enabled.
>>
>> For chipsets supporting autosleep feature, there is no need to abort
>> Rx engine since they are capable of automatically going back to sleep
>> after receiving a packet.
>
> I've applied your patch but unfortunately the behaviour is still the
> same as before.

One more patch sent:
ath9k: Disable autosleep feature for AR9285 based chipsets.

I hope you are using one of the AR9285 based. I have unit tested and it seems to
work consistently now.

Vivek.
