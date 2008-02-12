Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3790 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752355AbYBLQb2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Feb 2008 11:31:28 -0500
Date: Tue, 12 Feb 2008 11:05:07 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Luis Correia <luis.f.correia@gmail.com>
Cc: Michael Buesch <mb@bu3sch.de>, Ivo van Doorn <ivdoorn@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rt2x00: Add new USB ID to rt2500usb
Message-ID: <20080212160507.GC3051@tuxdriver.com> (sfid-20080212_163132_757768_C742DAC4)
References: <200802101121.58058.IvDoorn@gmail.com> <200802101131.13974.mb@bu3sch.de> <efe7343f0802100422o2cba8ec2iaae3916cccd932b9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <efe7343f0802100422o2cba8ec2iaae3916cccd932b9@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Feb 10, 2008 at 12:22:30PM +0000, Luis Correia wrote:
> On Sun, Feb 10, 2008 at 10:31 AM, Michael Buesch <mb@bu3sch.de> wrote:
> > On Sunday 10 February 2008 11:21:57 Ivo van Doorn wrote:

> >  > @@ -1871,11 +1871,11 @@ static struct usb_device_id rt2500usb_device_table[] = {
> >  >       /* Hercules */
> >  >       { USB_DEVICE(0x06f8, 0xe000), USB_DEVICE_DATA(&rt2500usb_ops) },
> >  >       /* Melco */
> >  > +     { USB_DEVICE(0x0411, 0x005e), USB_DEVICE_DATA(&rt2500usb_ops) },
> >  >       { USB_DEVICE(0x0411, 0x0066), USB_DEVICE_DATA(&rt2500usb_ops) },
> >  >       { USB_DEVICE(0x0411, 0x0067), USB_DEVICE_DATA(&rt2500usb_ops) },
> >  >       { USB_DEVICE(0x0411, 0x008b), USB_DEVICE_DATA(&rt2500usb_ops) },
> >  >       { USB_DEVICE(0x0411, 0x0097), USB_DEVICE_DATA(&rt2500usb_ops) },
> >  > -
> >  >       /* MSI */
> >  >       { USB_DEVICE(0x0db0, 0x6861), USB_DEVICE_DATA(&rt2500usb_ops) },
> >  >       { USB_DEVICE(0x0db0, 0x6865), USB_DEVICE_DATA(&rt2500usb_ops) },
> >
> >  I'm unsure on how this is an actual _fix_ that we need in a stable kernel.
> >  We always handled adding IDs as features.
> 
> Please forgive me for stepping in this apparently already closed discussion.
> 
> Why is supporting a new USB ID considered a feature, when the users
> are probably ok with it (it works) and no changes are added to the
> code?

FWIW, I have often sent USB/PCI ID additions as "fixes" to the current
release.  There may have been some confusion over that in the past --
if I created that confusion, I apologize. :-)

Thanks,

John
-- 
John W. Linville
linville@tuxdriver.com
