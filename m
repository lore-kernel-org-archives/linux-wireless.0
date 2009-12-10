Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:45611 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1759215AbZLJAqH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Dec 2009 19:46:07 -0500
From: "Stefan Lippers-Hollmann" <s.L-H@gmx.de>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: regression: rt2561 frequent "Arrived at non-free entry" errors in   2.6.32
Date: Thu, 10 Dec 2009 01:46:11 +0100
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Andi Kleen <andi@firstfloor.org>,
	linux-wireless@vger.kernel.org, Tim Blechmann <tim@klingt.org>,
	rjw@sisk.pl, IvDoorn@gmail.com, linville@tuxdriver.com
References: <20091204233202.GA13658@basil.fritz.box> <200912090053.25798.s.L-H@gmx.de> <4B1F4A88.5000803@gmail.com>
In-Reply-To: <4B1F4A88.5000803@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <200912100146.12717.s.L-H@gmx.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

On Thursday 10 December 2009, Gertjan van Wingerde wrote:
> On 12/09/09 00:53, Stefan Lippers-Hollmann wrote:
> > Hi
> > 
> > On Tuesday 08 December 2009, Johannes Berg wrote:
> >> On Tue, 2009-12-08 at 23:39 +0100, Stefan Lippers-Hollmann wrote:
> >>
> >>> Unfortunately this fails to compile for me:
> >>
> >> well remove the spurious opening brace? :)
> > 
> > yes, of course - but I have to admit that I didn't look too well at the 
> > patch, after your other subthread - sorry about the noise.
> > 
> 
> Yeah, sorry about the compile error in the patch.
> 
> > 
> > with the patch applied (powersaving enabled):
> > 
> > - Downloading a larger file and therefore keeping the interface busy works 
> >   now pretty well, while I did hit connection time outs before with 
> >   powersaving enabled:
> > 	Fetched 89.7MB in 30s (2926kB/s)
> > 
> 
> Does this mean that the "Arrived at non-free entry" messages are gone with
> power-saving enabled?
[...]

I've never seen that message, neither does the system crash or freeze - 
rt61pci is just almost unusable due to the packet loss and the latencies with 
powersaving enabled (I don't see this problem in the same environment with 
rt2500usb/ rt73usb or b43 (bcm4306, bcm4318), rtl8187b, ath5k, ar9170usb, 
zd1211rw).

Regards
	Stefan Lippers-Hollmann
