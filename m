Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from limerock01.mail.cornell.edu ([128.84.13.241]:47547 "EHLO
	limerock01.mail.cornell.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750699AbbJRTMK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Oct 2015 15:12:10 -0400
Date: Sun, 18 Oct 2015 15:11:56 -0400
From: Jacob Kiefer <jtk54@cornell.edu>
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
	Roberta Dobrescu <roberta.dobrescu@gmail.com>,
	"Gujulan Elango, Hari Prasath (H.)" <hgujulan@visteon.com>,
	"open list:STAGING - REALTEK RTL8723U WIRELESS DRIVER"
	<linux-wireless@vger.kernel.org>,
	"open list:STAGING SUBSYSTEM" <devel@driverdev.osuosl.org>,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2 v3] drivers: staging: rtl8723au: Changed rssi_cmd to
 little-endian param
Message-ID: <20151018191154.GA2936@jtk54-Q550LF> (sfid-20151018_211217_006255_BE3C0024)
References: <1444505324-2924-1-git-send-email-jtk54@cornell.edu>
 <wrfj612ewi7d.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <wrfj612ewi7d.fsf@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> I am fine with this code in principle, but has it been tested? This
> stuff will break the driver miserably if it's wrong.
> 
> Thanks,
> Jes
> 

This patchset has not been tested.
Unfortunately, I don't have to proper card to test this patch on my
local. It built for me, and that's as far as I went.

Is there a way for me to test this patch locally _without_ the
corresponding wireless card? I will gladly do this, I just need to know
the tools to use and methodology.

Otherwise, can anyone with the correct wireless card apply these patches to a copy of the kernel and
test that nothing breaks because of the patch on their machine? Again
this is for the RTL8723au wireless card.

Thanks,
Jake
