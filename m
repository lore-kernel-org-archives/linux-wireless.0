Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f54.google.com ([209.85.219.54]:61096 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992AbaGDSlX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Jul 2014 14:41:23 -0400
Received: by mail-oa0-f54.google.com with SMTP id eb12so2132006oac.27
        for <linux-wireless@vger.kernel.org>; Fri, 04 Jul 2014 11:41:23 -0700 (PDT)
Message-ID: <53B6F558.70904@lwfinger.net> (sfid-20140704_204224_984506_EDA238D3)
Date: Fri, 04 Jul 2014 13:41:28 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Alex Henrie <alexhenrie24@gmail.com>
CC: Lorenzo Pistone <blaffablaffa@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Arliton Rocha <arliton@gmail.com>
Subject: Linux driver for RTL8190P
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

To all that are concerned:

Alex Henrie provided me with a PCI card that contains the Realtek RTL8190P chip. 
I am in the process of converting it to a form that could be submitted for 
inclusion in the staging tree of the kernel. As that will be a lengthy process, 
I have placed the current code at http://github.com/lwfinger/rtl8190p.git. Using 
the "git clone" command with that URL will get you a copy. Use the standard 
"make" and "sudo make install" to install the driver and the firmware. At 
present, I am building with kernel 3.11.10. There may be incompatibilities with 
newer versions. If so, please let me know.

The current version works on my WPA2 network - it has not been tested with any 
other encryption. As with most Realtek drivers, it is very chatty and will 
pollute your logs. My next cleanup will be to correct that, and add a module 
parameter that allows dynamic debugging, but I have some other things to do.

Thanks to Alex,

Larry
