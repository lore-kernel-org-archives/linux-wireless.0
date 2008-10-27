Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:39652 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751153AbYJ0AbH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Oct 2008 20:31:07 -0400
Message-ID: <49050BC7.1010609@lwfinger.net> (sfid-20081027_013113_098623_49798ADD)
Date: Sun, 26 Oct 2008 17:31:03 -0700
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Piter PUNK <piterpk@terra.com.br>
CC: linux-wireless@vger.kernel.org
Subject: Re: RTL8187B transmit problems
References: <49041DAE.1060206@terra.com.br>
In-Reply-To: <49041DAE.1060206@terra.com.br>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Piter PUNK wrote:
> 
> Hi,
> 
> I did some new tests to see what's my transmission problems with
> rtl8187b. I can associate and can send pings (and even to connect
> through ssh with other hosts) but i can't transmit "big" files. But
> at first mail I didn't know how big must be a "big" file.
> 
> I tested with 64, 128, 256, 512, 1024 and 2048 bytes files. From 64 to
> 512 I always can transmit the file. 1024 sometimes hangs and 2048
> always hangs. All files can be transmitted using rt73usb wireless.

I have not downloaded your tcpdump file yet to see your details. On my system, I
am unable to duplicate your results. I used dd with /dev/urandom as the source
to create files of 1024, 2048, 4096, 8192, 16384, and 32768 bytes. All of these
could be transmitted to a second host on my local network using scp.

What are the details of your device? Please post the output of 'dmesg | grep -i
rtl'.

Larry


