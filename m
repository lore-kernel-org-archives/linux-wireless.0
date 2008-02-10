Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.155]:6922 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753660AbYBJMWf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Feb 2008 07:22:35 -0500
Received: by fg-out-1718.google.com with SMTP id e21so3465363fga.17
        for <linux-wireless@vger.kernel.org>; Sun, 10 Feb 2008 04:22:31 -0800 (PST)
Message-ID: <efe7343f0802100422o2cba8ec2iaae3916cccd932b9@mail.gmail.com> (sfid-20080210_122238_212008_96ED281B)
Date: Sun, 10 Feb 2008 12:22:30 +0000
From: "Luis Correia" <luis.f.correia@gmail.com>
To: "Michael Buesch" <mb@bu3sch.de>
Subject: Re: [PATCH] rt2x00: Add new USB ID to rt2500usb
Cc: "Ivo van Doorn" <ivdoorn@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200802101131.13974.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <200802101121.58058.IvDoorn@gmail.com>
	 <200802101131.13974.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Feb 10, 2008 at 10:31 AM, Michael Buesch <mb@bu3sch.de> wrote:
> On Sunday 10 February 2008 11:21:57 Ivo van Doorn wrote:
>  >
>  > Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
>  > ---
>  > John, please send this patch to the 2.6.24/2.6.25 stable trees.
>  > It is already present in the wireless-2.6 tree queued for 2.6.26.
>  >
>  >  drivers/net/wireless/rt2x00/rt2500usb.c |    2 +-
>  >  1 files changed, 1 insertions(+), 1 deletions(-)
>  >
>  > diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
>  > index cba7f57..c4a6ab4 100644
>  > --- a/drivers/net/wireless/rt2x00/rt2500usb.c
>  > +++ b/drivers/net/wireless/rt2x00/rt2500usb.c
>  > @@ -1871,11 +1871,11 @@ static struct usb_device_id rt2500usb_device_table[] = {
>  >       /* Hercules */
>  >       { USB_DEVICE(0x06f8, 0xe000), USB_DEVICE_DATA(&rt2500usb_ops) },
>  >       /* Melco */
>  > +     { USB_DEVICE(0x0411, 0x005e), USB_DEVICE_DATA(&rt2500usb_ops) },
>  >       { USB_DEVICE(0x0411, 0x0066), USB_DEVICE_DATA(&rt2500usb_ops) },
>  >       { USB_DEVICE(0x0411, 0x0067), USB_DEVICE_DATA(&rt2500usb_ops) },
>  >       { USB_DEVICE(0x0411, 0x008b), USB_DEVICE_DATA(&rt2500usb_ops) },
>  >       { USB_DEVICE(0x0411, 0x0097), USB_DEVICE_DATA(&rt2500usb_ops) },
>  > -
>  >       /* MSI */
>  >       { USB_DEVICE(0x0db0, 0x6861), USB_DEVICE_DATA(&rt2500usb_ops) },
>  >       { USB_DEVICE(0x0db0, 0x6865), USB_DEVICE_DATA(&rt2500usb_ops) },
>
>  I'm unsure on how this is an actual _fix_ that we need in a stable kernel.
>  We always handled adding IDs as features.

Please forgive me for stepping in this apparently already closed discussion.

Why is supporting a new USB ID considered a feature, when the users
are probably ok with it (it works) and no changes are added to the
code?

Luis Correia
rt2x00 project admin

>
>  --
>  Greetings Michael.
>
>
> -
>  To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>  the body of a message to majordomo@vger.kernel.org
>  More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
