Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx01.fronius.com ([213.33.117.78]:59317 "EHLO mx01.fronius.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752998AbbDQIkG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Apr 2015 04:40:06 -0400
From: Florian Achleitner <achleitner.florian@fronius.com>
To: Amitkumar Karwar <akarwar@marvell.com>
CC: Avinash Patil <patila@marvell.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Maithili Hinge <maithili@marvell.com>
Subject: Re: [RFC/PATCH] mwifiex: Driver - Firmware Glitches
Date: Fri, 17 Apr 2015 10:29:59 +0200
Message-ID: <1675638.uTIoPdU2hg@r90b40zn> (sfid-20150417_104013_802805_2CA415E5)
In-Reply-To: <2293982.N26UvI80V5@r90b40zn>
References: <3169170.GKjfvNuGRf@r90b40zn> <5FF020A1CFFEEC49BD1E09530C4FF5951B16EB768F@SC-VEXCH1.marvell.com> <2293982.N26UvI80V5@r90b40zn>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 16 April 2015 15:19:27 Florian Achleitner wrote:
> I will try to figure out whether the root cause is the MMC interface.
> Probably in this case, the reset actually recovers from a bug in the mmc 
> driver.

Anyways, we have a virtually identical hardware with a Marvell SD8688 based 
wireless module, which uses the libertas driver. Running kernel 3.10.41 we 
have no problems for 50 days. 

Running the same kernel with mwifiex with the SD8788 we see a freeze which 
requires a hw-reset within about a day. Similar to the most recent kernel.

Are there known sdio issues with SD8788?
Will try to get useful information from the mmc system..

Regards,
Florian
