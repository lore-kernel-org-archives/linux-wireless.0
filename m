Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:47762 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912AbXJULiI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Oct 2007 07:38:08 -0400
Date: Sun, 21 Oct 2007 13:38:15 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: rt2400-devel@lists.sourceforge.net,
	kernel list <linux-kernel@vger.kernel.org>,
	linux-wireless@vger.kernel.org, mwallis@serialmonkey.com
Subject: Re: [Rt2400-devel] rt73usb: support for wireless in Kohjinsha
	subnotebook
Message-ID: <20071021113815.GF25270@elf.ucw.cz> (sfid-20071021_123822_185697_C438FC4D)
References: <20071020184100.GA11640@elf.ucw.cz> <200710210012.37547.IvDoorn@gmail.com> <20071021092138.GC25270@elf.ucw.cz> <200710211549.44955.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200710211549.44955.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun 2007-10-21 15:49:44, Ivo van Doorn wrote:
> On Sunday 21 October 2007, Pavel Machek wrote:
> > Hi!
> > 
> > > > Kohjinsha subnotebook seems to contain wifi with USB IDs 0x18e8,
> > > > 0x6206... I hope that to be compatible with
> > > > net/wireless/rt2x00/rt73usb.c .
> > > 
> > > Is there any reason you assume it is a rt73usb device,
> > > or are you just making wild guesses about what the chipset is?
> > 
> > Wild guess. I've seen 18e8:6XXX being handled by rt73usb, so..
> 
> Thats an incorrect assumption. USB ID's listed in rt73usb don't even
> guarentee that the device contains a rt73usb chipset since some manufacturers
> produce cards with different chipsets while keeping the USB ID the same.
> So the case that the card false in the 6xxx range says absolutely _nothing_.

Well, see the other mail, it seems like rt73usb partially communicates
with the card.

What info would be useful in determining what is this card similar to?
Boot windows and look for driver name?
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
