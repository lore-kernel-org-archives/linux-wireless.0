Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from elasmtp-scoter.atl.sa.earthlink.net ([209.86.89.67]:50937 "EHLO
	elasmtp-scoter.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760025Ab2HJSt7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Aug 2012 14:49:59 -0400
Date: Fri, 10 Aug 2012 14:49:59 -0400
From: Marco Fonseca <marco@tampabay.rr.com>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: carl9170: Unintentional transmission in monitor mode?
Message-ID: <20120810184959.GB20870@192.168.1.10> (sfid-20120810_205007_020989_086F5E01)
References: <20120809165434.GA13409@192.168.1.10>
 <201208092143.28506.chunkeey@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201208092143.28506.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 09, 2012 at 09:43:28PM +0200, Christian Lamparter wrote:
> On Thursday, August 09, 2012 06:54:34 PM Marco Fonseca wrote:
> > Hello All,
> > 
> > I've noticed unexpected transmissions from the AR9170 while in monitor mode
> > and using tcpdump (and sometimes without tcpdump running).  These
> > transmissions degrade (pretty significantly) performance of other STA/AP on
> > the channel (as seen by iperf going from 60mbit/s to almost nill).  As best I
> > can tell these transmissions never coalesces into an actual frame in the air
> > (at least not one I'm able to pick up with a second different adapter in
> > monitor mode).
> > 
> > Are there any known reasons/bugs on this?  Is there anyway to completely
> > silence the transmitter of the AR9170 while still allowing reception?
> > 
> yes. <http://www.spinics.net/lists/linux-wireless/msg88896.html>
> 
> a solution is described in:
> <http://www.spinics.net/lists/linux-wireless/msg89279.html>
> 
> (iw dev wlanX set monitor none - if I'm not mistaken)
> 
> Regards,
> 	Chr

Excellent, this solved my problem.  Thank you Christian.

Marco
