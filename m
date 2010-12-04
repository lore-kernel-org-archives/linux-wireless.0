Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:39118 "HELO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752344Ab0LDAfB convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Dec 2010 19:35:01 -0500
From: Bing Zhao <bzhao@marvell.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Fri, 3 Dec 2010 16:34:40 -0800
Subject: RE: [PATCH 0/3] mwifiex: remove some stuff...
Message-ID: <477F20668A386D41ADCC57781B1F704307D5C0FA31@SC-VEXCH1.marvell.com>
References: <20101203191130.GD2348@tuxdriver.com>
 <1291411051-12916-1-git-send-email-linville@tuxdriver.com>
 <477F20668A386D41ADCC57781B1F704307D5C0F9CB@SC-VEXCH1.marvell.com>
In-Reply-To: <477F20668A386D41ADCC57781B1F704307D5C0F9CB@SC-VEXCH1.marvell.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

> -----Original Message-----
> From: linux-wireless-owner@vger.kernel.org [mailto:linux-wireless-owner@vger.kernel.org] On Behalf Of
> Bing Zhao
> Sent: Friday, December 03, 2010 2:23 PM
> To: John W. Linville; linux-wireless@vger.kernel.org
> Subject: RE: [PATCH 0/3] mwifiex: remove some stuff...
> 
> Hi John,
> 
> > -----Original Message-----
> > From: John W. Linville [mailto:linville@tuxdriver.com]
> > Sent: Friday, December 03, 2010 1:17 PM
> > To: Bing Zhao; linux-wireless@vger.kernel.org
> > Cc: John W. Linville
> > Subject: [PATCH 0/3] mwifiex: remove some stuff...
> >
> > This series remvoes lots of stuff -- some bits might even be necessary,
> > but if so it is worth thinking about why that may be.
> 
> Thanks a lot for making changes to the driver.
> 
> >
> > Not tested...YMMV...
> 
> I'll test all the patches you posted. After that, I will start working on the items suggested by
> Johannes.

I tested all 3 patches. They passed checkpatch.pl and sparse check. Some basic functions have been verified OK: scan, associate, ping, iperf. I will do some more tests (security, ad-hoc, etc.) next week.

I'm planning to work on the cleanups commented by Johannes. If you have any additional suggestion in mind, I can do that too.

Thanks and have a nice weekend!

Bing

> 
> Thanks again.
> 
> Bing
> 
> >
> > John
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
