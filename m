Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from swm.pp.se ([212.247.200.143]:47068 "EHLO uplift.swm.pp.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932081Ab2K1TJI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2012 14:09:08 -0500
Date: Wed, 28 Nov 2012 20:02:15 +0100 (CET)
From: Mikael Abrahamsson <swmike@swm.pp.se>
To: Johannes Berg <johannes@sipsolutions.net>
cc: Jens Kapitza <j.kapitza@schwarze-allianz.de>,
	linux-wireless@vger.kernel.org, emmanuel.grumbach@intel.com
Subject: Re: iwlwifi hibernate / suspend issue
In-Reply-To: <1354126096.9345.45.camel@jlt4.sipsolutions.net>
Message-ID: <alpine.DEB.2.00.1211281957400.27834@uplift.swm.pp.se> (sfid-20121128_200912_592454_19B91014)
References: <50B61C71.6060007@schwarze-allianz.de>  (sfid-20121128_152227_935873_AFE02FFF) <1354113010.9345.27.camel@jlt4.sipsolutions.net>  <50B62254.9070700@schwarze-allianz.de>  <1354113722.9345.28.camel@jlt4.sipsolutions.net>  <50B62BEB.6020109@schwarze-allianz.de>
  <1354120982.9345.35.camel@jlt4.sipsolutions.net>  (sfid-20121128_174246_886056_FD8C7512) <1354126096.9345.45.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 28 Nov 2012, Johannes Berg wrote:

> So yeah, you were right when you said it's related to the BIOS, I just 
> thought you said reloading the module fixed it which I thought was very 
> strange. Since it doesn't, it's just the BIOS/whatever pulling the line 
> low and there's nothing the wifi driver can do about that, we can't even 
> ignore that.

I on the other hand, have the issue of iwlwifi sometimes stops working and 
rmmod iwlwifi ; modprobe iwlwifi fixes (most of the time) the issue.

Lenovo Thinkpad, Intel 5300.
03:00.0 Network controller: Intel Corporation Ultimate N WiFi Link 5300

I am running Ubuntu 12.04, just for kicks I tried loading the kernel 3.6 
backport modules which made the situation worse. I have historically tried 
to bug report here a few times before without anyone replying, so I 
stopped since I figured there wasn't anyone interested.

http://comments.gmane.org/gmane.linux.kernel.wireless.general/76919
http://www.spinics.net/lists/linux-wireless/msg96442.html

If someone could tell me what information I can provide that might be 
important to bring the development forward, I'm all game.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
