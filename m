Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:39231 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756019AbYH1Uj0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Aug 2008 16:39:26 -0400
Subject: Re: [Rt2400-devel] [rt2x00] rt2800 progress update (bad news)
From: Mattias Nissler <mattias.nissler@gmx.de>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: rt2400-devel <rt2400-devel@lists.sourceforge.net>,
	linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
In-Reply-To: <200808272222.53719.IvDoorn@gmail.com>
References: <200808272222.53719.IvDoorn@gmail.com>
Content-Type: text/plain
Date: Thu, 28 Aug 2008 22:39:22 +0200
Message-Id: <1219955962.4508.43.camel@localhost> (sfid-20080828_223931_063298_C849235F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Ivo,

I'll have some spare time during September, and I'd be happy to help you
with this. Problem is I don't have rt2800 hardware, but I'd consider to
get me a device. Do you have a list of hardware that contains the chip?
Unfortunately the rt2x00 hardware page currently doesn't have
information on rt2800 devices.

Cheers,

Mattias

On Wed, 2008-08-27 at 22:22 +0200, Ivo van Doorn wrote:
> Hi,
> 
> Several weeks after the deadline for the initial rt2800 version,
> I regret to inform everybody that I still do not have a working driver.
> 
> rt2800pci is still incomplete since I have put a lot of focus on the rt2800usb
> driver to get at least a single working driver out. Unfortunately rt2800usb
> remains very stubborn and refuses. The only success I have had so far is
> when I first load the legacy driver and switch to rt2800usb afterwards.
> This means I am missing a register initialization or there is a problem with
> the register initialization ordering.
> 
> The result is that it looks like I will cancel all previously announced deadlines,
> and at this time can't give a indication when the first version can be released.
> What I can promise is that rt2800usb will be released first, since that driver is most
> complete, and I am putting all focus on that driver first.
> 
> Ivo
> 
> -------------------------------------------------------------------------
> This SF.Net email is sponsored by the Moblin Your Move Developer's challenge
> Build the coolest Linux based applications with Moblin SDK & win great prizes
> Grand prize is a trip for two to an Open Source event anywhere in the world
> http://moblin-contest.org/redirect.php?banner_id=100&url=/
> _______________________________________________
> Rt2400-devel mailing list
> Rt2400-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/rt2400-devel

