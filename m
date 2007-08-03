Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.191]:12749 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753431AbXHCQnh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Aug 2007 12:43:37 -0400
Received: by fk-out-0910.google.com with SMTP id z23so731284fkz
        for <linux-wireless@vger.kernel.org>; Fri, 03 Aug 2007 09:43:36 -0700 (PDT)
To: dragoran <drago01@gmail.com>
Subject: Re: rt2500usb stopped working (vendor request error)
Date: Fri, 3 Aug 2007 18:48:02 +0200
Cc: linux-wireless@vger.kernel.org
References: <46B1B0AE.7050205@gmail.com> <200708022306.33486.IvDoorn@gmail.com> <46B2E533.2000808@gmail.com>
In-Reply-To: <46B2E533.2000808@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200708031848.03469.IvDoorn@gmail.com>
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

Have you tried using the legacy driver?
I'm curious if the same problem exist in there are well...

Ivo
