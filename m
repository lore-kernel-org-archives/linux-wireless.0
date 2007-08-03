Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.171]:31948 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762484AbXHCPBa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Aug 2007 11:01:30 -0400
Received: by ug-out-1314.google.com with SMTP id j3so472986ugf
        for <linux-wireless@vger.kernel.org>; Fri, 03 Aug 2007 08:01:29 -0700 (PDT)
To: dragoran <drago01@gmail.com>
Subject: Re: rt2500usb stopped working (vendor request error)
Date: Fri, 3 Aug 2007 17:05:57 +0200
Cc: linux-wireless@vger.kernel.org
References: <46B1B0AE.7050205@gmail.com> <200708022306.33486.IvDoorn@gmail.com> <46B2E533.2000808@gmail.com>
In-Reply-To: <46B2E533.2000808@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200708031705.57672.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 03 August 2007, dragoran wrote:
> Ivo van Doorn wrote:
> > do you have the USB stick plugged into a USB 1.1 port?
> > If so, could you edit rt2x00usb.h and change the line: 
> >
> > #define REGISTER_TIMEOUT      20
> >
> > And increase the value to something higher (up to 500) and see if that works better?
> >   
> > Just an idea related to another bug report regarding vendor request 
> > errors,
> 1) tested todays snapshot:
> same results.
> 2) increased the timeout didn't help.
> "usb 2-2: new high speed USB device using ehci_hcd and address"
> so its a usb2 device.
> any other ideas?

Nope not at this time,
I'll look into the issue some more and see what might cause this.

Ivo
