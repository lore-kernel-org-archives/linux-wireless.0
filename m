Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:42659 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751421Ab0H3XVF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Aug 2010 19:21:05 -0400
Received: by fxm13 with SMTP id 13so3633943fxm.19
        for <linux-wireless@vger.kernel.org>; Mon, 30 Aug 2010 16:21:03 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Julian Calaby <julian.calaby@gmail.com>
Subject: Re: [RFT 6/6] carl9170usb: Makefile, Kconfig files and MAINTAINERS
Date: Tue, 31 Aug 2010 01:20:59 +0200
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>
References: <201008302242.19395.chunkeey@googlemail.com> <AANLkTinXJN7q3CXLVxNP=S2fGQHQJxLEmwvbAV17+Q_i@mail.gmail.com>
In-Reply-To: <AANLkTinXJN7q3CXLVxNP=S2fGQHQJxLEmwvbAV17+Q_i@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201008310121.00085.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 31 August 2010 00:45:42 Julian Calaby wrote:
> On Tue, Aug 31, 2010 at 06:42, Christian Lamparter
> <chunkeey@googlemail.com> wrote:
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index 63e441b..1f10089 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -1119,6 +1119,7 @@ L:        linux-wireless@vger.kernel.org
> >  W:     http://wireless.kernel.org/en/users/Drivers/ar9170
> >  S:     Maintained
> >  F:     drivers/net/wireless/ath/ar9170/
> > +F:     drivers/net/wireless/ath/carl9170/
> >
> >  ATK0110 HWMON DRIVER
> >  M:     Luca Tettamanti <kronos.it@gmail.com>
> 
> As carl9170 has a separate website, would it make sense for it to also
> have a separate MAINTAINERS entry?
On one hand the driver is based on ar9170 and uses the same device,
but having an separate entry might be favorable when ar9170usb is
dropped...

> Also, patch 1/6 is signed off by root, you may want to fix that.
Thanks!

---

By the way:

ALL COMPAT-WIRELESS USERS WITH OLDER KERNELS (older than 2.6.36-rc1, 2.6.35.2,
etc...) have to apply this patch:
> https://patchwork.kernel.org/patch/118946/
(Or, suffer from panics.)
