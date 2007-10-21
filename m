Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.168]:59421 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253AbXJULbU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Oct 2007 07:31:20 -0400
Received: by ug-out-1314.google.com with SMTP id z38so789978ugc
        for <linux-wireless@vger.kernel.org>; Sun, 21 Oct 2007 04:31:19 -0700 (PDT)
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [Rt2400-devel] rt73usb: support for wireless in Kohjinsha subnotebook
Date: Sun, 21 Oct 2007 15:49:44 +0200
Cc: rt2400-devel@lists.sourceforge.net,
	kernel list <linux-kernel@vger.kernel.org>,
	linux-wireless@vger.kernel.org, mwallis@serialmonkey.com
References: <20071020184100.GA11640@elf.ucw.cz> <200710210012.37547.IvDoorn@gmail.com> <20071021092138.GC25270@elf.ucw.cz>
In-Reply-To: <20071021092138.GC25270@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200710211549.44955.IvDoorn@gmail.com> (sfid-20071021_123132_365503_8B7FF0CC)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 21 October 2007, Pavel Machek wrote:
> Hi!
> 
> > > Kohjinsha subnotebook seems to contain wifi with USB IDs 0x18e8,
> > > 0x6206... I hope that to be compatible with
> > > net/wireless/rt2x00/rt73usb.c .
> > 
> > Is there any reason you assume it is a rt73usb device,
> > or are you just making wild guesses about what the chipset is?
> 
> Wild guess. I've seen 18e8:6XXX being handled by rt73usb, so..

Thats an incorrect assumption. USB ID's listed in rt73usb don't even
guarentee that the device contains a rt73usb chipset since some manufacturers
produce cards with different chipsets while keeping the USB ID the same.
So the case that the card false in the 6xxx range says absolutely _nothing_.

Ivo
