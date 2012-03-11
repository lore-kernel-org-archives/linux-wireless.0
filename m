Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:55736 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752528Ab2CKEXq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Mar 2012 23:23:46 -0500
Received: by iagz16 with SMTP id z16so4769640iag.19
        for <linux-wireless@vger.kernel.org>; Sat, 10 Mar 2012 20:23:45 -0800 (PST)
Message-ID: <4F5C28CE.7020001@lwfinger.net> (sfid-20120311_052421_276242_D3DC0EF2)
Date: Sat, 10 Mar 2012 22:23:42 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: alupu@verizon.net
CC: linux-wireless@vger.kernel.org
Subject: Re: r8712u staging in kernel 3.2.9
References: <7971088.142916.1331403052068.JavaMail.root@vznit170136>
In-Reply-To: <7971088.142916.1331403052068.JavaMail.root@vznit170136>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Alex,

I was not doing any finger pointing. Your system is everything - hardware, 
kernel, and user-space routines. Obviously something is not working.

I have a Rosewill RNX-N180UBE. The chip is a RTL8191RU, but appears to be 
programmed the same as the RTL8191SU. Mine works with the standard r8712u driver.

The two possible firmware files have the following md5sum:

200fd952db3cc9259b1fd05e3e51966f  /lib/firmware/rtlwifi/rtl8712u.bin_122328
8e6396b5844a3e279ae8679555dec3f0  /lib/firmware/rtlwifi/rtl8712u.bin_129304

Could you please download a Live KDE CD from
http://software.opensuse.org/121/en? It should not matter whether you use the 
32- or 64-bit version. After you boot it, use the NetworkManager system tray 
applet to connect to your system. Does that work?

Next, use 'ps ax' to get the PID for NetworkManager and kill it. Then try your 
iwconfig/ifconfig command sequence. Does that work?

Both sets of connection methods work here. I used the 64-bit system with my 
Rosewill device.

Larry
