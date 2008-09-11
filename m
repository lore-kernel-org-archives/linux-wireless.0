Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:48919 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752390AbYIKPCe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Sep 2008 11:02:34 -0400
Subject: Re: Crash with 2.6.27-rc6 with iwlwifi
From: Marcel Holtmann <holtmann@linux.intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1221129382.6986.0.camel@johannes.berg>
References: <E3A88D93-F0D2-476E-B162-08687FC602E3@linux.intel.com>
	 (sfid-20080911_100535_000722_EE099914)  <1221129382.6986.0.camel@johannes.berg>
Content-Type: text/plain
Date: Thu, 11 Sep 2008 17:03:03 +0200
Message-Id: <1221145383.6309.12.camel@californication> (sfid-20080911_170238_255645_53CA6C1F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

> > so since a few 2.6.27 kernels I haven an issue when using my 4965  
> > wireless card. So the machine in question is an X61 and when enabling  
> > WiFi and Bluetooth at the same time it will freeze hard after a few  
> > minutes. It seems activating Bluetooth has something to do with it,  
> > but I have been using the machine for Bluetooth qualification testing  
> > (with WiFi disabled) and everything works fine.
> > 
> > However I tried to reproduce it without Bluetooth enabled, it didn't  
> > show or I didn't wait long enough. Once I started bluetoothd it showed  
> > within a few minutes.
> > 
> > So the best I got was the attached screenshot of an oops. It is  
> > clearly the iwlwifi driver crashing here and killing the machine, but  
> > I have no idea why.
> 
> That looks like the use-after-free BUG_ON I've been getting with a 5k
> card, do you have sl*b debugging enabled?

I have CONFIG_SLUB_DEBUG=y in this kernel. Including all sorts of kernel
debugging features enabled. Anything else I would need to give better
feedback?

Regards

Marcel


