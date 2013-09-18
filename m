Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from foo.stuge.se ([212.116.89.98]:59501 "EHLO foo.stuge.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751635Ab3IRPmi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Sep 2013 11:42:38 -0400
Message-ID: <20130918154233.31983.qmail@stuge.se> (sfid-20130918_174253_616526_D0660EB2)
Date: Wed, 18 Sep 2013 17:42:33 +0200
From: Peter Stuge <peter@stuge.se>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>
Subject: Re: RT3573 wpa_supplicant: "nl80211: Delete station $my_ap" after
	"SME: Send 20/40 BSS Coexistence to $my_ap"
References: <5239A815.40909@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5239A815.40909@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Xose Vazquez Perez wrote:
> > I'm testing the WNDA4100 with torvalds/linux.git and as of a day or
> > two ago and wpa_supplicant-2.0.
> > 
> > I haven't measured throughput. Latency is really bad for interactive
> > connections, but at least the packets are flowing on all bands. Yay!
> > 
> > Ping to the access point is around 3 ms with the odd 20+ ms when the
> > kernel goes off to do something else.
> 
> Support for RT3573 was added recently, you should use wireless-next:
> http://git.kernel.org/cgit/linux/kernel/git/linville/wireless-next.git

I made a typo in my first email - it should have read:

"I'm testing the WNDA4100 with torvalds/linux.git as of a day or two ago"

I am on linux.git commit d8efd82eece89f8a5790b0febf17522affe9e1f1
which contains commit f212781, current wireless-next/master HEAD.

I also looked on the rt2x00 list for proposed 3573 patches but didn't
see any. I hope I already have the latest code.

Do you suspect that my problem (as described briefly in the email
subject and with more detail after the part of my email which you
quoted) is related to the device driver rather than higher-up parts
of the stack?


> You can also try latest fw(v0.33):
> http://rt2x00.serialmonkey.com/pipermail/users_rt2x00.serialmonkey.com/attachments/20130111/f8ebe4d3/attachment.bin

Thanks! Will try this and get back to you.

But why isn't this file in linux-firmware.git? Especially if it was
sent already in January?


Kind regards

//Peter
