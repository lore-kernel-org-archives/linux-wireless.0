Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:45752 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754283AbZG2MIl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jul 2009 08:08:41 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1MW7xY-0006SF-DN
	for linux-wireless@vger.kernel.org; Wed, 29 Jul 2009 12:08:40 +0000
Received: from dslb-084-058-206-191.pools.arcor-ip.net ([84.58.206.191])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2009 12:08:40 +0000
Received: from acid-burn by dslb-084-058-206-191.pools.arcor-ip.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2009 12:08:40 +0000
To: linux-wireless@vger.kernel.org
From: Mladen Horvat <acid-burn@opendreambox.org>
Subject: Re: zd1211rw couldn't load firmware. Error number -145 with Kernel 2.6.30
Date: Wed, 29 Jul 2009 12:08:28 +0000 (UTC)
Message-ID: <loom.20090729T120228-576@post.gmane.org>
References: <loom.20090729T111851-320@post.gmane.org> <200907291350.27426.hs4233@mail.mn-solutions.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Holger Schurig <hs4233@...> writes:

> 
> > [  415.271000] usb 1-1: upload_firmware() 
> > firmware device id 0x4810 is equal to the actual device id
> 
> Looks like your firmware could be successfully loaded and checked 
> by the driver.
> 
> > [  416.350000] usb 1-1: USB control request for firmware
> > upload failed. Error number -145
> 
> Looks like an URB (USB request block) couldn't transferred to the 
> device. As you speak about an embedded device: are you sure that 
> your USB hardware works correctly?
> 


Hello Holger,

thanks for your fast answer.

I hope to be sure that the usb hardware works correctly.
As i said, the same stb only booted with a rt73usb wlan stick attached has no
problems with the firmware upload and also wpa-supplicant connection and
everything works on wlan0.  only problem are these two zd1211b usb sticks in the
zd1211rw driver.

the same stb running a kernel 2.6.12 and the original vendor driver 2.22.00
works without problems..

so i think i can exclude a hardware bug on the usb/stb side.

Hope this helps. 
If any other logs are needed i will provide them.


Regards

Mladen



