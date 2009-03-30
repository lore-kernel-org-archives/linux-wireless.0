Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f169.google.com ([209.85.218.169]:43729 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941AbZC3Nb5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2009 09:31:57 -0400
Received: by bwz17 with SMTP id 17so1919140bwz.37
        for <linux-wireless@vger.kernel.org>; Mon, 30 Mar 2009 06:31:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <8e92b4100903300238p4b0cbd3fh754a3dddbf904fa7@mail.gmail.com>
References: <2da21fe50903270727m7b7007ctaa846aea61902436@mail.gmail.com>
	<87ljqr58oa.fsf@litku.valot.fi> <2da21fe50903271208m1c369c88lba8399416dace43a@mail.gmail.com>
	<8e92b4100903300238p4b0cbd3fh754a3dddbf904fa7@mail.gmail.com>
Date: Mon, 30 Mar 2009 15:31:39 +0200
Message-ID: <2da21fe50903300631o39779ac9ge42252fd4697dce@mail.gmail.com> (sfid-20090330_153201_166963_2D3FDBAE)
Subject: Re: ath9k and power management
From: Davide Pesavento <davidepesa@gmail.com>
To: Vivek Natarajan <vivek.natraj@gmail.com>
Cc: Kalle Valo <kalle.valo@iki.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>, mcgrof@gmail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 30, 2009 at 11:38, Vivek Natarajan <vivek.natraj@gmail.com> wrote:
> On Sat, Mar 28, 2009 at 12:38 AM, Davide Pesavento <davidepesa@gmail.com> wrote:
>
>>>> I'm running a 2.6.29-wl kernel, using ath9k and wpa_supplicant 0.6.9
>>>> (with -Dnl80211).
>>>> Enabling power management when connected (i.e. 'iwconfig wlan0 power
>>>> on'), causes the currently established connection to break and the
>>>> machine is no longer able to reconnect to the AP.
>
> Patch has been sent to wireless-testing. Please report if the issue
> still exists after
> applying the patch.
> The commit log of the patch is
>
> ath9k: No need to abort Rx path when autosleep is enabled.
>
> For chipsets supporting autosleep feature, there is no need to abort
> Rx engine since they are capable of automatically going back to sleep
> after receiving a packet.
>
>
> Thanks a lot for reporting the issue
> Vivek.
>

I've applied your patch but unfortunately the behaviour is still the
same as before.

Thanks,
Davide
