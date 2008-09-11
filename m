Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:39873 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753061AbYIKPGM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Sep 2008 11:06:12 -0400
Subject: Re: Crash with 2.6.27-rc6 with iwlwifi
From: Marcel Holtmann <holtmann@linux.intel.com>
To: Zhu Yi <yi.zhu@intel.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1221123779.2513.88.camel@debian.sh.intel.com>
References: <E3A88D93-F0D2-476E-B162-08687FC602E3@linux.intel.com>
	 <1221123779.2513.88.camel@debian.sh.intel.com>
Content-Type: text/plain
Date: Thu, 11 Sep 2008 17:06:42 +0200
Message-Id: <1221145602.6309.17.camel@californication> (sfid-20080911_170622_013731_ED651A13)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Yi,

> > However I tried to reproduce it without Bluetooth enabled, it didn't  
> > show or I didn't wait long enough. Once I started bluetoothd it showed  
> > within a few minutes.
> > 
> > So the best I got was the attached screenshot of an oops. It is  
> > clearly the iwlwifi driver crashing here and killing the machine, but  
> > I have no idea why.
> 
> >From the screenshot line:
> 
> iwl_tx_cmd_complete+0x43/0x245
> 
> It should be triggered by the BUG_ON() in the function. Are you able to
> confirm it with netconsole or maybe even a frame buffer enabled console
> (it just shows more lines)? If this is the culprit, Tomas has been
> already working on it. But your BT coexist finding should help us
> reproducing the bug.
> http://www.intellinuxwireless.org/bugzilla/show_bug.cgi?id=1703

right now the screenshot is the best I can do. This is a X61 and so I am
limited in what I can give you. Getting the screenshot was tricky enough
since most of the times is just crashes in the background and getting
this re-produced on the console is not as simple as I thought. When
working inside GNOME, it crashes from between 30 minutes or 2 hours
without any warning.

I am not sure if I am the only with this issue, but it looks like a
serious regression that needs to be fixed before 2.6.27 goes out.

Regards

Marcel


