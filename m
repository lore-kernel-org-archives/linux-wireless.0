Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f216.google.com ([209.85.219.216]:45973 "EHLO
	mail-ew0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752335Ab0CWVL6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Mar 2010 17:11:58 -0400
Received: by ewy8 with SMTP id 8so909326ewy.28
        for <linux-wireless@vger.kernel.org>; Tue, 23 Mar 2010 14:11:55 -0700 (PDT)
From: Steven Wheeler <stevenwheel@gmail.com>
To: "'Christian Lamparter'" <chunkeey@googlemail.com>
Cc: "'Pavel Roskin'" <proski@gnu.org>, <linux-wireless@vger.kernel.org>
References: <002a01cac969$b726e8d0$2574ba70$@com> <201003221647.43357.chunkeey@googlemail.com> <000001cac9de$00a868c0$01f93a40$@com> <201003221807.45672.chunkeey@googlemail.com>
In-Reply-To: <201003221807.45672.chunkeey@googlemail.com>
Subject: RE: Problems with Netgear WG511v1 PCMCIA
Date: Tue, 23 Mar 2010 16:11:47 -0500
Message-ID: <000601cacacd$75b9ae90$612d0bb0$@com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Update: I rebuilt my system with the latest Slackware (v13.0) which has
kernel 2.6.29.6
I installed the firmware (Thanks Christian), did a little configuration and
wireless came up without an issue using prism54
I intend to try out P54pci later when I build the latest kernel. 

Thank you very much

-----Original Message-----
From: Christian Lamparter [mailto:chunkeey@googlemail.com] 
Sent: Monday, March 22, 2010 12:08 PM
To: Steven Wheeler
Cc: 'Pavel Roskin'; linux-wireless@vger.kernel.org
Subject: Re: Problems with Netgear WG511v1 PCMCIA

On Monday 22 March 2010 17:37:44 Steven Wheeler wrote:
> OK, from the pictures it appears to be the WG511 V2 or V3, the front and
> back labeling matches the label positions in the V3 pic
> But, an lspci shows that it has the isl3890 chipset
It almost certainly isn't a ISL3890. Because they only
featured in (dual band) APs and early evaluation/development boards.
(But as things usually go, some could have ended up in customer products...)

>From my stash of p54pci hardware only one manufacture bothered to fix the
Chip and PCI ID... (Zcom XG-603). Netgear on the other hand managed to ship
WG511v2 batchs with broken rssi<->dbm conversion parameters.
Therefore, don't be surprised if you see some odd signal readings.

(Note: This bug does not affect range or performance.
Rhe conversion is done in the driver and so far the dBm signal is
only a indicator for the user about signal strength...)
 
> I just downloaded the latest kernel (2.6.33.1), will build this afternoon
> I already have the P%$ firmware for kernels above 2.6.28, so I can test
> Will update later

here is the link: (also has fullmac firmwares)
http://daemonizer.de/prism54/prism54-fw/

Regards,
	Chr

