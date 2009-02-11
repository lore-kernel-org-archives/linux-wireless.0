Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:49214 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755666AbZBKSRg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Feb 2009 13:17:36 -0500
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1LXJeL-0001wL-Uc
	for linux-wireless@vger.kernel.org; Wed, 11 Feb 2009 18:17:29 +0000
Received: from rain.gmane.org ([80.91.229.7])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 11 Feb 2009 18:17:29 +0000
Received: from lurkos.usenet by rain.gmane.org with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 11 Feb 2009 18:17:29 +0000
To: linux-wireless@vger.kernel.org
From: Lurkos <lurkos.usenet@gmail.com>
Subject: Re: Merge compat-wireless-old into 2.6.26
Date: Wed, 11 Feb 2009 18:17:21 +0000 (UTC)
Message-ID: <20090211181727.8162.26564.XPN@L622132.user.x-privat.org> (sfid-20090211_191740_228885_C294F92D)
References: <20090210172817.9004.60065.XPN@L622132.user.x-privat.org> <20090210181915.GA4248@tesla>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

*Luis R. Rodriguez* wrote:

>> Is it possibile to patch linux 2.6.26 source (e.g. Debian Lenny sources)
>> to have the new compat-wireless-old?
>> If yes, what could be the correct procedure?
> It is possible, you would just have to replace the directories
> that compat-wireless-old has in the kernel sources.

Ok, thank you. I am going to try.

>> I would prefer to compile only my wireless network card driver
>> statically into the kernel.
> What exactly will that buy you though? Is it worth the effort?

In fact probably no.
I would like only to use the new iwl3945, because the one provided with
2.6.26 gives me lots of problem (*) and then I have to use
compat-wirelss-old version.
At the same time I would prefer not to put files outside my home without
a corresponding deb package, to keep administration of the machine more
simple. It's quite simple to forget these type of customization (like
installing compat-wireless)... a package with the flag installed makes
simpler to keep track on what exactly you have done with the laptop.
Of course it's also a way learn more about Linux...

(*) physical button to switch on/off wifi doesn't work

-- 
Lurkos

