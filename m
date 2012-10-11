Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog124.obsmtp.com ([74.125.149.151]:35156 "EHLO
	na3sys009aog124.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751308Ab2JKMay convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Oct 2012 08:30:54 -0400
From: Amitkumar Karwar <akarwar@marvell.com>
To: 'Johannes Berg' <johannes@sipsolutions.net>
CC: Bing Zhao <bzhao@marvell.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Sam Leffler <sleffler@chromium.org>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>
Date: Thu, 11 Oct 2012 05:29:52 -0700
Subject: RE: [PATCH v3 0/5] add scan flags support
Message-ID: <5FF020A1CFFEEC49BD1E09530C4FF59506A25A0CE0@SC-VEXCH1.marvell.com> (sfid-20121011_143057_443960_B82EE54D)
In-Reply-To: <1349957673.13097.6.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

> > We have added code (v3 patch 4/5) to flush older scan entries whenever
> > new results are available. scan_start time is used for this. Everytime
> > it's getting modified to "jiffies + interval" for future use.
> 
> Ah. But that's in the wrong units (jiffies vs. ms).

Thanks for pointing this out. We will use msecs_to_jiffies() for correct comparison.

Thanks,
Amitkumar Karwar
