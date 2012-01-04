Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:30177 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754009Ab2ADVLB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jan 2012 16:11:01 -0500
Subject: Re: Fedora 16 Wireless Connection Problem
From: Dan Williams <dcbw@redhat.com>
To: Bob Miller <rmiller61k@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <loom.20111226T003824-126@post.gmane.org>
References: <CADiUXRwb+ktGmyuMxMcXhZkpbhy=kAkOJcTLpJYRcaFFSRMnMg@mail.gmail.com>
	 <loom.20111226T003824-126@post.gmane.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 04 Jan 2012 15:11:00 -0600
Message-ID: <1325711460.7269.47.camel@d430> (sfid-20120104_221105_993994_5DB19C8F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2011-12-25 at 23:42 +0000, Bob Miller wrote:
> mammar <mammar@...> writes:
> 
> > 
> > I have Dell Inpiron N5010 with Broadcom Corporation BCM4313
> > 802.11b/g/n Wireless LAN Controller.
> > 
> > My OS is Fedora 16 64-bit. I have installed the following drivers for
> > my wireless controller, everything is working great until yesterday.
> > Now whenever i try to connect to wirless connection, it failed.
> > 
> >
> > 
> > Can anyone help me?
> > 
> > Thanks
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> > the body of a message to majordomo@...
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> > 
> 
> What kernel are you using?
> 
> The latest kernel (kernel-3.1.6-1.fc16.x86_64) seems to have broken the wireless
> on my HP laptop. Wireless capability works with the prior version
> (kernel-3.1.5-6.fc16.x86_64).

I also note the OP is using the wl.o driver, which is known not to be
terribly reliable with wpa_supplicant and NetworkManager, while mac80211
drivers work much better.  I'd suggest looking into b43 or the new
softmac driver from Broadcom if you can.  Beyond that, we'd need
wpa_supplicant debug logs showing the actual issue, which can be
obtained by following these directions:

http://live.gnome.org/NetworkManager/Debugging

Dan

