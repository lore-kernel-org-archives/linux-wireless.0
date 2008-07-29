Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:33417 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752250AbYG2MyG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jul 2008 08:54:06 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH RFC/RFT] b43: Rewrite TX power adjustment
Date: Tue, 29 Jul 2008 14:53:35 +0200
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
References: <200807261726.53279.mb@bu3sch.de> <200807282017.04979.mb@bu3sch.de> <488E4D7E.6010003@lwfinger.net>
In-Reply-To: <488E4D7E.6010003@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200807291453.36132.mb@bu3sch.de> (sfid-20080729_145409_358998_030692D8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 29 July 2008 00:51:42 Larry Finger wrote:
> Michael Buesch wrote:
> > On Saturday 26 July 2008 17:26:52 Michael Buesch wrote:
> >> This is an experimental attempt for fixing the currently-not-so-good
> >> TX power adjustment.
> > 
> > Hm, is anybody going to test this, or are there really no transmission
> > problems left? :)
> 
> It seems to work here. The dmesg output for my BCM4312 is:

Thanks.

> Is this sufficient,

No.

> or is there other output that you want to see? 

Please do
        echo 1 >/debug/b43/phy*/debug_xmitpower
to enable verbose xmitpower debugging.

> > But please note that current wireless-testing tree seems to have some
> > unrelated TX issues in mac80211 (see the discussions about the qdisc
> > and skb->cb stuff.)
> 
> AFAIK, this particular bug is limited to mainline. At least wireless still works 
> in wireless-testing, but fails completely in Linus's tree.

Yeah, I noticed. So please ignore this.

-- 
Greetings Michael.
