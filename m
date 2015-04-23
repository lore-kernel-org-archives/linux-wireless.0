Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fopen.at ([151.236.7.194]:37603 "EHLO fopen.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756849AbbDWIdE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Apr 2015 04:33:04 -0400
From: Florian Achleitner <flo@fopen.at>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: Avinash Patil <patila@marvell.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Maithili Hinge <maithili@marvell.com>
Subject: Re: [RFC/PATCH] mwifiex: Driver - Firmware Glitches
Date: Thu, 23 Apr 2015 10:33:02 +0200
Message-ID: <2079721.JMnuuxDd1J@r90b40zn> (sfid-20150423_103314_909049_0736105A)
In-Reply-To: <5FF020A1CFFEEC49BD1E09530C4FF5951B16EB7A39@SC-VEXCH1.marvell.com>
References: <3169170.GKjfvNuGRf@r90b40zn> <1675638.uTIoPdU2hg@r90b40zn> <5FF020A1CFFEEC49BD1E09530C4FF5951B16EB7A39@SC-VEXCH1.marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 17 April 2015 02:45:02 Amitkumar Karwar wrote:
> Known firmware issues are command timeout and wakeup failure. They are not
> specific to SDIO. As Avinash mentioned earlier, we need to check
> CONFIG_MMC_DEBUG enbled dmesg logs for "write iomem (1) failed: -110"
> issue.

Thx.
A kernel with CONFIG_MMC_DEBUG is  running since 6 days on 4 devices, but 
nothing valuable captured yet. Unfortunately, it looks like the debugging code 
modifies the timing, such that the failure doesn't occur.. 

> 
> Regards,
> Amitkumar

Regards, 
Flo
