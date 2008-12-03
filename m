Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ironport.netspeed.com.au ([203.31.48.201]:56817 "EHLO
	ironport.netspeed.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754048AbYLCXJR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Dec 2008 18:09:17 -0500
Message-ID: <49370F49.2090602@astronomicalresearchaustralia.org> (sfid-20081204_000920_768824_5230E43A)
Date: Thu, 04 Dec 2008 08:59:21 +1000
From: Brian <bnc@astronomicalresearchaustralia.org>
Reply-To: bnc@astronomicalresearchaustralia.org
MIME-Version: 1.0
CC: ath9k-devel@venema.h4ckr.net, linux-wireless@vger.kernel.org
Subject: Re: [ath9k-devel] [stable] [PATCH 1/3] ath9k: Handle -ENOMEM on RX
 gracefully
References: <1228251082-11677-1-git-send-email-lrodriguez@atheros.com>	<1228251082-11677-2-git-send-email-lrodriguez@atheros.com>	<1228251082-11677-3-git-send-email-lrodriguez@atheros.com>	<1228251082-11677-4-git-send-email-lrodriguez@atheros.com>	<20081203001253.GC14943@kroah.com>	<43e72e890812021620lccafachbd8e781d283095b7@mail.gmail.com>	<20081203002404.GA22789@tuxdriver.com>	<20081203212255.GB4263@tuxdriver.com> <43e72e890812031414m6a5782e7ga8eed8d91fe056b2@mail.gmail.com>
In-Reply-To: <43e72e890812031414m6a5782e7ga8eed8d91fe056b2@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
To: unlisted-recipients:; (no To-header on input)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis,
I tried to respond to your comment in bug 12110 but do not have a id yet.

Does this patch fix this bug?


Here is my response


I have the same problem but with wireless testing on a 2.6.28-rc6-wl kernel.
I can run for hours if I do not use the wireless heavily.
But will crash within 10mins if I use NX.
(I have the NX parm turned on in the kernel)
I also get the same symptoms re a ping that will just stop/start,
directly before a crash. Also it starts to use my swap file. I NEVER use
swap normally.
Would you like me to apply the same patch and see if I can get some message?


Can I get a patch for 2.6.28-rc6-wl ?


Wireless Statistics
Sent :891261
TX Packets Dropped :21
Received :878290
RX Packets Dropped :1576
Errors :3531

Brian
