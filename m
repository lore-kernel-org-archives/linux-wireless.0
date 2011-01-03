Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web31502.mail.mud.yahoo.com ([68.142.198.131]:40499 "HELO
	web31502.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752513Ab1ACCpV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Jan 2011 21:45:21 -0500
Message-ID: <651997.51284.qm@web31502.mail.mud.yahoo.com>
Date: Sun, 2 Jan 2011 18:38:38 -0800 (PST)
From: Ming-Ching Tiew <mctiew@yahoo.com>
Subject: Tp-link wn7200nd - cannot associate
To: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


I have a TP-LINK WN7200ND, I am tested it with Kernel 2.6.36.1 and 2.6.35.10, basically after inserting the USB, the interface is up and it can never associate with any access point.

#lsmod |grep rt2

rt2800usb               7632  0 
rt2800lib              20328  1 rt2800usb
rt2x00usb               4628  2 rt2800usb,rt2800lib
rt2x00lib              15408  2 rt2800lib,rt2x00usb
mac80211              122068  2 rt2x00usb,rt2x00lib
cfg80211               92252  2 rt2x00lib,mac80211

There are a lot of similar complaints on the net, this is one example :-

http://ubuntuforums.org/showthread.php?t=1530095

There don't seem to be any issue with 'iwlist wlanX scan'. But just can't associate. 

Any recommendation ? Any debug information I should provide ?

Regards



      
