Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:65503 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751822AbYH2R4q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Aug 2008 13:56:46 -0400
Message-ID: <48B8385D.5020008@lwfinger.net> (sfid-20080829_195650_848116_0EAA2142)
Date: Fri, 29 Aug 2008 12:56:45 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Susan Higashi <susanhigashi@gmail.com>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: Re: Wireless Problems - Ubuntu 8.04
References: <b81ef96c0808271712t6ba1124cs6597a0efb8b6f0ea@mail.gmail.com>	 <14b026160808280046h5c9787c9m4eee1c6cccbad949@mail.gmail.com>	 <b81ef96c0808280444g2be951efxe9c6704db7f1f4fc@mail.gmail.com>	 <48B6C1FD.6060001@lwfinger.net>	 <b81ef96c0808281034g4360a9f9n261a55fda221e5b0@mail.gmail.com>	 <48B6E8D5.5050003@lwfinger.net> <b81ef96c0808291040m669c1f66t6c60f199e4cb4bcf@mail.gmail.com>
In-Reply-To: <b81ef96c0808291040m669c1f66t6c60f199e4cb4bcf@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Susan Higashi wrote:
> I tried  'sudo /sbin/modprobe -rv rtl8180', and the message appered: 
> "FATAL: Module rtl8180 not found."

Obviously, Ubuntu did not configure your device, thus the rtl8180 
driver is not available. First of all, you need to conttact Ubuntu to 
discover if this has been changed for Hardy kernels, or if this driver 
is enabled in the Intrepid alpha kernels. If not, then you need to 
either build compat-wireless, or apt-get the parts needed to build a 
kernel so that you can add this driver to the configuration. The 
instructions on how to build and install your own kernel for Ubuntu 
and any other Debian-based system are well covered on the Web, and are 
way off topic for this mailing list.

> So, I tried iwconfig the following happened: "lo        no wireless 
> extensions." and "eth0      no wireless extensions."
> I also tried the steps in this link:  
> http://rtl-wifi.sourceforge.net/wiki/Installing, which looked to work, 
> but it didn't work.... =(

All of the above are expected.

Larry
