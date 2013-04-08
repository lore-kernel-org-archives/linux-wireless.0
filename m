Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:56588 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762937Ab3DHSUp convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Apr 2013 14:20:45 -0400
From: Bing Zhao <bzhao@marvell.com>
To: Andreas Fenkart <andreas.fenkart@streamunlimited.com>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"daniel@zonque.org" <daniel@zonque.org>,
	Yogesh Powar <yogeshp@marvell.com>,
	Avinash Patil <patila@marvell.com>
Date: Mon, 8 Apr 2013 11:19:12 -0700
Subject: RE: [PATCH 1/6] mwifiex: bug: remove NO_PKT_PRIO_TID.
Message-ID: <477F20668A386D41ADCC57781B1F70430D9DE96073@SC-VEXCH1.marvell.com> (sfid-20130408_202102_483985_8549ADA1)
References: <20130402000511.GA31921@blumentopf>
 <1364861325-30844-1-git-send-email-andreas.fenkart@streamunlimited.com>
 <477F20668A386D41ADCC57781B1F70430D9DDAB197@SC-VEXCH1.marvell.com>
 <20130403113554.GA14785@blumentopf>
 <477F20668A386D41ADCC57781B1F70430D9DDAB35D@SC-VEXCH1.marvell.com>
 <20130404205706.GA29851@blumentopf>
 <477F20668A386D41ADCC57781B1F70430D9DDAB6EC@SC-VEXCH1.marvell.com>
 <20130405082659.GA12495@blumentopf>
In-Reply-To: <20130405082659.GA12495@blumentopf>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Andi,

> If I run: checkpatch.pl -f drivers/net/wireless/mwifiex/wmm.c. I
> get about 10-20 similar warnings. In general it seems mwifiex
> sticks with type 1 multiline comments. And I wanted to stick with
> the de-facto standard.
> 
> Should I still fix the warning?

Yes. Please fix the warning in these 2 patches.
Also there are some other warnings:

CHECK: Blank lines aren't necessary before a close brace '}'
#154: FILE: drivers/net/wireless/mwifiex/wmm.c:935:

You have to use "--strict" option to spot these messages.

> Should I prepare a separate patch on top fixing all multiline
> comments?

I think that will be too much in the entire driver code.
Let's keep them for now.

[...]

> > Could you share what test cases you are running? I will try to cover the cases you have not done.
> 
> Duration test with high load, sender and receiver.
> 
> I have dualband router and two DUT. One DUT connects to
> 2.4GHz-band the other to 5GHz-band. One is running iperf as
> server the other iperf as a client in a while true loop.
> 
> Eventually I will switch over to set one DUT as uAP, but didn't
> play with uAP yet.

Thanks for the information.

Regards,
Bing

