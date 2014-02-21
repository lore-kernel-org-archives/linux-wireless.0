Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:21619 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752417AbaBUUTh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Feb 2014 15:19:37 -0500
From: Bing Zhao <bzhao@marvell.com>
To: Fengguang Wu <fengguang.wu@intel.com>,
	Yogesh Powar <yogeshp@marvell.com>
CC: Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 21 Feb 2014 12:19:27 -0800
Subject: RE: [mwifiex/USB8897] Error: Driver 'usb8xxx' is already
 registered, aborting...
Message-ID: <477F20668A386D41ADCC57781B1F70430F53B2A485@SC-VEXCH1.marvell.com> (sfid-20140221_212042_460600_464F8592)
References: <20140221085235.GA2055@localhost>
In-Reply-To: <20140221085235.GA2055@localhost>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Fengguang,

> Greetings,
> 
> I got the below dmesg and the first bad commit is
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
> commit 68458dede7e0055198318dcb0318df3b4f419507
> CommitDate: Mon Jan 13 14:46:59 2014 -0500
> 
>     mwifiex: add USB8897 support
> 
> [    6.211307] Error: Driver 'usb8xxx' is already registered, aborting...
> [    6.211307] Error: Driver 'usb8xxx' is already registered, aborting...
> [    6.217261] mwifiex_usb: Driver register failed!
> [    6.217261] mwifiex_usb: Driver register failed!

Thanks for reporting this bug.
I will send the patch to fix it shortly.

Regards,
Bing

