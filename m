Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f221.google.com ([209.85.220.221]:35116 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751308AbZLSPcQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Dec 2009 10:32:16 -0500
Received: by fxm21 with SMTP id 21so3610987fxm.21
        for <linux-wireless@vger.kernel.org>; Sat, 19 Dec 2009 07:32:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <c68f135e0912190230o566b3c3dk9be3038b0602cac5@mail.gmail.com>
References: <20091218180205.GD2512@florz.florz.dyndns.org>
	 <4B2BC7E3.2050907@lwfinger.net>
	 <20091218185916.GE2512@florz.florz.dyndns.org>
	 <4B2C100A.9000507@lwfinger.net>
	 <c68f135e0912181615p7cd36bd0n7054b43f2b453599@mail.gmail.com>
	 <20091219011306.GG2512@florz.florz.dyndns.org>
	 <c68f135e0912190230o566b3c3dk9be3038b0602cac5@mail.gmail.com>
Date: Sat, 19 Dec 2009 15:32:14 +0000
Message-ID: <3ace41890912190732p3e049e20ob7c63d9329352cdc@mail.gmail.com>
Subject: Re: Power consumption of RTL8187 (driver)/recommendations for
	low-power USB 802.11 adapter?
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: andreamrl@tiscali.it
Cc: Florian Zumbiehl <florz@florz.de>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	herton@mandriva.com.br, htl10@users.sourceforge.net,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Dec 19, 2009 at 10:30 AM, Andrea Merello <andreamrl@tiscali.it> wrote:

> Hmm.. Well.. I guess that effectively a USB softmac card on a slow
> computer might produce a noticeable overhead, even if I never tried
> before..

Oh, I have an old machine with a celeron 366Mhz, where I run a zd1211
with the vendor driver as AP.... throughput to a USB disk sharing a
hub something like 430kB/s but can be over 70kB to the the local
non-USB hard disk. (some of the difference in speed is obviously just
data bandwidth contention). There are significant overhead at the USB
level, I think; but in any case, the CPU probably can't sleep because
the USB sub-system is always doing something, if even just for
processing beacons.
