Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:59129 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751245AbYHIAa5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Aug 2008 20:30:57 -0400
Message-ID: <489CE53B.6050204@lwfinger.net> (sfid-20080809_023101_078252_8E51DEED)
Date: Fri, 08 Aug 2008 19:30:51 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Max Siegel <max8455@hotmail.com>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: Re: Broadcom card wont pickup access point signal
References: <BAY131-W2D0DB5F6073D518843613B7740@phx.gbl> <489CDD4B.1050400@lwfinger.net> <BAY131-W6F7D0B2EA6D7DC6EB07B4B7770@phx.gbl>
In-Reply-To: <BAY131-W6F7D0B2EA6D7DC6EB07B4B7770@phx.gbl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Max Siegel wrote:
> Thank you for your quick answer.  I will try and update the kernel, but 
> I don't know how.  If you can link me a guide that would be of great 
> help, if not I will be searching google.

The first step is to download the kernel source from 
http://www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.26.2.tar.bz2. 
Open a terminal and unpack it with a 'tar jxvf linux-2.6.26.2.tar.bz2' 
command. The download is 47 MB.

The next step is to make sure that you have the c compiler and make 
routine installed. You can do this by entering the commands 'gcc' and 
'make'. If either of them returns a "command not found" message, then 
you need to get them for your distribution.

At this point do a 'cd linux-2.6.26.2' command and look for the 
configuration used by your distro. I use openSUSE which puts the 
configuration at /proc/config.gz. Other distros place it in /boot. As 
I don't know where yours is, I cannot help you more. From here you 
should look at Google to find how to build a kernel for your distro.

Larry

