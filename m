Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:48594 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751447Ab0KWOi5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Nov 2010 09:38:57 -0500
Received: by ewy5 with SMTP id 5so2458158ewy.19
        for <linux-wireless@vger.kernel.org>; Tue, 23 Nov 2010 06:38:56 -0800 (PST)
Message-ID: <4CEBD1F3.4030007@gmail.com>
Date: Tue, 23 Nov 2010 16:38:43 +0200
From: Sleijeri <sleijeri@gmail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: ar9170usb broken partly 2.6.36
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It appears to me that latest Arch linux kernel26-2.6.36-x and my atheros 
based card Dlink DWA-160A (ar9170usb) have a little problems with 
connection. iwconfig appeared to show 300Mb/s-1Mb/s speed. As what i 
have read about the driver ar9170usb doesn't yet support 802.11n ? But 
if there is upgrade its not working right for me. My connection is very 
unstable and very slow due this. Connection speed to router and so forth 
is around 1kb/s - 27kb/s ping is between 200 - 10000. Problem appears to 
be greater during the load of network.
Problem disappeared while dropped kernel to verion 2.6.35.8-1 (arch 
linux kernel). Dmesg is clear of errors.
