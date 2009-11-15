Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.27]:31100 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753053AbZKOOS1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Nov 2009 09:18:27 -0500
Received: by ey-out-2122.google.com with SMTP id 9so1624446eyd.19
        for <linux-wireless@vger.kernel.org>; Sun, 15 Nov 2009 06:18:32 -0800 (PST)
Message-ID: <4B000DAB.10305@gmail.com>
Date: Sun, 15 Nov 2009 15:18:19 +0100
From: Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
To: sturmflut@lieberbiber.de
CC: rt2x00 Users List <users@rt2x00.serialmonkey.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [rt2x00-users] Kernel Bug using current rt2x00usb and an RT2070L
 device
References: <200911151403.56479.sturmflut@lieberbiber.de>
In-Reply-To: <200911151403.56479.sturmflut@lieberbiber.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/15/09 14:03, Simon Raffeiner wrote:
> Hi lists,
> 
> I built the current compat-wireless on a stock Ubuntu 2.6.31-14-generic kernel (Ubuntu 9.10 Karmic Koala), plugged in my Sitecom WL-608v1 USB adapter (USB ID 0df6:003f) and hit the following kernel Bug:
> 
> [ 3097.169534] ------------[ cut here ]------------                                    
> [ 3097.169538] kernel BUG at /home/sturmflut/compat-wireless-2.6/drivers/net/wireless/rt2x00/rt2x00usb.c:86!                                                                  
> [ 3097.169541] invalid opcode: 0000 [#1] SMP                                           
> [ 3097.169544] last sysfs file: /sys/devices/pci0000:00/0000:00:18.3/temp1_input       
> [ 3097.169546] CPU 0                                                                   

Hi,

I sent a patch to fix this just yesterday. See:

http://marc.info/?l=linux-wireless&m=125822646218485&w=2

---
Gertjan.

