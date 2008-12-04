Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:55435 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752697AbYLDCca (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Dec 2008 21:32:30 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 03 Dec 2008 18:32:30 -0800
Date: Wed, 3 Dec 2008 18:32:28 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Brian <bnc@astronomicalresearchaustralia.org>
CC: "ath9k-devel@venema.h4ckr.net" <ath9k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [ath9k-devel] [stable] [PATCH 1/3] ath9k: Handle -ENOMEM on RX
	gracefully
Message-ID: <20081204023228.GT6522@tesla> (sfid-20081204_033234_231441_E9446109)
References: <1228251082-11677-1-git-send-email-lrodriguez@atheros.com> <1228251082-11677-2-git-send-email-lrodriguez@atheros.com> <1228251082-11677-3-git-send-email-lrodriguez@atheros.com> <1228251082-11677-4-git-send-email-lrodriguez@atheros.com> <20081203001253.GC14943@kroah.com> <43e72e890812021620lccafachbd8e781d283095b7@mail.gmail.com> <20081203002404.GA22789@tuxdriver.com> <20081203212255.GB4263@tuxdriver.com> <43e72e890812031414m6a5782e7ga8eed8d91fe056b2@mail.gmail.com> <49370F49.2090602@astronomicalresearchaustralia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <49370F49.2090602@astronomicalresearchaustralia.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 03, 2008 at 02:59:21PM -0800, Brian wrote:
> Luis,
> I tried to respond to your comment in bug 12110 but do not have a id yet.
> 
> Does this patch fix this bug?
> 
> 
> Here is my response
> 
> 
> I have the same problem but with wireless testing on a 2.6.28-rc6-wl kernel.
> I can run for hours if I do not use the wireless heavily.
> But will crash within 10mins if I use NX.
> (I have the NX parm turned on in the kernel)
> I also get the same symptoms re a ping that will just stop/start,
> directly before a crash. Also it starts to use my swap file. I NEVER use
> swap normally.
> Would you like me to apply the same patch and see if I can get some message?
> 
> 
> Can I get a patch for 2.6.28-rc6-wl ?

wireless-testing is now on 2.6.28-rc7, please do a git pull and
recompile and test that. It has some critical fixes for ath9k.

  Luis
