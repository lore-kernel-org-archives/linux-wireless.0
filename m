Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f45.google.com ([209.85.219.45]:48330 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751689AbaEOOub (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 May 2014 10:50:31 -0400
Received: by mail-oa0-f45.google.com with SMTP id l6so1379934oag.18
        for <linux-wireless@vger.kernel.org>; Thu, 15 May 2014 07:50:31 -0700 (PDT)
Message-ID: <5374D435.3000209@lwfinger.net> (sfid-20140515_165036_555120_96C43E30)
Date: Thu, 15 May 2014 09:50:29 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Kernel binary for RTL8192EE - Release Version 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This mail is blind copied to everyone that has contacted me regarding a driver 
for the RTL8192EE, and to the Realtek developers.

Although the patches needed to add this driver to the 3.14.X kernel were made 
available earlier, not everyone has the expertise needed to build a kernel for 
their system. As the Lenovo T440s is the only computer that currently is 
shipping with this device, and Lenovo uses Ubuntu 14.04, I have built such a 
patched kernel and I am making is available. This one uses the official 3.13.3 
source currently in use by Ubuntu and includes all of their patches.

An updated version is available at 
http://www.lwfinger.com/realtek_drivers/linux-image-3.13.9_1.0_amd64.deb. After 
downloading, this kernel is installed using the command 'sudo dpkg -i 
<path_to_downloaded_deb_file>

The main difference between version 0.9 and 1.0 is in the handling of the cases 
when the driver reports messages of the form "skb->end - skb->tail = 16000, len 
is 16174". The new version reports only the first 10 of these, and also dumps 
some important data. If you see any of these, send that portion of the logs to me.

Larry
