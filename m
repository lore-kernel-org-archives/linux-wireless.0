Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32353 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751989Ab2HKTJ4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Aug 2012 15:09:56 -0400
Date: Sat, 11 Aug 2012 21:09:53 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: David Herrmann <dh.herrmann@googlemail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: rt73usb: WARN(x) in check_sdata_in_driver()
Message-ID: <20120811190951.GA2432@redhat.com> (sfid-20120811_211047_497109_B04A4886)
References: <CANq1E4RFGq2M7uSOMZLGuZYSa7E5g6RoWfyLDLtgAdsORD_qWg@mail.gmail.com>
 <20120810222746.GA19779@redhat.com>
 <CANq1E4RH5fHM5LPddD+A_w-G7k0=0scP0jpmqHnygX6Q9_Xecw@mail.gmail.com>
 <20120811163406.GA10564@redhat.com>
 <CANq1E4T=ajt6yt6NMfdyM4mjNgVkevF_nS7tVC-UAs3YpgLYfQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CANq1E4T=ajt6yt6NMfdyM4mjNgVkevF_nS7tVC-UAs3YpgLYfQ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Aug 11, 2012 at 08:46:47PM +0200, David Herrmann wrote:
> Yes, I generated the wpa_supplicant.conf via netcfg (a network manager from
> ArchLinux) and used it by hand. I often noticed doing everything by myself
> works, but using netcfg or NetworkManager results in a timeout during
> wlan-connection. Haven't debugged this, but it is not related to this bug
> as it happens with other devices, too.
> 
> I now got everything running again, are you still interested in the
> wpa_supplicant.conf? Sorry, for the noice.
> Anyway, I haven't encountered the kernel-warnings, yet, but I will keep
> looking. I haven't found a way to reliably reproduce them, but I saw them
> quite often with linux-next a month ago and they seem to be gone now.
>
> Have you pushed any patches regarding this bug or do you just assume that
> this was some untested code in linux-next that should be fixed in the
> stable series for now?

We have various mac80211 fixes that could be related with this problem,
but I do not see any particular which address that directly. Perhaps
warnings ware some side effect of other bug.

> I will tell you if the bugs occur again, but as I said, they seem gone.
> Anyway, thanks for your time!

Yeh, if warnings come back, please post me wpa_supplicant.conf, and
eventually some other informations important to reproduce the problem
(except .config which you already provided).

Thanks
Stanislaw
