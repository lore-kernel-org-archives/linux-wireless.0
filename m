Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:32768 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751608AbYKMV4l (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Nov 2008 16:56:41 -0500
Subject: Re: hostap managed mode, blank ESSID
From: Dan Williams <dcbw@redhat.com>
To: IskiMJ@gmail.com
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <NGBBIAECGKIICNHKJGIPCEIPCIAA.IskiMJ@gmail.com>
References: <NGBBIAECGKIICNHKJGIPCEIPCIAA.IskiMJ@gmail.com>
Content-Type: text/plain
Date: Thu, 13 Nov 2008 16:54:35 -0500
Message-Id: <1226613275.29010.1.camel@localhost.localdomain> (sfid-20081113_225645_795791_7D34CB43)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2008-11-13 at 13:02 -0700, iskimj@gmail.com wrote:
> I'm running Ubuntu with kernel 2.6.27-7. I am trying to set up a
> Prism/Intersil PCMCIA card (Microsoft MN-520) with firmware version 1.4.9.
> 
> I am able to the orinoco module but I get many errors. I asked in that
> mailing list and one suggestion was to try the hostap module. I am trying to
> set up hostap but need a bit of help.
> 
> It is my understanding that I need to operate it in "managed" mode to
> connect as a client to a wireless AP. I can set the managed mode but I can't
> seem to set the ESSID, iwconfig will report EASED: " ". If I then change to
> "master" mode it reports the correct ESSID. Are there some additional steps
> that I need to do? Is there a bug in the driver?

Master mode means the card will act like an AP, so it isn't what you
want.

When the card reports a blank SSID, that means it simply hasn't
associated to the AP.  Are you sure your WEP or WPA keys are correct?
You might also try a higher firmware version; 1.7.x are known to work
quite a bit better than 1.4.9; I haven't had luck with 1.4.9.  Firmware
flashing is somewhat arcane, but here's the link:

http://linux.junsun.net/intersil-prism/

Dan


