Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f53.google.com ([74.125.83.53]:50909 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753797Ab3JNH5t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Oct 2013 03:57:49 -0400
Received: by mail-ee0-f53.google.com with SMTP id b15so3201585eek.40
        for <linux-wireless@vger.kernel.org>; Mon, 14 Oct 2013 00:57:48 -0700 (PDT)
Message-ID: <525BA3F9.5070900@gmail.com> (sfid-20131014_095752_949025_BCE83BA5)
Date: Mon, 14 Oct 2013 09:57:45 +0200
From: Hans de Jonge <j.dejonge@gmail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Getting the Sitecom WLA-2102 running with the rtl8192cu driver? (add
 its USB ID)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi list,

In the course of this year I acquired a Sitecom N300 (WLA-2102) USB Wifi 
adapter with a USB vendor,device ID:
0x0DF6,0x0070

According to a post on a german site, it is claimed that  the device can 
be set  to run through the Realtek 8192CU driver and that this can be 
achieved by adding the id at the appropriate place in the source code, 
which I recognise as "the
same list as where the device with ID= 0x0DF6,0x0061 is added.

In the latest stable kernel source (3.11.4) I was able to identify this 
to be situated in the file:
linux-3.11.4/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c

Hence I my question whether it is possible to add the id as suggested in 
the german post
(http://forum.ubuntuusers.de/topic/wi-fi-usb-adapter-n300-wla-2102-8192cu/)
in order get the device running in the next kernel version?

Since I myself stopped compiling my own custom kernels a few years ago. 
(In favour of (automagically updated) Debian testing distribution 
kernels), I have not yet tried to implement the modification in a 
home-brewn kernel, but given clear indication on how to rebuild a 
distribution kernel image package with just that one modification, I 
would love to give that a try and test it.

Yours,
Hans de Jonge
