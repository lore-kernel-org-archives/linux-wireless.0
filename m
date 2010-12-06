Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:40774 "HELO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751135Ab0LFTRf convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Dec 2010 14:17:35 -0500
From: Bing Zhao <bzhao@marvell.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: Amitkumar Karwar <akarwar@marvell.com>
Date: Mon, 6 Dec 2010 11:14:54 -0800
Subject: RE: [PATCH 0/3] mwifiex: remove some stuff...
Message-ID: <477F20668A386D41ADCC57781B1F704307D5C0FCDB@SC-VEXCH1.marvell.com>
References: <20101203191130.GD2348@tuxdriver.com>
 <1291411051-12916-1-git-send-email-linville@tuxdriver.com>
 <477F20668A386D41ADCC57781B1F704307D5C0F9CB@SC-VEXCH1.marvell.com>
 <477F20668A386D41ADCC57781B1F704307D5C0FA31@SC-VEXCH1.marvell.com>
In-Reply-To: <477F20668A386D41ADCC57781B1F704307D5C0FA31@SC-VEXCH1.marvell.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

> > >
> > > Not tested...YMMV...
> >
> > I'll test all the patches you posted. After that, I will start working on the items suggested by
> > Johannes.
> 
> I tested all 3 patches. They passed checkpatch.pl and sparse check. Some basic functions have been
> verified OK: scan, associate, ping, iperf. I will do some more tests (security, ad-hoc, etc.) next
> week.
> 

Tested-by: Amitkumar Karwar <akarwar@marvell.com>


Regards,

Bing

