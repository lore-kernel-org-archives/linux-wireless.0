Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:39064 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756534AbZINVLU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Sep 2009 17:11:20 -0400
Received: by bwz19 with SMTP id 19so2387829bwz.37
        for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2009 14:11:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4AAE7395.1050502@ufra.edu.br>
References: <4A9BFCCB.6040808@ufra.edu.br>
	 <3ace41890908311025r3ce83c12gd6aeace4833609b1@mail.gmail.com>
	 <4A9C0ADC.6050607@ufra.edu.br>
	 <3ace41890908311126m5212926cl27172ae775fc92f2@mail.gmail.com>
	 <4A9D7DC0.6050701@ufra.edu.br> <4AAC240E.20104@ufra.edu.br>
	 <3ace41890909130313y474074ecnc5e720f780a4bd8f@mail.gmail.com>
	 <3ace41890909132041w2d3f10b7r72e0eb855f1ab2a5@mail.gmail.com>
	 <43e72e890909132109l4b47431cw85cfba21ec1fb42c@mail.gmail.com>
	 <4AAE7395.1050502@ufra.edu.br>
Date: Mon, 14 Sep 2009 22:11:23 +0100
Message-ID: <3ace41890909141411r3d57c6datca12c69cf51c32d9@mail.gmail.com>
Subject: Re: zd1211rw on ppc (iBook G4) -- Solved, somewhat)
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: "Leonardo H. Souza Hamada" <leonardo.hamada@ufra.edu.br>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 14, 2009 at 5:47 PM, Leonardo H. Souza Hamada
<leonardo.hamada@ufra.edu.br> wrote:

> <<<Disabling original zd1211rw in kernel configuration, recompiled
> kernel as instructed above, installed new kernel, reboot, many times
> until I got it right>>>

The patch isn't particularly version-specific - may have applied to
the kernel source itself...

> Results:
>
> dmesg seems ok. no errors.

No, I want to see dmesg - there should be something similiar to this?

cfg80211: Calling CRDA for country: GB
cfg80211: Regulatory domain changed to country: GB
	(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
	(2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm)
	(5170000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2000 mBm)
	(5250000 KHz - 5330000 KHz @ 40000 KHz), (N/A, 2000 mBm)
	(5490000 KHz - 5710000 KHz @ 40000 KHz), (N/A, 2700 mBm)

> can do iwlist wlan0
>
> iwconfig wlan0 shows:
> IEEE 802.11bg  Mode:Managed  Access Point: Not-Associated
>          Tx-Power=20 dBm
>          Retry  long limit:7   RTS thr:off   Fragment thr:off
>          Encryption key:off
>          Power Management:off
>
>
> I do not seem to be able to connect to a given access point so far. LED
> does not blink.

stay dark or stay lit?
