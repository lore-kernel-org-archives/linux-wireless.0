Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:26713 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755069AbYFMOdt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Jun 2008 10:33:49 -0400
Received: by fg-out-1718.google.com with SMTP id 19so2777883fgg.17
        for <linux-wireless@vger.kernel.org>; Fri, 13 Jun 2008 07:33:47 -0700 (PDT)
Message-ID: <48528542.5080605@gmail.com> (sfid-20080613_163352_323778_99DC94C5)
Date: Fri, 13 Jun 2008 16:33:38 +0200
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Problem with rt73usb and previously booted windows
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
From: =?ISO-8859-1?Q?Christian_Sch=E4fer?= <schaefec@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

there seems to be a problem with rt73usb when Linux is booted right 
after Windows. Association with my ap (WPA) is working fine and the 
interface is getting an IP via dhcp, however the network seems dead 
since pinging my ap (and further) doesn't work. I have to rmmod rt73usb, 
replug the network card and modprobe rt73usb again for fully working 
network. This situation is present in kernel 2.6.26-rc5 and -rc6.

lsusb gives
148f:2573 Ralink Technology, Corp. RT2501USB Wireless Adapter

Let me know if you need further info and please CC to me since I'm not 
on the list. Thanks.

Chris
