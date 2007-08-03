Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hu-out-0506.google.com ([72.14.214.226]:15827 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752263AbXHCIUJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Aug 2007 04:20:09 -0400
Received: by hu-out-0506.google.com with SMTP id 19so487523hue
        for <linux-wireless@vger.kernel.org>; Fri, 03 Aug 2007 01:20:06 -0700 (PDT)
Message-ID: <46B2E533.2000808@gmail.com>
Date: Fri, 03 Aug 2007 10:20:03 +0200
From: dragoran <drago01@gmail.com>
MIME-Version: 1.0
To: Ivo van Doorn <ivdoorn@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: rt2500usb stopped working (vendor request error)
References: <46B1B0AE.7050205@gmail.com> <200708021614.29385.IvDoorn@gmail.com> <f6ca9fed0708020756r7af012a0gd2a72009265a5000@mail.gmail.com> <200708022306.33486.IvDoorn@gmail.com>
In-Reply-To: <200708022306.33486.IvDoorn@gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ivo van Doorn wrote:
> do you have the USB stick plugged into a USB 1.1 port?
> If so, could you edit rt2x00usb.h and change the line: 
>
> #define REGISTER_TIMEOUT      20
>
> And increase the value to something higher (up to 500) and see if that works better?
>   
> Just an idea related to another bug report regarding vendor request 
> errors,
1) tested todays snapshot:
same results.
2) increased the timeout didn't help.
"usb 2-2: new high speed USB device using ehci_hcd and address"
so its a usb2 device.
any other ideas?
