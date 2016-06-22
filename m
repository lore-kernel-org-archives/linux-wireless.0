Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from iodev.co.uk ([82.211.30.53]:56960 "EHLO iodev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752551AbcFVUyQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jun 2016 16:54:16 -0400
Date: Wed, 22 Jun 2016 17:54:08 -0300
From: Ismael Luceno <ismael@iodev.co.uk>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless@vger.kernel.org, brcm80211-dev-list@broadcom.com
Subject: Re: [PATCH] brcmfmac: Add USB ID for Cisco Linksys AE1200
Message-ID: <20160622205407.sh6w64thsygavbvt@pirotess> (sfid-20160622_225420_099172_272FA402)
References: <20160621001841.5383-1-ismael@iodev.co.uk>
 <57698F43.3050303@broadcom.com>
 <20160622183622.uo5avhsjzmnn6jgf@pirotess>
 <576AE1DC.7050203@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <576AE1DC.7050203@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 22/Jun/2016 21:07, Arend van Spriel wrote:
> On 22-06-16 20:36, Ismael Luceno wrote:
> > On 21/Jun/2016 21:02, Arend van Spriel wrote:
> >> On 21-06-16 02:18, Ismael Luceno wrote:
> >>> Signed-off-by: Ismael Luceno <ismael@iodev.co.uk>
> >>
> >> A bit more description would be nice. I am actually wondering why you
> >> would be adding this. If I am not mistaken the AE1200 can not be handled
> >> by brcmfmac. Otherwise I am interested in a kernel log showing the
> >> device probe sequence with brcmfmac loaded with parameter debug=0x1416.
> > 
> > Log attached.
> > 
> > I was surprised it works without any tweaking.
> 
> Nice. What kernel version are you running on.

Commit c3695331f3a326a468bd6a5b6f05b481b399726b.

> Can you also dump a debugfs file,
> ie. /sys/kernel/debug/brcmfmac/*/revinfo.

vendorid: 0x14e4
deviceid: 0x4347
radiorev: 114.5.112
chipnum: 43235 (a8e3)
chiprev: 3
chippkg: 4
corerev: 24
boardid: 0x0571
boardvendor: 0x14e4
boardrev: P523
driverrev: 5.90.188.22
ucoderev: 0
bus: 0
phytype: 4
phyrev: 9
anarev: 0
nvramrev: 00000000


> I want to know what chip id and revision is reported. I have tried an
> AE1200 in the past, but it had a chip revision that had insufficient
> memory to run fullmac firmware.

That's going to be confusing for anyone having the hardware :(.

> Is there FCC registration number on it?

Yes: Q87-AE1200
