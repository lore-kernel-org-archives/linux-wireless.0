Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ik-out-1112.google.com ([66.249.90.177]:6825 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754319AbYHSU1W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Aug 2008 16:27:22 -0400
Received: by ik-out-1112.google.com with SMTP id c28so99745ika.5
        for <linux-wireless@vger.kernel.org>; Tue, 19 Aug 2008 13:27:21 -0700 (PDT)
To: "Alex Riesen" <raa.lkml@gmail.com>
Subject: Re: rt2500pci: false alarm (was rt2500pci_bbp_read: Error - BBPCSR register busy. Read failed)
Date: Tue, 19 Aug 2008 22:25:44 +0200
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
References: <81b0412b0808191208y6bef9187nc57fa74c08a92d54@mail.gmail.com>
In-Reply-To: <81b0412b0808191208y6bef9187nc57fa74c08a92d54@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200808192225.45030.IvDoorn@gmail.com> (sfid-20080819_222728_151671_945C726E)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 19 August 2008, Alex Riesen wrote:
> 2008/8/19 Alex Riesen <raa.lkml@gmail.com>:
> > 2008/8/19 Ivo van Doorn <ivdoorn@gmail.com>:
> >>> The rt2500 driver in 2.6.27-rc3 (v2.6.27-rc3-552-g3c3a15a) constantly
> >>> produces a lot of this messages in log (slowdown quite noticable):
> >>>
> >>>     kernel: phy0 -> rt2500pci_bbp_read: Error - BBPCSR register busy. Read failed.
> >
> > It surely did, but I honestly don't remember what with. I'll try to bisect.
> >
> 
> Ok, it _is_ the hardware. Precisely: it is a dusty box in a dark humid corner.
> I reseated the card and suddenly everything started working.
> 
> I'm really sorry. The error description was actually a very good
> hint at the problem.

Well good to hear that at least the card itself isn't broken and it was
only a matter of moving the card a bit to make it work. :)

Ivo
