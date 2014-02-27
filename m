Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:35259 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752944AbaB0Qim (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Feb 2014 11:38:42 -0500
Message-ID: <1393519119.4648.7.camel@jlt4.sipsolutions.net> (sfid-20140227_173847_150057_9EEE51C0)
Subject: Re: pci-half-mini 7260 Wireless AC support 3.13
From: Johannes Berg <johannes@sipsolutions.net>
To: Tim Nelson <tim.l.nelson@gmail.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 27 Feb 2014 17:38:39 +0100
In-Reply-To: <CAOAOC6aoz43LdXBTcRHWqPMvQAVKsH6z4yNqe_hEpT7zouo+Ew@mail.gmail.com> (sfid-20140227_172950_257003_488A71E4)
References: <CAOAOC6a96e5MrEOVY=KXirhUU-rJRv2hgz5B0so9SkWYMpoDfw@mail.gmail.com>
	 <1393517094.4648.3.camel@jlt4.sipsolutions.net>
	 <CAOAOC6agHr6mVB2jcUx1qHWnBJZyOw0=KP0Wp5BVhrvJgRhmQg@mail.gmail.com>
	 <1393517627.4648.4.camel@jlt4.sipsolutions.net>
	 <CAOAOC6ZhnB=LrJWvG07tOK=b_wWAFO74YdhXWZPxrVCk8=425A@mail.gmail.com>
	 <CAOAOC6aoz43LdXBTcRHWqPMvQAVKsH6z4yNqe_hEpT7zouo+Ew@mail.gmail.com>
	 (sfid-20140227_172950_257003_488A71E4)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-02-27 at 11:29 -0500, Tim Nelson wrote:
> As an example, I have screenshot what you see from the controller:
> 
> http://i.imgur.com/tEd701u.jpg
> 
> These are clients actually associating with the AC radio inside the AP.

So that doesn't really mean anything about the *radio* you're connecting
to. The (probably single!) radio in the AP is simply capable of 11ac,
which means it can also deal with 11n. There aren't two radios for that.

What 7260 device do you have, btw? There are 11n-only versions of it,
can you give me the PCI ID and/or check kernel messages (dmesg)? Or just
paste the "iw list" output somewhere.

johannes

