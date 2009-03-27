Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f169.google.com ([209.85.218.169]:46122 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751837AbZC0OzM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Mar 2009 10:55:12 -0400
Received: by bwz17 with SMTP id 17so1035386bwz.37
        for <linux-wireless@vger.kernel.org>; Fri, 27 Mar 2009 07:55:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87ljqr58oa.fsf@litku.valot.fi>
References: <2da21fe50903270727m7b7007ctaa846aea61902436@mail.gmail.com>
	<87ljqr58oa.fsf@litku.valot.fi>
Date: Fri, 27 Mar 2009 15:54:54 +0100
Message-ID: <2da21fe50903270754i26c8be08i206b12a268214f56@mail.gmail.com> (sfid-20090327_155517_266573_4A7C319B)
Subject: Re: ath9k and power management
From: Davide Pesavento <davidepesa@gmail.com>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 27, 2009 at 15:42, Kalle Valo <kalle.valo@iki.fi> wrote:
> Davide Pesavento <davidepesa@gmail.com> writes:
>
>> I'm running a 2.6.29-wl kernel, using ath9k and wpa_supplicant 0.6.9
>> (with -Dnl80211).
>> Enabling power management when connected (i.e. 'iwconfig wlan0 power
>> on'), causes the currently established connection to break and the
>> machine is no longer able to reconnect to the AP.
>
> Try with a timeout, for example three seconds:
>
> iwconfig wlan0 power timeout 3
>
> It might be that ath9k doesn't work when timeout is zero (which 'power
> on' effectively does). You need a fairly new wireless-tools to set the
> timeout, older versions had a bug with that.
>

What do you mean by "fairly new"? I have wireless-tools version 29
installed, which is the latest stable. Do I need to use version 30
beta?

Thanks,
Davide
