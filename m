Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.240]:16546 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751395AbXB0BWf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Feb 2007 20:22:35 -0500
Received: by an-out-0708.google.com with SMTP id b33so986720ana
        for <linux-wireless@vger.kernel.org>; Mon, 26 Feb 2007 17:22:34 -0800 (PST)
Message-ID: <9e4733910702261722u49646035m5228b441e68021e5@mail.gmail.com>
Date: Mon, 26 Feb 2007 20:22:33 -0500
From: "Jon Smirl" <jonsmirl@gmail.com>
To: linux-wireless@vger.kernel.org, "Greg KH" <greg@kroah.com>
Subject: 802.11 class for USB devices
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Any interest in doing this?

---------- Forwarded message ----------
From: Greg KH <greg@kroah.com>
Date: Feb 26, 2007 7:22 PM
Subject: Re: [linux-usb-devel] Docs for common class implementations
To: Jon Smirl <jonsmirl@gmail.com>
Cc: Oliver Neukum <oliver@neukum.org>, linux-usb-devel@lists.sourceforge.net


On Mon, Feb 26, 2007 at 04:55:51PM -0500, Jon Smirl wrote:
> On 2/26/07, Oliver Neukum <oliver@neukum.org> wrote:
> > Am Montag, 26. Februar 2007 22:39 schrieb Jon Smirl:
> > > On 2/26/07, Jon Smirl <jonsmirl@gmail.com> wrote:
> > > > How about the wireless class, has anyone actually build a wireless
> > > > class device yet?
> > > > The dscape people should be integrating wireless USB class support
> > > > into their stack.
> > >
> > > I found the wireless class spec.
> > > http://www.usb.org/developers/devclass_docs/cdc_wmc10.zip
> >
> > This is intended for cell phones, not 802.11.
>
> USB group should do a spec for 802.11. All the devices I've seen are
> 95% similar in function but it is all vendor specific implementations.
> It would help solve the problem of 802.11 vendors refusing to release
> documentation for their "IP" (which turns out to not be any different
> between the vendors after the devices are reverse engineered).

Then create one.  The USB specification process is very company driven,
if you want to create a new spec, you get a few people together and do
it and then release it to the group and then everyone submits proposals
to clean it up and make it relativly sane.

I participated in the creating of many USB specs a long time ago and it
was a very open process, as long as you were a member of the USB
interface group, which most companies are.

thanks,

greg k-h


-- 
Jon Smirl
jonsmirl@gmail.com
