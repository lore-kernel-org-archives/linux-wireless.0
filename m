Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:52704 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755906Ab2ERPlw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 May 2012 11:41:52 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1SVPJO-0004BK-Fs
	for linux-wireless@vger.kernel.org; Fri, 18 May 2012 17:41:50 +0200
Received: from lns-bzn-48f-81-56-242-144.adsl.proxad.net ([81.56.242.144])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 18 May 2012 17:41:50 +0200
Received: from alexandre.alouit by lns-bzn-48f-81-56-242-144.adsl.proxad.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 18 May 2012 17:41:50 +0200
To: linux-wireless@vger.kernel.org
From: Alex Alouit <alexandre.alouit@gmail.com>
Subject: Re: Module Carl9170, firmware won't load properly
Date: Fri, 18 May 2012 15:41:41 +0000 (UTC)
Message-ID: <loom.20120518T173625-20@post.gmane.org> (sfid-20120518_174156_336145_F9FD73D8)
References: <loom.20120517T011514-623@post.gmane.org> <201205171207.40795.chunkeey@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Christian Lamparter <chunkeey@...> writes:


> > (carl9170-1.fw in /usr/local/lib/firmware version 1.9.2 (kernel 3.0.23)) 
> > but it seems that the module doesn't load correctly the firmware. 
> that's pretty old. you can go with compat-wireless and a more recent firmware.


Same things with Debian Wheezy (kernel 3.2.0-2-amd64) 
with firmware 1.9.4 and 1.9.5.
They are more recent.

[57471.355695] usb 1-1: driver   API: 1.9.4 2011-08-15 [1-1]
[57471.355707] usb 1-1: firmware API: 1.9.5 2012-03-14
[57471.456617] usb 1-1: firmware upload failed (-110)

What do you think I should do?

