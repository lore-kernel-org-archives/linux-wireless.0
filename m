Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:45794 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753025Ab0D1Mxn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Apr 2010 08:53:43 -0400
From: Holger Schurig <holgerschurig@gmail.com>
To: RHS Linux User <xxx@nei.mv.com>
Subject: Re: [ath9k-devel] ath9k: noise floor calibration process
Date: Wed, 28 Apr 2010 14:53:39 +0200
Cc: Benoit PAPILLAULT <benoit.papillault@free.fr>,
	"ath9k-devel" <ath9k-devel@lists.ath9k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <Pine.LNX.3.95.1100428051914.9331G-100000@nei>
In-Reply-To: <Pine.LNX.3.95.1100428051914.9331G-100000@nei>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201004281453.39817.holgerschurig@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>    In the USA Amateur radio operators can use 1000 Watts (under certain
> conditions) !!

Don't count on the 1000 W. Most countries have tight restrictions, only 
allowing certain frequencies, bandwiths, max PEP, max ERP, max EIRP, max 
electric field, max magnetic fields.

In Germany, with my license class, I can use up to 75W PEP in the frequency 
range 2320-2450 MHz. So, way less than 1000W. But I don't care, I wouldn't 
want to use 1000 W anyway. That's quite dangerous, e.g. if someone moves too 
near to the transmitting antenna.


> It is VERY surprising that no chips I am aware of provide directly for
> support of an external low noise preamp AND on a seperate coax a REAL
> amplifier.

However, as licensed ham radio op, I'm allowed to build and use self-build 
equipment. That means, I'm not restricted to use only certified devices, e.g. 
I don't need some FCC or ZZF or whatever number on my equipment. So I'm 
perfectly eligible to add some pre-amp. And guess what, for frequencies above 
100 MHz it's quite common to use low-noise pre-amps. Many HAMs do this, and 
also every satellite dish LNB does this.

I don't no chip "allowing" me this, I simply attach the pre-amp as near to the 
antenna as possible. How would a chip be able to prevent that anyway ?!?

Any WLAN chip provides for a separate coax. Again, how would a chip prevent 
against that?  Only some hybrid chip with built-in antenne could possible 
prevent me doing that. But maybe you don't mean chips, but devices?  Most USB 
dongles that I've seen won't provide a coax connector. But I have a bunch of 
PC-Card wlan cards with some SMA (or similar) coax connectors. And for Mini-
PCI cards it's the common case to provide some coax socket.


> Now two high powered, low noise Acess Points with a clear line of sight
> would give some real range!

Clear line of sight is nice, clear fresnel zone would be better.


Actually, what you're talking already happens already. It's called HAMNET.  
Some english language link that I found:

http://db0fhn.efi.fh-nuernberg.de/doku.php?id=projects:wlan:hamnet

Oh, and they use atheros hardware :-)
