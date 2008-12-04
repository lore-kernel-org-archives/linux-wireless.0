Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ironport.netspeed.com.au ([203.31.48.201]:57864 "EHLO
	ironport.netspeed.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752060AbYLDH7K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Dec 2008 02:59:10 -0500
Message-ID: <49378DCB.3080401@astronomicalresearchaustralia.org> (sfid-20081204_085915_601185_5B71EBF9)
Date: Thu, 04 Dec 2008 17:59:07 +1000
From: Brian <bnc@astronomicalresearchaustralia.org>
Reply-To: bnc@astronomicalresearchaustralia.org
MIME-Version: 1.0
CC: "ath9k-devel@venema.h4ckr.net" <ath9k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: 2.6.28-rc7-wl
References: <1228251082-11677-1-git-send-email-lrodriguez@atheros.com>	<1228251082-11677-2-git-send-email-lrodriguez@atheros.com>	<1228251082-11677-3-git-send-email-lrodriguez@atheros.com>	<1228251082-11677-4-git-send-email-lrodriguez@atheros.com>	<20081203001253.GC14943@kroah.com>	<43e72e890812021620lccafachbd8e781d283095b7@mail.gmail.com>	<20081203002404.GA22789@tuxdriver.com>	<20081203212255.GB4263@tuxdriver.com>	<43e72e890812031414m6a5782e7ga8eed8d91fe056b2@mail.gmail.com>	<49370F49.2090602@astronomicalresearchaustralia.org> <20081204023228.GT6522@tesla>
In-Reply-To: <20081204023228.GT6522@tesla>
Content-Type: text/plain; charset=ISO-8859-1
To: unlisted-recipients:; (no To-header on input)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



Luis,
> 
> wireless-testing is now on 2.6.28-rc7, please do a git pull and
> recompile and test that. It has some critical fixes for ath9k.
> 
Downloaded and installed, I had done a git-pull a few hours before and
it was not there:)

I set up my system with NX running and was waiting to be up 2hours.
Unfortunately it only made 1:50.
Still this is bundles better than the 10mins I was getting.

Some observations:

1) wpa_supplicant no longer chews up cpu/mem. It started and then did
nothing from then on. It used to be in the top 5 on htop.

2) I used to get a huge number of receive errors
 This is what I started with Errors :3708
 After an hour I had         Errors :3746

3) Towards the end the memory usage was creeping, slightly, up but no
where near the swap file.


As suggested by others I did have a console running, but I was
monitoring htop(to see if it started to use the swap) when it went.
So I have no further diagnostics.

When I did the compile it came up and asked me if I wanted the new
diagnostic facility for the driver and I just pressed enter.
Happy to go back and recompile(or can I turn it on).

If I turn it on do you have a methodology to use it?

Thanks for the great improvement,
Brian




