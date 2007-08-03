Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.186]:22256 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760858AbXHCRq2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Aug 2007 13:46:28 -0400
Received: by rv-out-0910.google.com with SMTP id k20so728281rvb
        for <linux-wireless@vger.kernel.org>; Fri, 03 Aug 2007 10:46:27 -0700 (PDT)
Message-ID: <f6ca9fed0708031046x639fc799wbec08f2c8e2c7536@mail.gmail.com>
Date: Fri, 3 Aug 2007 19:46:26 +0200
From: dragoran <drago01@gmail.com>
To: "Ivo van Doorn" <ivdoorn@gmail.com>
Subject: Re: rt2500usb stopped working (vendor request error)
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <200708031848.03469.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <46B1B0AE.7050205@gmail.com> <200708022306.33486.IvDoorn@gmail.com>
	 <46B2E533.2000808@gmail.com> <200708031848.03469.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

no I havn't I will try it tomorrow and tell you if it worked.
but as I said before a earilier version of the driver worked before on
fc6 without any problems.

On 8/3/07, Ivo van Doorn <ivdoorn@gmail.com> wrote:
> On Friday 03 August 2007, dragoran wrote:
> > Ivo van Doorn wrote:
> > > do you have the USB stick plugged into a USB 1.1 port?
> > > If so, could you edit rt2x00usb.h and change the line:
> > >
> > > #define REGISTER_TIMEOUT      20
> > >
> > > And increase the value to something higher (up to 500) and see if that
> works better?
> > >
> > > Just an idea related to another bug report regarding vendor request
> > > errors,
> > 1) tested todays snapshot:
> > same results.
> > 2) increased the timeout didn't help.
> > "usb 2-2: new high speed USB device using ehci_hcd and address"
> > so its a usb2 device.
> > any other ideas?
>
> Have you tried using the legacy driver?
> I'm curious if the same problem exist in there are well...
>
> Ivo
>
