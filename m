Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.186]:65319 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754956AbXHBVCU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Aug 2007 17:02:20 -0400
Received: by nf-out-0910.google.com with SMTP id g13so167037nfb
        for <linux-wireless@vger.kernel.org>; Thu, 02 Aug 2007 14:02:19 -0700 (PDT)
To: dragoran <drago01@gmail.com>
Subject: Re: rt2500usb stopped working (vendor request error)
Date: Thu, 2 Aug 2007 23:06:33 +0200
Cc: linux-wireless@vger.kernel.org
References: <46B1B0AE.7050205@gmail.com> <200708021614.29385.IvDoorn@gmail.com> <f6ca9fed0708020756r7af012a0gd2a72009265a5000@mail.gmail.com>
In-Reply-To: <f6ca9fed0708020756r7af012a0gd2a72009265a5000@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200708022306.33486.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> I upgraded the kernel since than to  to  this version.
> 
> And regarding the patches, last tuesday I have released rt2x00 2.0.5 which
> > was then merged with wireless-dev, but the release itself contained quite
> > a lot of patches...
> 
> 
> ok I will compile a wireless-dev snapshot and when I get home and tell you
> if it worked or not.

Just an idea related to another bug report regarding vendor request errors,
do you have the USB stick plugged into a USB 1.1 port?
If so, could you edit rt2x00usb.h and change the line: 

#define REGISTER_TIMEOUT      20

And increase the value to something higher (up to 500) and see if that works better?

Thanks,

Ivo
