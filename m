Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:43494 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753091Ab3DUNFJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Apr 2013 09:05:09 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1UTtx1-0006Fp-6o
	for linux-wireless@vger.kernel.org; Sun, 21 Apr 2013 15:05:04 +0200
Received: from cm227.omega17.maxonline.com.sg ([218.186.17.227])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sun, 21 Apr 2013 15:05:03 +0200
Received: from eliasacorn by cm227.omega17.maxonline.com.sg with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sun, 21 Apr 2013 15:05:03 +0200
To: linux-wireless@vger.kernel.org
From: Edward <eliasacorn@yahoo.com.sg>
Subject: Re: ath10k: mac80211 driver for QCA9880
Date: Sun, 21 Apr 2013 12:59:14 +0000 (UTC)
Message-ID: <loom.20130421T145410-125@post.gmane.org> (sfid-20130421_150514_505512_85A71456)
References: <87li8k0yu1.fsf@kamboji.qca.qualcomm.com> <20130415204030.51f20f43@m4a785t-m.gnutoo.workgroup>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Denis 'GNUtoo' Carikli <GNUtoo@...> writes:

> 
> Hi,
> 
> On Mon, 15 Apr 2013 15:20:54 +0300
> Kalle Valo <kvalo@...> wrote:
> >The biggest difference is that there's now firmware running on the
> >chip.
> Will the firmware be released as free software at some point?
> 
> Denis.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@...
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 


Does it matter? The firmware is just a binary logic black box. It's not
likely to even see more than a handful of revisions after the actual
products hit the market.

As long as the driver remains open I don't see any problems with the
open-driver-closed-firmware combination. Intel and Ralink has adopted this
practice to great success, and I don't see any reason why Atheros can't do
the same.

